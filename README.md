# My Blog

My "blog" is a space where I document what I learn and the challenges I face, serving as a "knowledge portfolio." Much like the approach described in *The Pragmatic Programmer*, I view my studies as a continuous investment in my personal and professional growth. The concept is simple: regularly invest in new knowledge, diversify my skill set, and manage the risks associated with focusing on technologies that might eventually become obsolete. In short, it’s about writing and practicing as a way to facilitate my own learning.

[Learn about the book here: The Pragmatic Programmer: From Journeyman to Master](https://a.co/d/00da8YtH)

[Our here](https://github.com/CodesdaLu/Programming-Books/blob/main/o-programador-pragmatico.pdf)

[Deploy on my blog](https://kellen-xavier.github.io/ladydebug.github.io/)

## Navegação

- [Ambiente e execução local](#ambiente-e-execução-local)
- [Comandos e scripts do projeto](#comandos-e-scripts-do-projeto)
- [Criando um post novo](#criando-um-post-novo)
- [Português e inglês](#português-e-inglês-com-o-seletor-nativo)
- [Testes](#testes)
- [Comandos de testes e validação](#comandos-de-testes-e-validação)
- [Changelog e releases](#changelog-e-releases)

## Started

This project is my person notebook where I'm describ about my studies on Linux
Programming and Quality. This is not a tutorials. This is my daily study, buildin my portfolio know.

Well ok. Where from this idea? Good, this ideia emerge from the book The Programatic Programmer.
Specifically, of the chapter one [get to know the book here](https://www.amazon.com.br/Programador-Pragm%C3%A1tico-Aprendiz-Mestre/dp/8577807002).

## Run this Project

Preview with:

`hugo server -D -F`

Use the language button to select English. Hugo connects the matching files automatically; it does not translate the text for you.

Antes de publicar, execute a [verificação completa](#executar-todas-as-verificações).
Consulte também a [tabela de comandos do projeto](#comandos-e-scripts-do-projeto).

## Ambiente e execução local

**Pré-requisitos:** [Hugo extended](https://gohugo.io/installation/) `0.147.9`+
e [Go](https://go.dev/dl/) (só é usado pra baixar o tema via Hugo Modules,
não tem código Go no projeto). Se preferir não instalar nada na sua máquina,
o repo já vem pronto pra abrir num Dev Container (`.devcontainer/`) ou no
[Gitpod](https://gitpod.io/#https://github.com/kellen-xavier/ladydebug.github.io) —
os dois preparam Hugo, Go e Ruby. Para executar todas as verificações, use
Ruby `3.3` com Bundler e Node.js `24`, como nos workflows de CI.
Instale as dependências Ruby com `bundle install`; os testes JavaScript usam
o executor nativo do Node.js, sem instalação de pacotes npm.

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

Antes de abrir um PR, siga a [sequência de testes e validações](#executar-todas-as-verificações).

## Comandos e Scripts do Projeto

Execute os comandos a partir da raiz do repositório. As verificações ficam
separadas na [tabela de comandos de testes](#comandos-de-testes-e-validação),
com a [descrição de cada suíte](#testes).

| Comando | Script ou ferramenta | Para que serve |
| --- | --- | --- |
| `git clone https://github.com/kellen-xavier/ladydebug.github.io.git` | Git | Baixar o repositório para a máquina local. |
| `cd ladydebug.github.io` | Shell | Entrar na raiz do projeto após clonar. |
| `bundle install` | [Gemfile](Gemfile) | Instalar o `mdl` e suas dependências Ruby. |
| `hugo mod tidy` | Hugo Modules; [go.mod](go.mod) | Resolver o tema Hextra e atualizar os arquivos de módulos quando necessário. Requer Go no `PATH`. |
| `hugo server -D -F` | Hugo | Abrir a prévia em `http://localhost:1313/`, incluindo rascunhos e posts futuros, com recarga automática. |
| `hugo --gc --minify` | Hugo | Gerar o site de produção em `public/`, respeitando as regras de publicação dos posts. |
| `ruby scripts/new_post.rb` | [new_post.rb](scripts/new_post.rb) | Criar um post com a data de hoje, perguntando título e tags. |
| `ruby scripts/new_post.rb "Título" "tag1, tag2"` | [new_post.rb](scripts/new_post.rb) | Criar um post com título e tags informados, como rascunho. |
| `ruby scripts/new_post.rb --date 2023-02-04 "Título" "tag1, tag2"` | [new_post.rb](scripts/new_post.rb) | Criar um post com uma data específica. As tags são opcionais. |
| `ruby scripts/new_post.rb --help` | [new_post.rb](scripts/new_post.rb) | Consultar as opções do criador. |
| `hugo new drafts/nome.md` | Hugo | Criar uma página na área de rascunhos da doca, separada dos posts em `content/docs/`. |
| `ruby scripts/migrate_posts.rb` | [migrate_posts.rb](scripts/migrate_posts.rb) | Simular a reorganização de posts e imagens, mostrando os destinos sem alterar arquivos. |
| `ruby scripts/migrate_posts.rb --apply` | [migrate_posts.rb](scripts/migrate_posts.rb) | Aplicar a reorganização, ajustando imagens e referências entre posts. |
| `ruby scripts/migrate_posts.rb --help` | [migrate_posts.rb](scripts/migrate_posts.rb) | Consultar as opções da migração. |
| `bundle exec ruby scripts/fix_markdown.rb --dry-run` | [fix_markdown.rb](scripts/fix_markdown.rb) | Mostrar as correções automáticas de Markdown sem gravar alterações. |
| `bundle exec ruby scripts/fix_markdown.rb` | [fix_markdown.rb](scripts/fix_markdown.rb) | Aplicar as correções automáticas e listar os problemas que exigem revisão manual. |
| `bundle exec ruby scripts/fix_markdown.rb content/docs/2023/fevereiro/04-02/meu-post.md` | [fix_markdown.rb](scripts/fix_markdown.rb) | Corrigir apenas o arquivo indicado; substitua o caminho pelo arquivo desejado. |

O módulo [scripts/lib/post_layout.rb](scripts/lib/post_layout.rb) concentra
as regras de nomes, datas e migração usadas pelos scripts. É uma biblioteca,
sem comando próprio para executar.

## Criando um post novo

```bash
ruby scripts/new_post.rb "Título do post" "tag1, tag2"
```

O script usa a data de hoje, cria as pastas e preenche título, data, slug,
tags e `draft: true`. Sem argumentos, pergunta o título e as tags.
Para registrar um texto antigo, informe a data original:

```bash
ruby scripts/new_post.rb --date 2023-02-04 "Meu post" "testes, desempenho"
```

Todos os posts seguem esta estrutura. Os meses usam apenas o nome em português, sem prefixo numérico e sem acentos.
As pastas dos dias seguem o formato `DD-MM`:

```text
content/docs/
└── 2023/
    └── fevereiro/
        ├── 04-02/
        │   ├── meu-post.md
        │   └── meu-post.en.md
        ├── 15-02/
        │   └── outro-post.md
        └── images/
            ├── meu-post--resultado.png
            └── outro-post--resultado.png
```

A pasta `04-02` significa **dia 04 de fevereiro**. Vários posts podem ficar
no mesmo dia, cada um com seu nome descritivo. As imagens ficam na pasta
`images` do mês, compartilhadas entre português e inglês. Use o nome do post
como prefixo da imagem para evitar colisões:

```markdown
![Resultado do teste](../images/meu-post--resultado.png)
```

A data do front matter determina a organização. Para publicar, revise o
texto e troque `draft: true` por `draft: false`. O criador recusa datas inválidas
e nunca sobrescreve um post existente. Os arquivos `_index.md` e `_index.en.md`
da seção `docs` continuam sendo índices da seção.

### Migrar e conferir a estrutura

Os posts existentes foram reorganizados mantendo suas URLs no campo `url`
do front matter. Preserve esse campo ao editar ou traduzir esses textos.
A migração ajusta referências de imagens e `relref`, mantém os arquivos de
imagem e recusa colisões entre posts antes de gravar.

```bash
# Apenas mostrar os destinos, sem alterar arquivos
ruby scripts/migrate_posts.rb

# Aplicar a migração em conteúdo importado no formato antigo
ruby scripts/migrate_posts.rb --apply
```

Os scripts encontram a raiz do projeto pela própria localização, mesmo quando
chamados de outro diretório. O CI verifica a estrutura, a criação de posts,
a segurança da migração e as imagens nas traduções. Veja os
[testes de organização dos posts](#organização-criação-e-migração-de-posts).

## Lint de Markdown

As regras de escrita ficam em [.mdl_style.rb](.mdl_style.rb). O lint aponta
problemas de formatação; a explicação e o comando estão em
[Lint e build do site](#lint-e-build-do-site). Para aplicar correções automáticas,
consulte os comandos de `fix_markdown.rb` na [tabela do projeto](#comandos-e-scripts-do-projeto).

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
content/docs/2026/outubro/29-10/meu-post.md
content/docs/2026/outubro/29-10/meu-post.en.md
```

Traduza o título e o conteúdo, preservando data, slug e estado de rascunho.
Nos posts migrados, mantenha a URL original do português e use a mesma URL
com o prefixo `/en/` na tradução. Por exemplo, `url: /docs/meu-post/`
e `url: /en/docs/meu-post/`. Posts novos não precisam desse campo.
Ambos os idiomas usam `../images/nome-do-post--imagem.png`, com uma única
cópia de cada imagem na pasta do mês.
Os posts publicados já têm versões em inglês; rascunhos continuam como estão.
Novos posts precisam de uma versão `.en.md` antes de serem publicados.

Os cenários cobertos pelo seletor e pelas traduções estão descritos nos
[testes de integração multilíngue](#integração-multilíngue).

## Testes

Esta seção reúne os testes automatizados e as validações do blog.
Os comandos usam os pré-requisitos de [Ambiente e execução local](#ambiente-e-execução-local).
Execute-os na raiz do projeto, após `bundle install`.

Os testes Ruby usam verificações próprias com mensagens `PASS`/`FAIL`;
os JavaScript usam `node:test`. Uma falha encerra o comando com código diferente
de zero. Os testes de migração e integração criam arquivos em diretórios
temporários; a validação de estrutura e o lint leem o conteúdo real do blog.

### Comandos de testes e validação

| Comando | Arquivo ou ferramenta | O que verifica |
| --- | --- | --- |
| `bundle exec ruby scripts/test_post_layout.rb` | [test_post_layout.rb](scripts/test_post_layout.rb) | [Organização, criação e migração de posts](#organização-criação-e-migração-de-posts), com exemplos temporários. |
| `bundle exec ruby scripts/check_post_layout.rb` | [check_post_layout.rb](scripts/check_post_layout.rb) | [Estrutura do acervo real](#estrutura-do-acervo-real), incluindo as pastas de imagens. |
| `bundle exec ruby scripts/test_go_modules.rb` | [test_go_modules.rb](scripts/test_go_modules.rb) | [Regressão de módulos Go](#módulos-go-e-vendoring), reproduzindo `vendor/bundle`. |
| `bundle exec ruby scripts/test_multilingual.rb` | [test_multilingual.rb](scripts/test_multilingual.rb) | [Integração multilíngue](#integração-multilíngue), com builds Hugo temporários. |
| `node --test tests/*.test.cjs` | [tests/](tests/) | Executar todas as suítes JavaScript: calendário, cursor e cores dos links. |
| `node --test tests/calendar.test.cjs` | [calendar.test.cjs](tests/calendar.test.cjs) | [Calendário](#testes-do-calendário), isoladamente. |
| `node --test tests/cursor-trail.test.cjs` | [cursor-trail.test.cjs](tests/cursor-trail.test.cjs) | [Brilho no cursor](#testes-do-brilho-no-cursor), isoladamente. |
| `node --test tests/link-colors.test.cjs` | [link-colors.test.cjs](tests/link-colors.test.cjs) | [Cores dos links](#testes-das-cores-dos-links), isoladamente. |
| `bundle exec mdl content README.md` | `mdl`; [.mdl_style.rb](.mdl_style.rb) | [Lint de Markdown](#lint-e-build-do-site), sem corrigir arquivos. |
| `hugo --gc --minify` | Hugo | [Build de produção](#lint-e-build-do-site), com saída em `public/`. |
| `hugo --buildDrafts --buildFuture --minify --destination /tmp/ladydebug-content-check` | Hugo | [Build de todo o conteúdo](#lint-e-build-do-site), incluindo rascunhos e datas futuras. |

[Voltar aos comandos do projeto](#comandos-e-scripts-do-projeto).

### Organização, criação e migração de posts

Arquivo: [scripts/test_post_layout.rb](scripts/test_post_layout.rb).

- Confere o padrão `ano/mês/DD-MM/nome-do-post.md` e a versão `.en.md`, sem número antes do nome do mês.
- Executa o criador com uma data histórica e verifica título com acentos, aspas, tags e `draft: true` no YAML.
- Permite vários posts no mesmo dia e recusa nomes duplicados sem sobrescrever conteúdo.
- Rejeita datas inválidas antes de criar pastas.
- Migra posts e traduções preservando data, URLs e conteúdo dos arquivos de imagem, inclusive imagens com nomes repetidos.
- Preserva legendas, parâmetros de consulta e fragmentos nas referências das imagens.
- Rejeita pastas de mês com prefixo numérico e testa sua migração sem renomear imagens mensais já organizadas.
- Confirma que simular a migração não altera arquivos e que aplicá-la novamente não modifica o resultado.
- Recusa colisões de destino antes de mover ou apagar os arquivos de origem.

### Estrutura do acervo real

Arquivo: [scripts/check_post_layout.rb](scripts/check_post_layout.rb).

Percorre `content/docs/` e confere se o caminho de cada post corresponde à data
do front matter e ao padrão de nomes. Verifica se as imagens estão diretamente
em `ano/mês/images/`, com um nome de mês válido. Os índices `_index.md` e
`_index.en.md` da seção são exceções previstas. Diferentemente dos testes com
exemplos temporários, esta validação detecta arquivos reais fora do padrão.

### Módulos Go e vendoring

Arquivo: [scripts/test_go_modules.rb](scripts/test_go_modules.rb).

Reproduz em um diretório temporário a pasta `vendor/bundle` criada pelo Bundler.
Usa o `GOFLAGS` definido no workflow multilíngue e executa `go list -m -json all`.
Confirma que o tema Hextra é resolvido e que `go.mod` e `go.sum` permanecem iguais.
Esse teste cobre a regressão de CI com a mensagem `inconsistent vendoring`.
Requer Go no `PATH` e acesso aos módulos, por cache ou rede.

### Integração multilíngue

Arquivo: [scripts/test_multilingual.rb](scripts/test_multilingual.rb).

Gera sites temporários com Hugo, tanto na raiz do domínio quanto sob `/blog/`,
e inspeciona o HTML resultante. Os cenários incluem:

- URLs originais do português e prefixo `/en/` para o inglês.
- Seletor nativo com semântica acessível e troca entre as versões do mesmo post.
- Retorno à página inicial do idioma quando não existe tradução.
- Links de idioma funcionando em hospedagem sob um subdiretório.
- Página inicial em inglês com posts, rótulos e meses no idioma correto.
- Imagens mensais compartilhadas pelos dois idiomas, com arquivos de destino válidos e URLs antigas dos posts preservadas.
- Ausência da antiga integração externa com Google Translate.
- Nomes acessíveis dos botões da doca mesmo quando os rótulos visuais ficam ocultos.
- Existência de um arquivo `.en.md` para cada post publicado do acervo real.
- Controles e dados do calendário localizados, preservando a data do evento.
- Inclusão dos arquivos do brilho no cursor e preservação da doca no HTML.

### Testes do calendário

Arquivo: [tests/calendar.test.cjs](tests/calendar.test.cjs).

- Fevereiro em anos bissextos e não bissextos.
- Alinhamento dos dias da semana e preenchimento da grade mensal, inclusive meses que começam no domingo.
- Navegação entre meses atravessando a mudança de ano.
- Data de hoje conforme o horário local do visitante.
- Seleção de todos os eventos de um dia, sem incluir eventos de outras datas.
- Rótulos em português e inglês sem deslocar o dia selecionado.
- Aceitação de links web e rejeição de URLs executáveis ou malformadas nos eventos.

### Testes do brilho no cursor

Arquivo: [tests/cursor-trail.test.cjs](tests/cursor-trail.test.cjs).

- Criação de partículas nas coordenadas do mouse.
- Ausência de partículas para toque, caneta, dispositivos apenas de toque e preferência de movimento reduzido.
- Funcionamento de eventos reais de mouse quando o navegador não informa o tipo de dispositivo.
- Limites de frequência, quantidade e tempo de vida das partículas.
- Limpeza das partículas ao mudar a preferência de movimento, sair da página ou ocultar a aba.
- Remoção de partículas, temporizadores e eventos ao destruir o efeito.

### Testes das cores dos links

Arquivo: [tests/link-colors.test.cjs](tests/link-colors.test.cjs).

Verifica se as cores dos links nos temas claro e escuro pertencem à família
de cores de destaque do blog. É uma checagem da paleta definida no CSS;
não compara capturas de tela nem valida contraste ou aparência em navegadores.

### Lint e build do site

O `mdl` verifica a formatação dos posts e deste README conforme
[.mdl_style.rb](.mdl_style.rb). Não modifica arquivos; para corrigir problemas,
use os [comandos de manutenção do Markdown](#comandos-e-scripts-do-projeto).

O build de produção verifica se o Hugo consegue gerar o site publicável.
O build com `--buildDrafts --buildFuture` inclui também conteúdo que ficaria
oculto na produção e pode revelar erros de template, referências ou front matter
nesses posts. A opção `--destination` permite gravar essa saída fora do projeto.

Os testes JavaScript verificam comportamento com objetos simulados; os de
integração inspecionam HTML gerado. Eles não substituem a revisão visual no
navegador, em português e inglês, nos temas claro e escuro e em telas menores.

### Executar todas as verificações

Após instalar as dependências, execute a sequência abaixo antes de abrir um PR.
O `set -e` interrompe a sequência na primeira falha:

```bash
set -e
bundle exec ruby scripts/test_post_layout.rb
bundle exec ruby scripts/check_post_layout.rb
bundle exec ruby scripts/test_go_modules.rb
bundle exec ruby scripts/test_multilingual.rb
node --test tests/*.test.cjs
bundle exec mdl content README.md
hugo --gc --minify
hugo --buildDrafts --buildFuture --minify --destination /tmp/ladydebug-content-check
```

Para uma correção de comportamento, siga TDD: primeiro escreva o teste e
confirme a falha, implemente a mudança e execute novamente a suíte afetada.
Antes de concluir, rode as verificações acima.

### Testes no CI

Estes workflows rodam em PRs e em pushes para `develop` e `main`:

| Workflow | Verificações |
| --- | --- |
| [multilingual.yaml](.github/workflows/multilingual.yaml) | Módulos Go, criação e migração de posts, estrutura do acervo, integração multilíngue e build incluindo rascunhos e posts futuros. |
| [calendar-tests.yaml](.github/workflows/calendar-tests.yaml) | Todas as suítes JavaScript, incluindo calendário, cursor e cores dos links. |
| [lint.yaml](.github/workflows/lint.yaml) | Lint de `content/` e `README.md`. |

O [deploy](.github/workflows/pages.yaml) e a
[release](.github/workflows/release.yaml) são automações separadas acionadas
por pushes em `main`; não substituem as verificações listadas aqui.

[Voltar aos comandos de testes](#comandos-de-testes-e-validação) ·
[Voltar aos comandos do projeto](#comandos-e-scripts-do-projeto).

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

### Calendário

O botão **Calendário** abre a mesma janela da doca, com uma grade mensal.
As setas mudam o mês; **Hoje** volta ao dia atual no fuso do visitante.
O dia atual tem uma borda e os dias com eventos têm um ponto. Clique em um dia
para ver seus eventos. A interface acompanha o idioma do blog.

Para adicionar eventos, substitua o `[]` de `data/events.yaml` por uma lista:

```yaml
- date: "2026-11-10"
  title: "Meu evento"
  title_en: "My event"
  url: "https://example.com/evento"
```

`title_en` e `url` são opcionais. Eventos antigos continuam disponíveis ao
navegar pelos meses. As alterações aparecem depois do build e deploy do blog.
O calendário funciona sem serviços externos; sem JavaScript, a janela mostra
uma lista dos eventos cadastrados.

A cobertura está descrita em [Testes do calendário](#testes-do-calendário)
e [Integração multilíngue](#integração-multilíngue). Os comandos ficam na
[tabela de testes](#comandos-de-testes-e-validação).

Ícones: [Pixelarticons](https://github.com/halfmage/pixelarticons) (MIT).

### Brilho no cursor

O movimento do mouse deixa uma trilha discreta de estrelas rosas e douradas.
As partículas duram 600 ms, com no máximo 12 visíveis ao mesmo tempo, e não
interceptam cliques nem alteram o layout. O efeito fica desativado para toque,
caneta e preferência de movimento reduzido do sistema.

Os arquivos são `assets/js/cursor-trail.js` e `assets/css/cursor-trail-style.css`.
A cobertura está descrita em [Testes do brilho no cursor](#testes-do-brilho-no-cursor).
Consulte os [comandos de testes](#comandos-de-testes-e-validação) para executar a suíte.

Fonte: [Pixelify Sans](https://fonts.google.com/specimen/Pixelify+Sans) (OFL,
licença em `assets/font/pixelify-sans/OFL.txt`), self-hosted como WOFF2 —
usada só dentro da doca e das janelas, não no resto do site. Emitida via
`layouts/partials/custom/head-end.html` (não dá pra usar `url()` relativo
direto no `desktop-dock.css`, que é um CSS puro, sem processamento de Hugo).
