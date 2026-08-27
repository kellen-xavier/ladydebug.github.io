all

# O <h1> de cada post vem do front matter (`title`), renderizado pelo tema
# Hextra — o corpo do markdown propositalmente começa em "##".
exclude_rule "MD002" # first header should be a top level header
exclude_rule "MD041" # first line in a file should be a top level header

# Prosa, não código — não faz sentido impor um limite fixo de coluna.
exclude_rule "MD013" # line length

# `goldmark.unsafe: true` no hugo.yaml permite HTML puro nos posts de propósito.
exclude_rule "MD033" # inline HTML

# Prefere numeração sequencial (1. 2. 3.) em vez do padrão do mdl (1. 1. 1.).
rule "MD029", :style => :ordered

