---
title: "Poor practices to avoid in test automation"
date: 2025-06-05
slug: praticas-ruins-de-testes-para-evitar-ou
tags: [testes, automacao, qualidade]
draft: false
---

Read this, print it, maybe print it and stick it on a few people's computers…

---

![Tired cat](cat-cansado.png)

## 1. Inadequate definition and planning

**No clear goals:** failing to clearly define the goal of automation, the risks, scope, and stakeholders. Automation without well-defined goals can waste effort and deliver disappointing results.

**A poorly defined automation strategy:** lacking a test automation strategy that is applicable, customizable, and kept up to date. A poorly defined strategy can produce inefficient tests that are difficult to maintain.

**Ignoring investment criteria:** overlooking factors such as initial cost, SDLC stage, project duration, and maintenance costs when deciding what to automate. Failing to analyze these can lead to inappropriate investment and a low return.

**Not prioritizing tests:** failing to prioritize the test conditions with the greatest business impact. Automation effort should focus on the tests that deliver the most value.

---

## 2. Technical problems

**Poor SUT testability:** automating a System Under Test that is not easily testable, making its interfaces difficult to access. Testability is essential for effective automation.

**Poor automation architecture and framework:** lacking a clear Test Automation Architecture, TAA, and a Test Automation Framework, TAF, that is easy to use and maintain. Poor architecture and frameworks make automated tests harder to implement and maintain.

**Inadequate test reports:** failing to generate well-defined reports, making troubleshooting and tracking results difficult. Without clear reports, effective decisions become harder.

**No deployment and execution plan:** lacking a clear plan for deploying and executing tests, removing tests when necessary, and handling exceptions effectively. Without these plans, tests may not run correctly or may cause execution problems.

**Undocumented test cases:** failing to document automated test cases adequately, making them difficult to understand and maintain. Clear documentation is crucial for maintenance and traceability.

---

## 3. Inappropriate automation choices and applications

**Automating unsuitable tests:** selecting cases without considering technical feasibility, coding effort, execution frequency, repeatability, and maintainability. Not every test is suitable for automation.

**Automating difficult tests:** trying to automate difficult conditions such as design validation, complex human interactions, and operating system restrictions. Some tests are more effective when performed manually.

**Focusing only on user interface tests:** building a strategy that relies primarily on UI tests, which are expensive and difficult to maintain. A balanced strategy should include component, contract, and API tests.

**Not optimizing test distribution:** failing to balance tests across component, service, and UI levels, which can make tests slow and expensive. A pyramid-shaped distribution can improve efficiency.

---

## 4. Ineffective transition and maintenance

**Not monitoring costs:** failing to track costs and test suite growth during the transition to continuous testing. Monitoring both is necessary for an efficient transition.

**Functional overlap:** writing test scripts with overlapping functionality, such as repeating the same login steps in different test cases. This makes maintenance harder and increases the required effort.

**Inadequate data sharing:** failing to manage shared test data correctly, introducing duplication or errors. Data should be stored and accessed from a single source.

**Undocumented preconditions:** failing to document and automate the preconditions required to run tests, leading to failures and inconsistencies. Defining and automating preconditions is essential for repeatability.

**Not testing automated tests:** forgetting that automation is software and needs testing too. Test scripts should be tested to ensure they work correctly.

**Not refactoring automation:** failing to assess and refactor the automation solution, allowing technical debt and maintenance difficulties to accumulate. Seek continuous improvements and optimization.

**Not adapting the TAS to changes:** failing to adapt the Test Automation Solution to new SUT versions. The TAS should be flexible enough to follow system changes.

---

## 5. Other poor practices

**Excessive abstraction:** using so much abstraction that automation code becomes hard to understand. Use abstraction in moderation to keep code understandable.

**Complex data tables:** creating very large, complex test data tables that make migration to other environments difficult. Manage test data efficiently.

**Library dependencies:** creating TAS dependencies on libraries or operating system components that may not be available everywhere. The TAS should be independent and portable across test environments.

**Ignoring maintenance:** failing to plan TAS maintenance as the SUT is updated. Continuous maintenance is essential to its effectiveness.

**Not using metrics:** failing to track pass/fail rates, failure and defect proportions, automation execution time, and functional and code coverage. These metrics help assess and optimize the TAS.

**Not using test results to improve the process:** failing to analyze report data to identify trends and improve the SDLC. Use test data for decisions and continuous improvement.

By Kellen Xavier | [Contact](https://keepo.io/ladydebug/)
