---
title: "Passo a Passo para Dev Teste (Baseado na Pirâmide de Testes)"
date: 2025-06-05
slug: piramide-de-testes-para-dev
tags: [testes, qualidade, piramide-de-testes]
draft: false
---

### 1. O que é Dev Teste?

Antes de enviar um card para o status QA, o time de desenvolvimento deve validar o código aplicando testes sistemáticos em diferentes camadas (unitário, integração, funcional). Isso reduz retrabalho e melhora a qualidade do software.

### 2. Estruturando os Testes

A pirâmide de testes sugere:

- Leitura das US/Histórias de Usuário - Leitura dos testes que compõem a US e os critérios de aceite.
- **Testes Unitários (Base da pirâmide):** Validam partes isoladas do código (ex.: funções, métodos).
- **Testes de Integração (Meio da pirâmide):** Garantem que diferentes partes do sistema interagem corretamente.
- **Testes Funcionais/E2E (Topo da pirâmide):** Validam o fluxo completo de usuário.

### 3. Como aplicar no cenário do bug?

### Passo 1: Teste Unitário

✅ Criar testes para a query que busca o domínio correto no banco.

- Verificar se a query está retornando apenas domínios do tipo *blog*.
- Garantir que não seja selecionado o primeiro domínio indiscriminadamente.

Exemplo de teste unitário (PHPUnit):

```php
public function testBuscaDominioCorreto() {
    $dominio = new DominioRepository();
    $resultado = $dominio->buscarPorTipo('blog');
    $this->assertNotEmpty($resultado);
    $this->assertEquals('blog', $resultado->tipo);
}
```

---

### Passo 2: Teste de Integração

✅ Validar se o job `SaveSessionsUrlAnalyticsJob.php` está salvando corretamente os dados na tabela `analytics_session_urls`.

- Simular uma execução do job com diferentes cenários de domínio.
- Checar se os dados são gravados corretamente.

### Passo 3: Teste Funcional (Opcional, caso necessário)

✅ Executar a funcionalidade completa e validar se os relatórios de RPS exibem os dados esperados.

### 4. Como seguir no Time?

1. Antes de abrir um bug, garantir que o código passou pelos testes unitários e de integração.
2. Adotar um fluxo de Dev Teste: **Desenvolvedor faz – Code Review – Dev Teste – QA**.
3. Registrar evidências dos testes, ter PR, evitando repassar códigos sem verificação prévia.

**Como adicionar Evidências:**

**Teste executando em ambiente dev**: os testes validados localmente, mesmo utilizando docker, não é válido, pois vários fatores de ambiente e rede não são validados nas conformidades. Gerando um falso positivo. Testes locais se enquadram por exemplo em outros tipos de testes, exemplo citado aqui os unitários.

- Ambiente de dev;
- Capturas de telas caso for testes do tipo End-to-end;
- Ter PRs no card;
- Validar os cenários dos testes no card, caso não tenha, avise o QA responsável;
