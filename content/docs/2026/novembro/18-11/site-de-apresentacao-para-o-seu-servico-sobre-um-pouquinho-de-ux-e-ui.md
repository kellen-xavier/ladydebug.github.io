---
title: Site de apresentação para o seu serviço - Sobre um pouquinho de UX e UI
date: '2026-11-18'
slug: site-de-apresentacao-para-o-seu-servico-sobre-um-pouquinho-de-ux-e-ui
tags: []
draft: true
---

A ideia deste projeto foi criar um site para apresentar os serviços da Elementar Projetos, explicar o atendimento e facilitar o pedido de orçamento. O foco são serviços de PPCI e regularização de imóveis.

O site começou como uma landing page e foi ganhando outras partes: edição de conteúdo pelo painel, blog, páginas de serviços e melhorias no formulário. Neste post, quero deixar o registro de como essa construção aconteceu tecnicamente e, depois, dos ajustes de interface e usabilidade.

Este é um registro do código, do histórico e da documentação analisados em 18 de novembro de 2026. As funcionalidades descritas aqui não significam, por si só, que houve melhora medida em conversões ou que todas as alterações já estejam publicadas em produção.

## Como o site foi construído

O ponto de partida foi um protótipo em HTML. A estrutura foi dividida em componentes React: cabeçalho, apresentação inicial, serviços, pacotes, perguntas frequentes, formulário e rodapé. Essa separação facilita a manutenção, porque uma mudança em uma seção não precisa ficar misturada com toda a página.

A base utiliza **React e TypeScript**, com **Vite** para o ambiente de desenvolvimento e a geração dos arquivos de produção. O **Bun** é usado para instalar as dependências, executar os scripts e rodar os testes.

O conteúdo também foi separado da interface. Textos, serviços, preços e configurações ficam em arquivos versionados no Git. Assim, o layout pode ser mantido enquanto o conteúdo é atualizado.

### Edição de conteúdo pelo painel

Para permitir a edição sem precisar mexer no código, foi integrado o **Decap CMS**, O painel permite editar os conteúdos configurados, como textos, serviços, pacotes, perguntas frequentes, imagens e artigos do blog.

As alterações passam pelo fluxo editorial do painel e são salvas no Git. A configuração distingue o ambiente de testes do ambiente de produção. Também foi preparado um admin local, que trabalha em uma cópia isolada do conteúdo, sem publicar alterações no repositório remoto.

Isso trouxe um cuidado importante: o conteúdo exibido no site e a prévia do painel precisam continuar usando as mesmas regras e os mesmos estilos.

### O caminho do pedido de orçamento

O formulário mudou ao longo do desenvolvimento. Na primeira versão, os dados eram usados para preparar uma mensagem no WhatsApp. O WhatsApp permanece como outro canal de contato, por meio de links próprios.

O fluxo atual funciona mais ou menos assim:

1. A pessoa preenche os dados e pode adicionar arquivos.
2. O formulário valida os campos e os anexos antes do envio.
3. Quando um CEP é informado, o site consulta o ViaCEP e valida a resposta antes de preencher o endereço.
4. O pedido é enviado.
5. Somente depois de uma resposta de sucesso aparece a confirmação na tela.

Se houver erro no envio, a interface informa a falha e preserva os dados preenchidos. Também foram adicionadas proteções contra envios simultâneos e respostas antigas de consultas de CEP.

O destinatário das notificações é configurado separado, fora do código. Há ainda uma integração opcional de backend com o Apollo, separada da confirmação apresentada para quem preenche o formulário.

### Blog, páginas de serviços e publicação

O projeto passou a ter uma listagem de artigos, páginas individuais do blog e páginas específicas para os serviços.

Durante o build, essas páginas são geradas em HTML antes de chegar ao navegador. O React assume as interações depois do carregamento inicial.
Dessa forma, o conteúdo principal já está presente no HTML, o que também ajuda os mecanismos de busca a interpretar as páginas.

A hospedagem utiliza a **Netlify**. As verificações automatizadas ficam no **GitHub Actions**, com testes, análise do código e geração do site.
A versão e o changelog são mantidos pela automação Release Please.

## Testes e organização do código

A evolução foi acompanhada de testes das regras do formulário, dos componentes, do conteúdo e das integrações. Os testes com Testing Library verificam interações, enquanto os testes com Playwright conferem comportamentos e layout no navegador.

