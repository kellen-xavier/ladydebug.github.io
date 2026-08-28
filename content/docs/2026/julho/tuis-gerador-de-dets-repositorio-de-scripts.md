---
title: "TUIs Gerador de DETs | Repositório de Scripts para gerar Report de Testes"
date: 2026-07-13
slug: tuis-gerador-de-dets-repositorio-de-scripts
tags: [tui, automacao, qualidade]
draft: true
---

Criei o repositório [ladydebug-generator-dets](https://github.com/kellen-xavier/ladydebug-generator-dets) para gerar DETs (Documentos de Evidência de Testes) de forma fácil e rápida, sem depender de uma etapa manual. A ferramenta é uma TUI que automatiza a criação das pastas de Release e ID CARD, organiza as subpastas de cada caso de teste e gera o documento final em `.docx`, com opção de exportar em PDF (individual ou compilado), a partir de uma planilha de testes.

O README estava desatualizado em relação à versão atual da ferramenta — faltava a opção de "Verificar ambiente" no menu e a estrutura de pastas não refletia mais a camada de ID CARD. Aproveitei para reescrever a documentação pensando em quem não é técnico: um guia de "Primeiros passos" cobrindo desde a instalação até a geração do primeiro DET, um glossário explicando termos como token, release, ID CARD, DET e planilha, e uma seção de troubleshooting para os erros mais comuns (LibreOffice ausente, planilha no formato errado, entre outros).
