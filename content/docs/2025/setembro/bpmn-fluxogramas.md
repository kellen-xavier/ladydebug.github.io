---
title: "Cola do BPMN"
date: 2025-09-01
slug: bpmn-fluxogramas
tags: [bpmn, fluxogramas, processos]
draft: false
---

Para quem esta começando a desenhar fluxogramas, segue as opções para os eventos do BPMN.

Start inicia o fluxo, intermediate acontece no meio, boundary fica colado numa atividade para tratá-la, e end encerra o caminho. Regra de ouro: catch = espera algo; throw = dispara algo.

---

## Start events (iniciam o processo)

- **Start event (none):** começa sem condição.
- **Message start:** inicia quando chega uma mensagem (ex.: webhook).
- **Timer start:** agenda/cron (data, atraso, repetição).
- **Conditional start:** começa quando uma expressão fica verdadeira.
- **Signal start:** começa ao receber um "broadcast" (sinal geral).

## Intermediate events (no meio do fluxo)

- **Message intermediate (throw):** envia mensagem a outro participante.
- **Timer intermediate (catch):** espera um tempo/data.
- **Escalation intermediate (throw):** avisa/escalona sem tratar como erro.
- **Conditional intermediate (catch):** pausa até a condição ficar verdadeira.
- **Link (catch/throw):** "teletransporte" dentro do mesmo diagrama (conecta pontos).
- **Compensation intermediate (throw):** dispara compensação (desfazer algo).
- **Signal intermediate (catch/throw):** pub/sub (broadcast) – qualquer ouvinte capta.

## Boundary events (colados numa tarefa/subprocesso)

- Disparam quando ocorre algo **durante** a atividade.
- **Interrupting (borda contínua):** cancela a atividade e desvia o fluxo.
- **Non-interrupting (borda tracejada):** cria um fluxo alternativo sem cancelar.

- Tipos comuns: **Timer, Message, Conditional, Signal, Escalation, Compensation**.

### Especiais

  **Error boundary:** só interruptivo; captura erros do subprocesso.
  **Cancel boundary:** só em **Transaction subprocess**.

- As variações **(non-interrupting)** mantêm a atividade rodando.

## End events (encerram o caminho)

- **Message end:** envia mensagem e termina.
- **Escalation end:** notifica o nível acima e termina.
- **Error end:** lança erro; sai do subprocesso até um *error boundary* capturar.
- **Cancel end:** cancela uma **Transaction**.
- **Compensation end:** solicita compensações registradas.
- **Signal end:** emite sinal (broadcast) e termina.
- **Terminate end:** mata **todas** as atividades ativas do processo/subprocesso.
