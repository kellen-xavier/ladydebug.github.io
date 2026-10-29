# My new Blog

[Deploy](https://kellen-xavier.github.io/ladydebug.github.io/)

## Started

This project is my person notebook where I'm describ about my studies on Linux
Programming and Quality. This is not a tutorials. This is my daily study, buildin my portfolio know.

Well ok. Where from this idea? Good, this ideia emerge from the book The Programatic Programmer.
Specifically, of the chapter one [get to know the book here](https://www.amazon.com.br/Programador-Pragm%C3%A1tico-Aprendiz-Mestre/dp/8577807002).

## Run this Project

Preview with:

`hugo server -D -F`

Use the language button to select English. Hugo connects the matching files automatically; it does not translate the text for you.

Before publishing, run:

bundle exec ruby scripts/test_multilingual.rb
bundle exec mdl content README.md
hugo --gc --minify

## Testando localmente

**Pré-requisitos:** [Hugo extended](https://gohugo.io/installation/) `0.147.9`+
e [Go](https://go.dev/dl/) (só é usado pra baixar o tema via Hugo Modules,
não tem código Go no projeto). Se preferir não instalar nada na sua máquina,
o repo já vem pronto pra abrir num Dev Container (`.devcontainer/`) ou no
[Gitpod](https://gitpod.io/#https://github.com/kellen-xavier/ladydebug.github.io) —
os dois sobem o ambiente completo (Hugo, Go, Ruby) sozinhos.

```bash
git clone https://github.com/kellen-xavier/ladydebug.github.io.git
cd ladydebug.github.io

# baixa o tema (Hextra) via Hugo Modules
hugo mod tidy

# sobe o servidor local com live reload
hugo server -D -F
```

Abra [http://localhost:1313/](http://localhost:1313/). `-D` mostra posts marcados como `draft: true`
e `-F` mostra posts com data no futuro — assim dá pra revisar tudo antes de
publicar. Qualquer mudança em `content/`, `layouts/`, `assets/` ou
`data/` recarrega a página sozinha.

Antes de abrir um PR, vale rodar também o [lint](#lint-de-markdown) e um build
de produção igual ao do CI, pra pegar erro de template que só aparece com
`--minify`:

```bash
hugo --gc --minify
```

## Criando um post novo

```bash
ruby scripts/new_post.rb "Título do post" "tag1, tag2"
```

Gera `content/docs/<ano>/<mês em português>/<slug>.md` (criando as pastas de
ano/mês se ainda não existirem) com o front matter já preenchido — `title`,
`date` (data de hoje), `slug` (gerado a partir do título) e `tags` — e
`draft: true`. Título e tags também podem ser omitidos na chamada: o script
pergunta interativamente. Quando o post estiver pronto pra publicar, troque
`draft: true` para `draft: false` manualmente.

## Lint de Markdown

Os posts são checados com o [`mdl`](https://github.com/markdownlint/markdownlint) (regras em
`.mdl_style.rb`). Roda automaticamente em todo PR e push para `develop`/`main`
(`.github/workflows/lint.yaml`); para rodar localmente:

```bash
bundle install
bundle exec mdl content README.md
```

O `mdl` só aponta os problemas, não corrige. Pra corrigir automaticamente o que dá pra
corrigir sem risco (ver `scripts/fix_markdown.rb` pra saber exatamente o quê):

```bash
bundle exec ruby scripts/fix_markdown.rb
```

## Português e inglês com o seletor nativo

O blog usa o modo multilíngue do Hugo e o seletor de idioma do tema Hextra.
O botão de idioma no cabeçalho abre as opções **Português** e **English**.
As páginas em português mantêm suas URLs; as versões em inglês ficam em `/en/`.
Menus, busca, RSS e os textos da página inicial acompanham o idioma selecionado.

O seletor abre a tradução do post atual. Quando ela ainda não existe, o tema
leva à página inicial do idioma escolhido. A troca funciona localmente e não
depende de um serviço externo de tradução.

As traduções são arquivos Markdown separados, com o mesmo nome e o sufixo `.en`:

```text
content/docs/2026/outubro/meu-post.md
content/docs/2026/outubro/meu-post.en.md

content/docs/2026/julho/meu-projeto/index.md
content/docs/2026/julho/meu-projeto/index.en.md
```

Traduza o título e o conteúdo, preservando data, slug e estado de rascunho.
Em page bundles, o Hugo compartilha as imagens entre as traduções. Em posts
soltos com imagens externas ao bundle, use caminhos que resolvam também em `/en/`.
Os posts publicados já têm versões em inglês; rascunhos continuam como estão.
Novos posts precisam de uma versão `.en.md` antes de serem publicados.

### Testes do modo multilíngue

Com os mesmos pré-requisitos do blog, execute:

```bash
bundle exec ruby scripts/test_multilingual.rb
```

Os testes geram um site temporário e verificam o seletor nativo, a troca entre
posts equivalentes, o fallback sem tradução, URLs em subdiretórios, textos
localizados e imagens compartilhadas. Também verificam se cada post publicado
tem um arquivo em inglês. O workflow `multilingual.yaml` executa os testes nos
PRs e pushes para `develop` e `main`.

## Changelog e releases

O `CHANGELOG.md` (formato [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)) é gerado
automaticamente pelo [`git-cliff`](https://git-cliff.org/) a partir dos commits em
[Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, ...). Não é para
editar esse arquivo manualmente.

Quando `develop` é mergeada em `main`, o workflow `.github/workflows/release.yaml`:

1. calcula a próxima versão a partir dos commits desde a última tag;
2. atualiza o `CHANGELOG.md` e commita em `main`;
3. cria a tag `vX.Y.Z` e publica a GitHub Release com as notas dessa versão.

Se não houver commit relevante (`feat`/`fix`/...) desde a última tag, nada é publicado.

## Doca (dock) do rodapé

Barra fixa no rodapé com janelas flutuantes (`<dialog>`, arrastáveis, sem
libs), no estilo desktop/OS do fim dos anos 2000. Fica isolada do resto do
tema em arquivos próprios:

- `data/dock.yaml` — quais botões existem, rótulo, ícone e link do Spotify.
- `data/events.yaml` — lista de próximos eventos do painel "Calendário".
- `content/drafts/` — rascunhos (`hugo new drafts/nome.md`); cada um vira uma
  página própria, mas fica fora do blog, do RSS e do sitemap.
- `assets/css/desktop-dock.css` e `assets/js/desktop-dock.js` — estilo e
  comportamento, separados do `custom.css`/tema.

Pra trocar o link do Spotify ou adicionar um evento, é só editar os `.yaml`
acima — não precisa mexer nos templates.

Ícones: [Pixelarticons](https://github.com/halfmage/pixelarticons) (MIT).

Fonte: [Pixelify Sans](https://fonts.google.com/specimen/Pixelify+Sans) (OFL,
licença em `assets/font/pixelify-sans/OFL.txt`), self-hosted como WOFF2 —
usada só dentro da doca e das janelas, não no resto do site. Emitida via
`layouts/partials/custom/head-end.html` (não dá pra usar `url()` relativo
direto no `desktop-dock.css`, que é um CSS puro, sem processamento de Hugo).
