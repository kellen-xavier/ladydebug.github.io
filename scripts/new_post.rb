#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'lib/post_layout'

begin
  date = Date.today
  OptionParser.new do |options|
    options.banner = 'Uso: ruby scripts/new_post.rb [--date AAAA-MM-DD] "Título" [tag1,tag2]'
    options.on('--date DATE', 'Data do post (padrão: hoje)') do |value|
      raise ArgumentError, 'Use uma data válida no formato AAAA-MM-DD.' unless value.match?(/\A\d{4}-\d{2}-\d{2}\z/)
      date = Date.iso8601(value)
    end
  end.parse!
  interactive = ARGV.empty?
  print('Título do post: ') if interactive
  title = interactive ? $stdin.gets&.strip : ARGV.shift
  raise ArgumentError, 'Título não pode ser vazio.' if title.nil? || title.strip.empty?
  print('Tags (separadas por vírgula): ') if interactive
  tags = (interactive ? $stdin.gets.to_s : ARGV.shift.to_s).split(',').map(&:strip).reject(&:empty?)
  raise ArgumentError, 'Argumentos excedentes.' unless ARGV.empty?
  slug = PostLayout.slugify(title)
  info = { 'title' => title, 'date' => date.iso8601, 'slug' => slug, 'tags' => tags, 'draft' => true }
  path = File.join(PostLayout::POSTS_ROOT, PostLayout.post_relative_path(info, "#{slug}.md"))
  raise ArgumentError, "Já existe um post em #{path}." if File.exist?(path)
  FileUtils.mkdir_p(File.dirname(path))
  PostLayout.ensure_images(File.join(PostLayout::POSTS_ROOT, PostLayout.month_relative_path(info)))
  File.open(path, File::WRONLY | File::CREAT | File::EXCL) { |file| file.write(info.to_yaml + "---\n\n") }
  puts "Post criado em #{path}"
  puts 'Imagens: ../images/nome-do-post--imagem.png'
  puts 'draft: true — troque para false quando terminar de escrever.'
rescue ArgumentError, OptionParser::ParseError => error
  abort(error.message)
end
