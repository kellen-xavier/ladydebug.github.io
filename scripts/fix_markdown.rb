#!/usr/bin/env ruby
# frozen_string_literal: true

# Corrige automaticamente os problemas mecânicos que o `mdl` (ver .mdlrc /
# .mdl_style.rb, o lint oficial do repo) aponta nos arquivos .md.
#
# Regras corrigidas automaticamente, e por quê é seguro fazer isso sem
# revisão humana:
#   MD010 - Hard tabs               -> troca por espaço, só nas linhas que o
#                                       mdl reportou.
#   MD026 - Trailing punctuation     -> remove pontuação do fim de headings,
#           in header                  só nas linhas reportadas.
#   MD036 - Emphasis used instead    -> "**Texto**" sozinho na linha vira
#           of a header                 "### Texto", só nas linhas
#                                       reportadas (não mexe em negrito que
#                                       o mdl não sinalizou).
#   MD014 - Dollar signs before      -> remove "$ " de blocos de código onde
#           commands without           TODAS as linhas têm o prefixo (ou
#           showing output              seja, não há saída de comando
#                                       misturada).
#   MD031 - Fenced code blocks       -> garante linha em branco antes/depois
#           should be surrounded       de cada bloco de código.
#           by blank lines
#   MD040 - Fenced code blocks       -> adiciona uma linguagem (heurística:
#           should have a language     "$ " no corpo -> bash; senão "text")
#           specified                  em blocos ```  sem linguagem.
#   MD022 - Headers should be        -> garante linha em branco antes/depois
#           surrounded by blank         da linha reportada.
#           lines
#   MD032 - Lists should be          -> garante linha em branco antes/depois
#           surrounded by blank         da linha reportada.
#           lines
#
# MD014/MD031/MD040 são aplicadas em todo bloco de código do arquivo: a
# condição de disparo de cada uma É a própria regra do mdl, então não tem
# como "corrigir demais" — só mexe onde already seria reportado. MD022/MD032
# só inserem linha em branco nas linhas que o mdl efetivamente reportou.
#
# Regras que exigem julgamento humano e este script NÃO toca (reindentar
# lista pode quebrar a estrutura, renumerar pode indicar que o bloco de
# código deveria estar aninhado no item da lista em vez de separado):
#   MD007 - Unordered list indentation
#   MD029 - Ordered list item prefix
#
# Uso:
#   bundle exec ruby scripts/fix_markdown.rb              # corrige e mostra o que sobrou
#   bundle exec ruby scripts/fix_markdown.rb --dry-run     # só mostra o que mudaria, não escreve nada
#   bundle exec ruby scripts/fix_markdown.rb caminho.md    # roda só num arquivo (ainda usa o mdl geral p/ MD036)

require 'open3'
require 'set'

MANUAL_ONLY_RULES = %w[MD007 MD029].freeze
DOLLAR_PREFIX = /^(\s*)\$ /.freeze
FENCE_OPEN = /^(\s*)```(\S*)\s*$/.freeze
FENCE_CLOSE = /^\s*```\s*$/.freeze

def run_mdl
  out, = Open3.capture2('bundle', 'exec', 'mdl', 'content')
  out
rescue Errno::ENOENT
  warn 'aviso: não encontrei `bundle` no PATH, pulando a leitura de violações do mdl (MD036 não será corrigido).'
  ''
end

# Agrupa violações como { "path/arquivo.md" => [[linha, "MD036"], ...] }
def parse_violations(mdl_output)
  violations = Hash.new { |h, k| h[k] = [] }
  mdl_output.each_line do |line|
    next unless line =~ /^(.+):(\d+): (MD\d+)/

    path = Regexp.last_match(1)
    lineno = Regexp.last_match(2).to_i
    rule = Regexp.last_match(3)
    violations[path] << [lineno, rule]
  end
  violations
end

