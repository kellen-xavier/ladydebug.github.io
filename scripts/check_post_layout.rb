#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/post_layout'

begin
  PostLayout.validate!
  puts 'PASS Estrutura dos posts: AAAA/mês/DD-MM/post.md e imagens mensais.'
rescue ArgumentError => error
  abort(error.message)
end
