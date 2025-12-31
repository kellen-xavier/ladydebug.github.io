---
title: Cypress e Boas Práticas de Automação
date: '2024-10-24T13:07:00-03:00'
slug: cypress-e-boas-praticas-de-automacao
tags:
- cypress
- automacao
- boas
- praticas
- docs
draft: false
---

Evitando o uso de *Falsos Positivos* com Cypress. Segue abaixo um exemplo de um código, e um arquivo commands com um simples login na aplicação:

![exemplo-praticas-ruins](/assets/image/2024/exemplo-praticas-ruins.png)

Essa aplicação estava ocorrendo um certo erro ao realizar o login, e foi adicionado o seguinte trecho de código na automação para poder realizar o login com sucesso:

![o que o erro faz?](./assets/image/2024/o_que_o_erro_faz.png)

Mas o que esse trecho diz? Serve para suprimir os erros que ocorrem na aplicação durante a execução dos testes do Cypress.

Como assim? Ao usar ```cy.on('uncaught:exception')``` e retornar false, está instruindo o Cypress a ignorar qualquer erro que ocorra na sua aplicação. Isso permite que o teste continue mesmo que a página ainda não esteja totalmente carregada, dando tempo para que os elementos sejam renderizados antes que o Cypress tente interagir com eles.

Por que remover ```cy.on('uncaught:exception')``` é importante? Nesse caso, como está sendo manipulado o teste, forçando a “ignorar esse erro retornando que ele seja falso” é adicionado um falso positivo no nosso teste. Segue abaixo:

![alt text](./assets/image/2024/login_com_sucesso.png)

## Alternativas e soluções para lidar com o tempo de carregamento e evitar adicionar “falso positivo”

Em vez de suprimir erros, deve-se usar as ferramentas do Cypress para garantir que os elementos estejam presentes e prontos para interação antes de tentar acessá-los. Algumas opções incluem:

```cy.wait()```: Aguarde um determinado tempo ou até que um elemento ou condição específica seja atendida antes de prosseguir com o teste.

OBS: cuide as más práticas ao usar o comando ```cy.wait(número)``` , leia a documentação sobre Anti-Pattern.

[Unnecessary Waiting aqui](https://docs.cypress.io/app/core-concepts/best-practices#Unnecessary-Waiting)

Em vez disso, use:

```bash
cy.intercept('GET', '/users', [{ name: 'Maggy' }, { name: 'Joan' }]).as('getUsers')
cy.get('[data-testid="fetch-users"]').click()
cy.wait('@getUsers') // <--- wait explicitly for this route to finish
```

```cy.get(...).should('exist')``` ou

```cy.get(...).should('be.visible')```

Precisa garantir de que o elemento existe e está visível na página antes de tentar interagir com ele.
