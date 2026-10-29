#!/usr/bin/env ruby
# frozen_string_literal: true

# Cria um novo post em content/docs/<ano>/<mes-pt>/<slug>.md já com o front
# matter no formato usado pelo resto do blog (ver qualquer post existente em
# content/docs/), criando a pasta do ano/mês automaticamente se ainda não
# existir.
#
# Uso:
#   bundle exec ruby scripts/new_post.rb "Título do post" [tag1,tag2,...]
#
# Se o título não for passado como argumento, o script pergunta
# interativamente. Tags são opcionais (separadas por vírgula).
#
# draft sempre nasce como `true` — o fluxo é escrever o post, revisar, e só
# então trocar manualmente para `false` quando estiver pronto pra publicar
# (é isso que tira o post da lista "draft" e faz ele entrar no blog/RSS/sitemap).

require 'date'
require 'fileutils'

MESES_PT = %w[
  janeiro fevereiro marco abril maio junho
  julho agosto setembro outubro novembro dezembro
].freeze

ACCENTS = {
  'á' => 'a', 'à' => 'a', 'ã' => 'a', 'â' => 'a', 'ä' => 'a',
  'é' => 'e', 'è' => 'e', 'ê' => 'e', 'ë' => 'e',
  'í' => 'i', 'ì' => 'i', 'î' => 'i', 'ï' => 'i',
  'ó' => 'o', 'ò' => 'o', 'õ' => 'o', 'ô' => 'o', 'ö' => 'o',
  'ú' => 'u', 'ù' => 'u', 'û' => 'u', 'ü' => 'u',
  'ç' => 'c', 'ñ' => 'n'
}.freeze

def slugify(text)
  slug = text.downcase
  ACCENTS.each { |accented, plain| slug = slug.gsub(accented, plain) }
  slug = slug.gsub(/[^a-z0-9]+/, '-')
  slug.gsub(/^-+|-+$/, '')
end

def prompt(label)
  print("#{label}: ")
  $stdin.gets&.strip
end

title = ARGV[0] || prompt('Título do post')
abort('Título não pode ser vazio.') if title.nil? || title.strip.empty?

tags_arg = ARGV[1] || prompt('Tags (separadas por vírgula, pode deixar em branco)')
tags = (tags_arg || '').split(',').map(&:strip).reject(&:empty?)

today = Date.today
slug = slugify(title)
abort("Não foi possível gerar um slug a partir de \"#{title}\".") if slug.empty?

mes = MESES_PT[today.month - 1]
dir = File.join(__dir__, '..', 'content', 'docs', today.year.to_s, mes)
path = File.join(dir, "#{slug}.md")

if File.exist?(path)
  abort("Já existe um post em #{File.expand_path(path)} — escolha outro título ou apague o arquivo antigo.")
end

FileUtils.mkdir_p(dir)

tags_yaml = tags.empty? ? '[]' : "[#{tags.join(', ')}]"

front_matter = <<~MD
  ---
  title: "#{title}"
  date: #{today.strftime('%Y-%m-%d')}
  slug: #{slug}
  tags: #{tags_yaml}
  draft: true
  ---

MD

File.write(path, front_matter)

puts "Post criado em #{File.expand_path(path)}"
puts 'draft: true — troque para false quando terminar de escrever.'
