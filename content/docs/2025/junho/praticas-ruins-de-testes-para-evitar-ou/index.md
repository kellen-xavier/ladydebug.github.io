---
title: "As práticas ruins que devem ser evitadas em uma automação de testes"
date: 2025-06-05
slug: praticas-ruins-de-testes-para-evitar-ou
tags: [testes, automacao, qualidade]
draft: false
---

Leia isso, imprimir, talvez imprima e cole no computador de uns aí…

---

![Gato cansado](cat-cansado.png)

## 1. Definição e Planejamento Inadequados

**Falta de Objetivos Claros:** não definir claramente o objetivo da automação, os riscos envolvidos, o escopo e as partes interessadas. A automação sem objetivos bem definidos pode levar a esforços desperdiçados e resultados insatisfatórios.

**Estratégia de Automação Mal Definida**: não ter uma estratégia de automação de teste que seja aplicável, personalizável e mantida atualizada. Uma estratégia mal definida pode resultar em testes ineficientes e difíceis de manter.

**Não Considerar Critérios de Investimento:** ignorar fatores como custo inicial, fase do SDLC, duração do projeto e custo de manutenção ao decidir sobre a automação. A falta de análise desses fatores pode levar a investimentos inadequados e pouco retorno.

**Não priorizar testes:** não priorizar as condições de teste mais impactantes do ponto de vista do negócio. É preciso focar nos esforços de automação nos testes que trarão mais valor.

---

## 2. Aspectos Técnicos Problemáticos

**Má Testabilidade do SUT:** automatizar um Sistema em Teste (SUT) que não é facilmente testável, dificultando o acesso às suas interfaces. A testabilidade é essencial para uma automação eficaz.

**Arquitetura e Framework de Automação Ruins:** não ter uma Arquitetura de Automação de Teste (TAA) clara e um Framework de Automação de Teste (TAF) fácil de usar e manter. Uma má arquitetura e framework podem levar a dificuldades na implementação e manutenção dos testes automatizados.

**Relatórios de Teste Deficientes:** não gerar relatórios de teste bem definidos, dificultando a solução de problemas e o acompanhamento dos resultados. A falta de relatórios claros impede a tomada de decisões eficazes.

**Não ter um plano de implantação e execução:** não ter um plano claro de implantação e execução de testes, remoção de testes quando necessário e tratamento eficaz de exceções. Sem esses planos, os testes podem não ser executados corretamente, ou causar problemas na execução.

**Não Documentar os Casos de Teste:** não documentar adequadamente os casos de teste automatizados, tornando-os difíceis de entender e manter. A documentação clara é crucial para a manutenção e rastreabilidade dos testes.

---

## 3. Escolha e Aplicação Inadequadas da Automação

**Automatizar Testes Impróprios:** escolher casos de teste para automação sem considerar a viabilidade técnica, esforço de codificação, frequência de execução, repetibilidade e facilidade de manutenção. Nem todos os testes são adequados para automação.

**Automatizar Testes Difíceis:** tentar automatizar condições de teste difíceis, como validações de design, interações humanas complexas e restrições técnicas no nível do sistema operacional. Alguns testes são mais eficazes quando realizados manualmente.

**Focar apenas em testes de interface do usuário:** criar uma estratégia que dependa principalmente de testes de interface do usuário (UI), que são caros e de difícil manutenção. Uma estratégia de testes equilibrada deve incluir testes de componentes, contrato e API.

**Não otimizar a distribuição de testes:** não equilibrar a quantidade de testes nos diferentes níveis (componente, serviço e UI), o que pode resultar em testes lentos e caros. É preciso buscar uma distribuição em forma de pirâmide para melhor eficiência.

---

## 4. Transição e Manutenção Ineficazes

**Não Monitorar os Custos:** não acompanhar os custos e o crescimento da suíte de testes durante a transição para testes contínuos. O monitoramento dos custos e do crescimento da suíte de testes é necessário para uma transição eficiente.

**Sobreposição Funcional:** criar scripts de teste com sobreposição funcional, como incluir as mesmas etapas de login em diferentes casos de teste. Isso dificulta a manutenção e aumenta o esforço necessário.

**Compartilhamento de Dados Inadequados:** não gerenciar corretamente o compartilhamento de dados entre os testes, levando à duplicação ou introdução de erros. Os dados devem ser armazenados e acessados de uma única fonte.

**Não Documentar Pré-Condições:** não documentar e automatizar as pré-condições necessárias para a execução dos testes, levando a falhas e inconsistências. É essencial definir e automatizar as pré-condições para garantir a repetibilidade dos testes.

**Não Testar os Testes Automatizados:** esquecer de que a automação é um software que também precisa ser testado. Os scripts de teste devem ser testados para garantir que funcionem corretamente.

**Não Refatorar a Automação:** não avaliar e refatorar a solução de automação, levando ao acúmulo de dívida técnica e dificuldades na manutenção. É preciso buscar melhorias contínuas e otimizações.

**Não Adaptar a TAS às Mudanças**: não adaptar a Solução de Automação de Teste (TAS) às novas versões do SUT. A TAS deve ser flexível e adaptável para acompanhar as mudanças no sistema.

---

## 5. Outras Práticas Ruins

**Abstração Excessiva:** utilizar abstrações excessivas que tornam o código de automação difícil de entender. A abstração deve ser usada com moderação para manter o código compreensível.

**Tabelas de Dados Complexas:** criar tabelas de dados de teste muito grandes e complexas, dificultando a migração para outros ambientes. Os dados de teste devem ser gerenciados de forma eficiente.

**Dependências de Bibliotecas:** criar dependências da TAS em bibliotecas ou componentes do sistema operacional que podem não estar disponíveis em todos os ambientes. A TAS deve ser independente e portável entre diferentes ambientes de teste.

**Ignorar a Importância da Manutenção**: deixar de planejar a manutenção da TAS devido a atualizações no SUT. A manutenção contínua da TAS é essencial para garantir sua eficácia.

**Não usar métricas:** não acompanhar métricas como taxa de aprovação/reprovação, proporção de falhas e defeitos, tempo de execução da automação, cobertura funcional e de código. Essas métricas ajudam a avaliar e otimizar a TAS.

**Não aproveitar os resultados dos testes para melhorar o processo:** não analisar os dados gerados nos relatórios de teste para identificar tendências e fazer melhorias no SDLC. Os dados dos testes devem ser usados para tomada de decisões e melhoria contínua.

Feito por: Kellen Xavier | [Contato](https://keepo.io/ladydebug/)
