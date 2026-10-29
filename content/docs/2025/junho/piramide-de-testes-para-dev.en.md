---
title: "A development testing workflow based on the test pyramid"
date: 2025-06-05
slug: piramide-de-testes-para-dev
tags: [testes, qualidade, piramide-de-testes]
draft: false
---

### 1. What is development testing?

Before moving a card to QA, the development team should validate its code with systematic tests at different levels: unit, integration, and functional. This reduces rework and improves software quality.

### 2. Structuring the tests

The test pyramid suggests:

- Read the user stories, their tests, and their acceptance criteria.
- **Unit tests, at the base:** validate isolated pieces of code, such as functions and methods.
- **Integration tests, in the middle:** ensure different parts of the system interact correctly.
- **Functional/E2E tests, at the top:** validate the complete user flow.

### 3. How can this be applied to a bug?

### Step 1 — Unit test

✅ Write tests for the query that retrieves the correct domain from the database.

- Check that the query returns only domains of the *blog* type.
- Ensure the first domain is not selected indiscriminately.

Unit test example with PHPUnit:

```php
public function testBuscaDominioCorreto() {
    $dominio = new DominioRepository();
    $resultado = $dominio->buscarPorTipo('blog');
    $this->assertNotEmpty($resultado);
    $this->assertEquals('blog', $resultado->tipo);
}
```

---

### Step 2 — Integration test

✅ Validate that `SaveSessionsUrlAnalyticsJob.php` correctly saves data to the `analytics_session_urls` table.

- Simulate running the job with different domain scenarios.
- Check that the data is recorded correctly.

### Step 3 — Functional test, if needed

✅ Run the complete functionality and validate that RPS reports display the expected data.

### 4. How can the team adopt this?

1. Before opening a bug, ensure the code passed unit and integration tests.
2. Adopt a development testing workflow: **Developer implements – Code review – Development testing – QA**.
3. Record test evidence and include a PR, avoiding handing off code without prior verification.

**How to add evidence:**

**Tests running in the development environment:** local validation, even with Docker, is not sufficient here because various environment and network factors have not been checked against the requirements. This can produce a false positive. Local tests belong to other testing categories, such as the unit tests mentioned above.

- Use the development environment.
- Include screenshots for end-to-end tests.
- Attach PRs to the card.
- Validate the test scenarios on the card. If they are missing, notify the responsible QA person.
