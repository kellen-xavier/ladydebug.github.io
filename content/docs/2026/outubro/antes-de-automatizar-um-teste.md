---
title: "Antes de automatizar um teste, entenda qual comportamento precisa ser protegido"
date: 2026-10-29
description: "Como transformar uma regra de negócio em cenários de teste, validar limites e escolher onde automatizar, com um exemplo em JavaScript."
slug: antes-de-automatizar-um-teste
tags: [testes, qualidade, automacao, javascript]
draft: true
---

Quando falamos de automação de testes, é fácil começar pela ferramenta. Qual framework usar? Como configurar a execução no pipeline? Como organizar as pastas?

Essas decisões fazem parte do trabalho, mas existe uma pergunta anterior: **qual comportamento esse teste precisa proteger?**

Quero organizar aqui um exemplo pequeno, desde a regra até a execução. A ideia é ter um teste que ajude a entender uma falha e que continue útil quando o código mudar.

## Primeiro, esclarecer a regra

Imagine uma loja fictícia com a seguinte condição: pedidos a partir de R$ 200 em produtos recebem frete grátis.

Parece suficiente para começar. Mas o valor é calculado antes ou depois dos descontos? O frete entra nessa conta? O que acontece exatamente em R$ 200?

Para este exemplo, vamos definir o contrato:

- O valor considerado é o subtotal dos produtos depois dos descontos, sem incluir o frete.
- Um subtotal igual ou superior a R$ 200 recebe frete grátis.
- A função recebe esse subtotal em centavos, como um número inteiro não negativo.

O uso de centavos mantém os valores deste exemplo como inteiros. Validação de entrada e cálculo dos descontos ficam fora desta função; precisam de contratos e testes próprios no sistema que a utilizar.

Essa conversa sobre a regra já faz parte do trabalho de qualidade. É o mesmo ponto que aparece nas [notas sobre shift-left testing]({{< relref "/docs/2025/junho/processo-shift-left-testing-basico.md" >}}): discutir critérios de aceitação antes da implementação ajuda a explicitar o que será validado.

## Transformar o limite em cenários

Com a regra definida, podemos escolher exemplos que diferenciem o comportamento correto de um erro provável.

| Subtotal dos produtos | Resultado esperado | O que o cenário verifica |
| --- | --- | --- |
| R$ 0,00 | Sem frete grátis | Um valor válido no início do intervalo |
| R$ 199,99 | Sem frete grátis | Um centavo abaixo do limite |
| R$ 200,00 | Com frete grátis | O limite está incluído na regra |
| R$ 200,01 | Com frete grátis | Um centavo acima do limite |

O cenário de R$ 200 é especialmente útil: uma implementação com `>` no lugar de `>=` passaria pelos exemplos abaixo e acima do limite, mas falharia exatamente nele.

Aqui, o resultado esperado vem da regra acordada. Se o teste calcular a expectativa repetindo a mesma comparação da implementação, podemos copiar o mesmo erro para os dois lugares.

## Escrever e executar os testes

Para reproduzir o exemplo, use um diretório separado com uma versão mantida do Node.js que ofereça `node:test`. O [executor de testes do Node.js](https://nodejs.org/api/test.html) permite executar os testes abaixo com `node --test`, sem instalar um framework adicional.

Crie o arquivo `frete.test.mjs`:

```javascript
import test from 'node:test';
import assert from 'node:assert/strict';
import { temFreteGratis } from './frete.mjs';

const cenarios = [
  { nome: 'subtotal zero', subtotal: 0, esperado: false },
  { nome: 'um centavo abaixo do limite', subtotal: 19999, esperado: false },
  { nome: 'exatamente no limite', subtotal: 20000, esperado: true },
  { nome: 'um centavo acima do limite', subtotal: 20001, esperado: true },
];

for (const { nome, subtotal, esperado } of cenarios) {
  test(`frete grátis: ${nome}`, () => {
    assert.equal(temFreteGratis(subtotal), esperado);
  });
}
```

Antes de implementar a regra, crie `frete.mjs` com uma resposta provisória:

```javascript
export function temFreteGratis(subtotalEmCentavos) {
  return false;
}
```

Execute:

```bash
node --test frete.test.mjs
```

Os dois cenários que deveriam conceder frete grátis precisam falhar. Confira os nomes e as diferenças entre resultado esperado e recebido: uma falha de importação, por exemplo, ainda não demonstra que o teste está exercitando a regra.

Depois, substitua a resposta provisória em `frete.mjs` pela implementação:

```javascript
export function temFreteGratis(subtotalEmCentavos) {
  return subtotalEmCentavos >= 20000;
}
```

Execute o mesmo comando novamente. Os quatro cenários devem passar. Como exercício, troque `>=` por `>` e confira se o teste do limite falha; depois restaure a comparação correta.

## Escolher onde cada verificação faz sentido

Esse teste verifica uma decisão isolada. Ele não demonstra que a tela envia o subtotal correto, que o desconto foi aplicado ou que o pedido foi salvo.

Para esse exemplo, eu distribuiria as verificações assim:

- Na unidade, os limites da regra de frete grátis.
- Na integração, o subtotal depois dos descontos chegando ao cálculo do frete.
- No fluxo pela interface, um pedido representativo exibindo o frete e o total esperados.

A quantidade de cenários em cada camada depende do risco e da arquitetura. Repetir todas as combinações pela interface pode aumentar o tempo de execução e a manutenção sem acrescentar a mesma proporção de informação.

Nos testes de interface, faz sentido observar o que a pessoa consegue fazer e perceber. Os [princípios da Testing Library](https://testing-library.com/docs/guiding-principles/) seguem essa direção ao favorecer verificações próximas do uso da aplicação, evitando dependência de detalhes internos dos componentes.

## Manter o teste útil quando o código mudar

Uma refatoração pode reorganizar a implementação sem alterar o contrato. Nesse caso, os cenários de frete grátis continuam descrevendo a mesma expectativa.

Já uma mudança do limite para R$ 250 exige revisar os critérios, os exemplos e a implementação. Atualizar o teste só para a execução voltar a ficar verde esconderia a decisão que precisa ser discutida.

Antes de incluir uma automação na rotina do projeto, vale conferir se o nome descreve o comportamento, se a expectativa tem uma origem clara e se a falha ajuda a localizar o problema. Nesse exemplo, um centavo de diferença é suficiente para revelar uma regra implementada incorretamente.
