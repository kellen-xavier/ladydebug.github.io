---
title: "Fórum | Adoção de Princípios de Design e Arquitetura"
date: 2025-06-10
slug: adocao-de-principios-de-design-e-arquitetura
tags: [arquitetura, design, qualidade]
draft: true
---

Trabalho - Pós-graduação | Projeto e Arquitetura de Software

### Neste módulo, foram apresentados alguns princípios de design e umas implicações na manutenção e evolução de software. Quais desses princípios discutidos vocês já usam? Identifique os benefícios e dificuldades dessas adoções

---

Com base no que foi visto em aula, algumas das coisas que costumo aplicar no dia a dia do meu trabalho, que é na área da qualidade. Várias coisas, quando não existem no projeto, acabo iniciando a conversa no time. Então varia bastante, conforme a cultura do time. Quando chego no projeto, faço uma análise geral do desenvolvimento do time no projeto. Então o passo inicial é aplicar conforme a necessidade, compartilhando a cultura de testes nos times.

Algumas práticas seriam aplicar o uso de *linters* nos projetos, adicionar essas regras na CI, aplicar CI/CD também quando o projeto não tem. Os **lints automáticos** bloqueiam *pushes* com esses problemas de formatação ou más práticas, e o time acaba evitando diversos erros antes mesmo de mesclar a *branch* ou **executar o código**.

Dentro do time, sempre busco analisar automação de testes com o time e documentar o projeto com o uso das próprias ferramentas do time, por exemplo: Javadocs, PHPDocs — <https://phpstan.org/writing-php-code/phpdocs-basics>.

Compartilho ferramentas e *plugins* para IDEs, analiso processos básicos. Segue um exemplo que já compartilhei: a pirâmide de testes para dev e, aqui com o time de QA, exemplos de configuração do Testing Library.

Já apliquei testes de API, que acredito que estejam agora voltados à "**Observabilidade**", que seria **a capacidade de entender o que está acontecendo dentro de um sistema apenas com base em sua saída externa**. Geralmente, nas análises, faço um plano de testes e levantamento de cenários de testes. Compartilho com o time para que sejam aplicados os testes. Com base nisso, por exemplo, na API, utilizei a ferramenta do K6 (<https://k6.io/>) e o Grafana (<https://grafana.com/docs/k6/latest/>). Assim, era criada a automação com base nos cenários, executávamos os testes, e isso era validado dentro de uma *pipeline*, no próprio GitHub Actions.

### Exemplo com K6

```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
  vus: 10,         // Número de usuários virtuais simultâneos
  duration: '10s', // Duração do teste
};

export default function () {
  // Realizando a requisição de pagamento com cartão de crédito
  const token = login(`${__ENV.USERNAME}`, `${__ENV.PASSWORD}`);

  const data = {
    cardToken: "meio-de-buscar-token-exemplo",
    providerMeioDePagamento: "um-code-que-defina-seu-meio-de-pagamento-exemplo"
  };

  const responseToken = http.post(
    `${__ENV.SERVER}/seu/caminho/token-credit`,
    JSON.stringify(data),
    {
      headers: {
        'Autorization': `Bearer ${token}`,
        'content-type': "application/json",
        'accept': "application/json",
      },
    },
  );

  check(responseToken, {
    'Defina uma mensagem aqui para o exemplo - identificando pagamento bem-sucedido': (response) => response.status === 200
  });

  let response = http.post('https://sua_loja.com/processar_pagamento', {
    cartao_credito: numeroCartao,
    produto_id: produtoID,
    parcelas: numParcelas
  });

  // Verificando requisição bem sucedida (código de status 200)
  check(response, {
    'Defina uma mensagem aqui para o exemplo - Pagamento bem-sucedido': (response) => response.status === 200
  });

  // Aguardando período de tempo para simular a navegação do usuário
  sleep(3);
}
```

Hoje em dia, usar linters facilita bastante, pois evita essa "reação em cadeia" de más práticas dentro do projeto. Ao mudar a forma de como fazer, o linter faz o *scanner* no código e te faz pensar em como evitar acoplamento ou funções muito grandes — grandes o suficiente para que se perca o entendimento do que elas fazem, e sem validações. Mas ainda, como apresentar isso de forma gradual, os conceitos para aplicar no desenvolvimento, precisa de bastante conversa e cultura com o pessoal.

---

### Fontes de Estudos - Pesquisa

**Livros:**

- Manual do Arquiteto de Software | Discutindo conceitos, **técnicas, tecnologias, padrões e procedimentos** para a boa prática de arquitetura de software. → Link [Aqui](https://elemarjr.com/livros/arquiteturadesoftware/volume-1/)
- Engenharia de Software Moderna — <https://engsoftmoderna.info/>
