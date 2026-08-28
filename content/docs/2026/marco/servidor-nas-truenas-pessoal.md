---
title: "Servidor NAS: Construindo um Servidor Pessoal com TrueNAS"
date: 2026-03-16
slug: servidor-nas-truenas-pessoal
tags: [nas, truenas, self-hosted, redes]
draft: true
---

Guia pessoal de configuração para o TrueNAS - servidor pessoal para arquivos e mídia, com Plex.

Documentação técnica: servidor pessoal, aplicando um projeto — implantação e correção do servidor TrueNAS + Plex.

---

**Motivação**: estudar mais sobre o funcionamento de servidores menores locais, pessoais, aplicando mais estudos sobre redes.

## Arquitetura Final do Ambiente

```
Internet
│
Modem/Router (seu modem)
IP:
│
TrueNAS Server
IP:
│
Plex Container
IP interno: padrão plex
Porta: 32400
```

## Estrutura de Armazenamento