# MD010 e MD026: corrige só as linhas exatas que o mdl reportou (1:1, sem
# inserir/remover linha nenhuma, então não desalinha os outros números).
def fix_reported_line!(lines, lineno, rule)
  idx = lineno - 1
  return unless lines[idx]

  case rule
  when 'MD010'
    lines[idx] = lines[idx].tr("\t", ' ')
  when 'MD026'
    lines[idx] = lines[idx].sub(/^(#{'#'}{1,6}\s+.*?)[.,;:!]+(\s*)$/, '\1\2')
  when 'MD036'
    if lines[idx] =~ /^\*\*([^*\n]+)\*\*\s*$/
      lines[idx] = "### #{Regexp.last_match(1)}"
    end
  end
end

# MD014 + MD031 + MD040: passada única pelo arquivo tratando cada bloco de
# código como unidade (blank line antes/depois, linguagem, prefixo "$ ").
def normalize_fences(lines)
  out = []
  in_fence = false
  fence_open_out_idx = nil

  lines.each do |line|
    if !in_fence && (m = FENCE_OPEN.match(line))
      out << '' unless out.empty? || out.last.strip.empty?
      indent = m[1]
      lang = m[2]
      lang = guess_lang(lines) if lang.nil? || lang.empty?
      out << "#{indent}```#{lang}"
      in_fence = true
      fence_open_out_idx = out.size - 1
      next
    end

    if in_fence && FENCE_CLOSE.match?(line)
      body = out[(fence_open_out_idx + 1)..] || []
      if !body.empty? && body.all? { |l| l.strip.empty? || l.lstrip.start_with?('$ ') }
        ((fence_open_out_idx + 1)...out.size).each do |i|
          out[i] = out[i].sub(DOLLAR_PREFIX, '\1')
        end
      end
      out << line
      out << ''
      in_fence = false
      next
    end

    out << line
  end

  # remove blank duplicada que a própria lógica acima pode ter deixado
  # colada em outra blank line já existente no arquivo original
  result = []
  out.each do |line|
    result << line unless line == '' && result.last == ''
  end
  result
end

def guess_lang(_lines)
  'text'
end

# MD022 + MD032: constrói o array de saída do zero, a partir dos números de
# linha ORIGINAIS -- nunca muta `lines` nem reusa índice já deslocado, então
# várias violações no mesmo arquivo não colidem entre si.
#
# MD022 (header) sempre reporta a própria linha do header, e o problema pode
# ser antes, depois, ou os dois -- então garantir os dois lados é seguro.
# MD032 (lista) sempre reporta a linha que precisa de branco ANTES dela (seja
# a primeira linha da lista, seja a primeira linha depois que a lista acaba)
# -- nunca "depois"; tratar como "depois" quebraria listas de vários itens.
def fix_blank_line_rules(lines, file_violations)
  before_lines = file_violations.select { |(_, r)| %w[MD022 MD032].include?(r) }.map { |(l, _)| l }.to_set
  after_lines = file_violations.select { |(_, r)| r == 'MD022' }.map { |(l, _)| l }.to_set
  return lines if before_lines.empty? && after_lines.empty?

  out = []
  lines.each_with_index do |line, i|
    lineno = i + 1
    out << '' if before_lines.include?(lineno) && !out.empty? && !out.last.strip.empty?
    out << line
    out << '' if after_lines.include?(lineno) && lines[i + 1] && !lines[i + 1].strip.empty?
  end
  out
end

files = ARGV.reject { |a| a.start_with?('--') }
dry_run = ARGV.include?('--dry-run')

mdl_output = run_mdl
violations = parse_violations(mdl_output)

target_paths = files.empty? ? violations.keys : files
changed = []

target_paths.each do |path|
  next unless File.exist?(path)

  original = File.read(path)
  lines = original.split("\n", -1)
  lines.pop if lines.last == '' && !original.end_with?("\n\n")

  (violations[path] || []).each do |lineno, rule|
    fix_reported_line!(lines, lineno, rule)
  end

  lines = fix_blank_line_rules(lines, violations[path] || [])
  fixed_lines = normalize_fences(lines)
  fixed = fixed_lines.join("\n")
  fixed += "\n" unless fixed.end_with?("\n")

  next if fixed == original

  changed << path
  File.write(path, fixed) unless dry_run
end

puts "#{dry_run ? '[dry-run] ' : ''}#{changed.size} arquivo(s) corrigido(s):"
changed.sort.each { |p| puts "  - #{p}" }

remaining = parse_violations(run_mdl)
manual = remaining.flat_map { |path, viols| viols.select { |(_, r)| MANUAL_ONLY_RULES.include?(r) }.map { |(l, r)| "#{path}:#{l} #{r}" } }
other = remaining.flat_map { |path, viols| viols.reject { |(_, r)| MANUAL_ONLY_RULES.include?(r) }.map { |(l, r)| "#{path}:#{l} #{r}" } }

unless manual.empty?
  puts "\nPrecisam de correção manual (mexem na estrutura da lista, risco de quebrar renderização):"
  manual.sort.each { |v| puts "  - #{v}" }
end

unless dry_run || other.empty?
  puts "\nAinda restaram (não bateram com nenhum padrão automático conhecido):"
  other.sort.each { |v| puts "  - #{v}" }
end
