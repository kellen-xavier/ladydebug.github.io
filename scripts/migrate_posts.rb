#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'lib/post_layout'

begin
  apply = false
  OptionParser.new do |options|
    options.banner = 'Uso: ruby scripts/migrate_posts.rb [--apply] (sem opção: apenas simular)'
    options.on('--apply', 'Aplicar migração') { apply = true }
  end.parse!
  raise ArgumentError, 'Argumentos inesperados.' unless ARGV.empty?
  migration = PostLayout::Migration.new
  plan = migration.plan
  (plan[:posts] + plan[:images]).each do |entry|
    next if entry[:source] == entry[:target]
    puts "#{entry[:source].delete_prefix(PostLayout::POSTS_ROOT + '/')} -> #{entry[:target].delete_prefix(PostLayout::POSTS_ROOT + '/')}"
  end
  if apply
    puts migration.apply!.inspect
    PostLayout.validate!
  else
    puts 'Simulação: nenhum arquivo alterado. Use --apply para migrar.'
  end
rescue ArgumentError => error
  abort(error.message)
end