Nas correções documentadas, o processo utiliza TDD: primeiro reproduzir o problema com um teste em falha, depois implementar a correção e executar novamente a verificação. 
Também (obviamente) existem checagens de tipos com TypeScript e de qualidade do código com ESLint.

Os estilos foram reorganizados em arquivos por responsabilidade, como cabeçalho, serviços, formulário e páginas do blog.
O CSS continua sendo reunido no build; separar os arquivos fonte não significa carregar uma folha de estilos para cada componente em produção.

Também houve ajustes de desempenho: as fontes passaram a ser servidas localmente, a foto do responsável recebeu carregamento adiado e o processamento de textos simples foi reduzido.

## O que mudou na UI e na UX

Aqui estou separando duas coisas que se complementam: **UI**, a apresentação da interface, e **UX**, a experiência de usar essa interface para entender um serviço ou pedir um orçamento.
As alterações foram feitas sobre a identidade que criei para este projeto - KIT WEB UI - os elementos visuais ligados à área técnica do serviço.

### Hierarquia visual e leitura

Foram ajustados títulos, espaçamentos, altura das seções e organização dos textos. A intenção foi facilitar a leitura e deixar mais evidente o que cada parte da página apresenta.
Os cartões de serviços passaram a mostrar descrições, além de um painel com os detalhes do serviço selecionado. As páginas internas complementam essa apresentação com mais informações sobre cada serviço.

### Responsividade, contraste e avisos

Os ajustes para celular e tablet envolveram tamanhos dos textos, distribuição dos campos, espaçamentos e posicionamento dos botões.
O objetivo foi manter a leitura e as ações disponíveis mesmo em telas menores.
Também foram revisados contraste, foco visível e tamanho das áreas de interação.
Esses cuidados fazem parte do trabalho de acessibilidade, mas não equivalem a uma certificação completa do site.

O aviso de cookies recebeu ajustes de posição e tamanho para reduzir a interferência sobre o conteúdo e os botões. A pessoa pode aceitar, rejeitar ou configurar suas preferências. As ferramentas de medição dependem das autorizações correspondentes, e o formulário continua funcionando mesmo quando os cookies opcionais são rejeitados.

### Navegação no celular e no desktop

O menu ganhou indicação da seção atual, acesso ao formulário e subcategorias de serviços. Também houve ajustes na abertura do menu móvel, na rolagem e nas áreas de toque.

A navegação por teclado foi considerada: o menu recebe foco ao abrir, pode ser fechado com Esc e devolve o foco ao botão.
As âncoras respeitam o espaço do cabeçalho fixo, evitando que o início de uma seção fique escondido.
O botão de voltar ao topo também recebeu ajustes para funcionar nas diferentes páginas e não cobrir os últimos textos do rodapé.

### Um formulário mais claro

Nome e WhatsApp ficaram como os dados mínimos para o envio. As informações complementares foram agrupadas como opcionais, com orientações para explicar sua utilidade na análise do pedido.

Foi acrescentado um indicador de progresso. Ele informa o andamento do preenchimento e diferencia o mínimo necessário para enviar dos detalhes que ajudam na análise. Uma das correções mais recentes fez a barra começar vazia e avançar conforme os dados são preenchidos, em vez de parecer completa logo ao abrir a página.
As mensagens de erro ficam associadas aos campos. Após um envio confirmado, uma janela permite continuar navegando ou limpar o formulário para iniciar outro pedido, sem mudar de página.

Fiz essa pesquisa fazendo a leitura do [Não me Faça Pensar](https://a.co/d/00nQy7Bl)
E o livro do Rian Dultra [Enviesados](https://a.co/d/0gALu2dX) pois precisei pesquisar sobre qual o tipo de público que procura esse tipo de site.

## O que este registro permite acompanhar

O histórico mostra a passagem de uma página de apresentação para um site com conteúdo editável, publicação de artigos e um fluxo de orçamento mais estruturado.
As mudanças de UI e UX acompanharam essa evolução, principalmente na navegação, na apresentação dos serviços e no formulário.

O código e os testes ajudam sempre a registrar o comportamento esperado. Para avaliar o resultado com as pessoas que usam o site, ainda é necessário observar o uso e reunir dados. 
Não dá para concluir que uma mudança visual aumentou os pedidos de orçamento apenas porque foi implementada (então isso ainda está sendo medido)
