# My new Blog

[Deploy](https://kellen-xavier.github.io/ladydebug.github.io/)

## Started

This project is my person notebook where I'm describ about my studies on Linux
Programming and Quality. This is not a tutorials. This is my daily study, buildin my portfolio know.

Well ok. Where from this idea? Good, this ideia emerge from the book The Programatic Programmer.
Specifically, of the chapter one [get to know the book here](https://www.amazon.com.br/Programador-Pragm%C3%A1tico-Aprendiz-Mestre/dp/8577807002).

## Clone Runner and Testing

```bash
git clone https://github.com/kellen-xavier/ladydebug.github.io.git

cd ladydebug.github. io

hugo mod tidy

hugo server -D -F

```

## Lint de Markdown

Os posts são checados com o [`mdl`](https://github.com/markdownlint/markdownlint) (regras em
`.mdl_style.rb`). Roda automaticamente em todo PR e push para `develop`/`main`
(`.github/workflows/lint.yaml`); para rodar localmente:

```bash
bundle install
bundle exec mdl content README.md
```

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
