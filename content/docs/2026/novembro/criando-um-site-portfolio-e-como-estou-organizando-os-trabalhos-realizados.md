---
title: "Criando um site portfolio - E como estou organizando os trabalhos realizados"
date: 2026-11-06
slug: criando-um-site-portfolio-e-como-estou-organizando-os-trabalhos-realizados
tags: [portfolio, engenharia-de-software, testes, documentacao]
draft: false
---

## Criando um site portfolio - E como estou organizando os trabalhos realizados

Recentemente comecei a organizar meu portfólio de um jeito que me ajudasse a mostrar melhor os trabalhos que venho realizando. Não queria deixar somente uma lista de tecnologias ou links para repositórios. Também queria explicar o que foi feito, como organizei as etapas e quais evidências existem para conferir cada contribuição.

O projeto está no GitHub: <https://github.com/kellen-xavier/ladydebug-workstation>. A versão publicada pode ser acessada em <https://kellen-xavier.github.io/ladydebug-workstation/>.

## O que eu queria organizar

Ao longo da minha trajetória, trabalhei com suporte, desenvolvimento frontend, aplicações mobile e backend, testes e documentação. Parte desse trabalho aconteceu em repositórios privados, então nem sempre é possível mostrar o código ou reproduzir uma execução apenas com um link público.

Por isso, estou organizando os relatos para separar o que foi implementado, o que aparece nos registros disponíveis e quais são os limites de cada evidência. Uma implementação descrita em um relatório não significa, por si só, que todos os cenários foram executados ou que um pipeline foi publicado. Quero deixar essa diferença visível para quem estiver lendo.

## Um portfólio com várias páginas

O site é uma aplicação estática feita com React e TypeScript. Em vez de montar uma única página longa com todos os assuntos misturados, separei a navegação em páginas para trajetória, contribuições, workflow, setup, ferramentas e games. A página inicial funciona como um mapa para chegar a essas partes. (Este mapa ainda está em desenvolvimento pois eu gostaria de algo no layout de Stardew Vallew)

Na parte visual, usei uma referência de workstation retrô, com tons de creme, bege, marrom e rosa e uma ilustração em pixel art. Queria que a identidade tivesse relação com o meu blog Ladydebug sem tirar o foco da leitura e dos trabalhos apresentados.

Na seção **Na prática**, cada contribuição pode ser aberta para consultar o relato e as referências. Os projetos públicos também levam aos respectivos repositórios. Assim, o conteúdo fica em um mesmo lugar, mas cada assunto tem seu próprio contexto.

## Conteúdo separado dos componentes

Uma decisão importante foi retirar os textos longos dos componentes. Apresentação, sobre, trajetória e relatos ficam em arquivos Markdown dentro de `src/content/`. Os componentes cuidam da estrutura da página e o conteúdo pode ser editado sem alterar o layout. Foi melhor deixar tudo isso separado, não tem o menos cabimento deixar harded code os textos nos componentes.

Para os relatos, uso Markdown com títulos, parágrafos, listas, links e referências. A biblioteca `react-markdown` transforma esse conteúdo em elementos da página. Imagens locais também podem ser escritas no Markdown; o processo de build empacota os arquivos e gera caminhos que funcionam no [GitHub Pages veja o repositório aqui](https://github.com/remarkjs/react-markdown).

Já as informações que têm estrutura previsível ficam em TypeScript. Por exemplo, etapas do workflow e dados dos projetos precisam de ordem, identificadores, descrições e links. Manter esses dados tipados ajuda a perceber inconsistências durante o desenvolvimento.

Essa divisão também facilita a manutenção: conteúdo editorial fica no Markdown, dados que alimentam cartões e etapas ficam tipados e os componentes ficam responsáveis por apresentar tudo.

## O workflow também faz parte do portfólio

Incluí uma página para registrar como costumo trabalhar. O fluxo passa por entender o contexto, construir e testar, revisar as evidências e acompanhar o que precisa evoluir. A ideia é mostrar um pouco das decisões e práticas por trás das entregas, não apenas o resultado final. Exemplo como cheguei nessa lógica, foi analisando, fazendo o levantamento, aplicando testes, validando.

Também organizei exemplos de ferramentas e setup, além de uma lista de estudos sobre jogos. Esses blocos fazem parte dos assuntos que acompanho e ajudam a mostrar como organizo o ambiente e continuo aprendendo. E também minha tragetórica com o sistema baseado no Arch Linux o [Omarchy](https://omarchy.org/)

## Testes e Publicação

O projeto tem testes unitários e testes de navegador com [Playwright](https://playwright.dev/). Nos testes de navegador, estou priorizando comportamentos que alguém consegue executar: navegar entre páginas, abrir um relato, seguir uma âncora, baixar um arquivo, copiar um comando e filtrar a lista de jogos. Também verifico aspectos de layout em larguras diferentes, como rolagem horizontal e tamanho dos alvos de toque.

Organizei os testes E2E em arquivos separados por fluxo, como navegação, home, carreira, relatos, workflow, ferramentas e responsividade. Isso deixa mais fácil localizar um cenário e entender qual parte do site ele cobre. Os testes validam funcionalidades e estados da interface, sem comparar a redação dos textos editoriais.

O site é gerado como [arquivos estáticos e publicado pelo GitHub Pages](https://github.com/kellen-xavier/ladydebug-workstation/blob/main/.github/workflows/pages.yml). A pipeline executa lint, verificação de tipos, testes e testes de navegador sobre o build de produção antes de publicar a versão da branch principal.

## O que ainda estou aprendendo

Montar esse portfólio também está me ajudando a pensar sobre como apresentar experiências técnicas com clareza. Preciso escolher quais detalhes ajudam a entender uma contribuição, quais links são realmente úteis e onde é necessário indicar limites em vez de fazer uma afirmação maior do que os registros permitem.

Ainda quero revisar os relatos e continuar melhorando a navegação e a leitura em telas menores. A estrutura já me permite atualizar cada parte com mais autonomia: posso ajustar um texto no Markdown, reorganizar um projeto nos dados tipados ou evoluir um componente sem precisar reescrever o site inteiro.

O objetivo é manter esse espaço como um registro vivo do meu trabalho e dos estudos, com caminhos para conferir o que está público e contexto suficiente para entender o restante.
