---
title: "Building a portfolio website and organizing the work I have done"
date: 2026-11-06
slug: criando-um-site-portfolio-e-como-estou-organizando-os-trabalhos-realizados
tags: [portfolio, engenharia-de-software, testes, documentacao]
draft: false
---

## Building a portfolio website and organizing the work I have done

Recently I started organizing my portfolio in a way that would help me present my work more clearly. I wanted more than a list of technologies or repository links. I also wanted to explain what I did, how I organized the stages, and what evidence is available to check each contribution.

The project is on GitHub: <https://github.com/kellen-xavier/ladydebug-workstation>. The published version is available at <https://kellen-xavier.github.io/ladydebug-workstation/>.

## What I wanted to organize

Throughout my career, I have worked in support, frontend development, mobile and backend applications, testing, and documentation. Some of that work took place in private repositories, so it is not always possible to show the code or reproduce a run through a public link alone.

That is why I am organizing the accounts to distinguish what was implemented, what appears in the available records, and the limits of each piece of evidence. An implementation described in a report does not, by itself, mean that every scenario was executed or that a pipeline was published. I want readers to be able to see that distinction.

## A website with several pages

The site is a static application built with React and TypeScript. Instead of creating one long page with every subject mixed together, I divided the navigation into pages for my career, contributions, workflow, setup, tools, and games. The homepage works as a map to reach those sections. This map is still in development, as I would like a layout inspired by Stardew Valley.

For the visual design, I used a retro workstation reference, with cream, beige, brown, and pink tones and a pixel art illustration. I wanted the identity to connect with my Ladydebug blog while keeping the focus on reading and the work presented.

In the **In practice** section, each contribution can be opened to read its account and references. Public projects also link to their repositories. This keeps the content in one place while giving each subject its own context.

## Content separated from components

An important decision was to move long texts out of the components. The introduction, about section, career history, and project accounts live in Markdown files inside `src/content/`. Components handle the page structure, and content can be edited without changing the layout. Keeping those responsibilities separate made more sense than hardcoding text into components.

For the accounts, I use Markdown with headings, paragraphs, lists, links, and references. The `react-markdown` library turns that content into page elements. Local images can also be referenced in Markdown; the build process packages the files and generates paths that work on [GitHub Pages — see the repository here](https://github.com/remarkjs/react-markdown).

Information with a predictable structure stays in TypeScript. Workflow stages and project data, for example, need an order, identifiers, descriptions, and links. Keeping that data typed helps reveal inconsistencies during development.

This division also makes maintenance easier: editorial content stays in Markdown, data feeding cards and stages stays typed, and components are responsible for presentation.

## The workflow is part of the portfolio too

I included a page to record how I usually work. The flow involves understanding the context, building and testing, reviewing evidence, and following up on what needs to improve. The idea is to show some of the decisions and practices behind the deliveries, as well as the final result. I reached this approach through analysis, gathering information, applying tests, and validating the results.

I also organized examples of tools and setup, along with a list of game studies. These sections reflect the subjects I follow and help show how I organize my environment and keep learning. They also include my experience with the Arch Linux-based system [Omarchy](https://omarchy.org/).

## Testing and publishing

The project has unit tests and browser tests with [Playwright](https://playwright.dev/). In the browser tests, I am prioritizing behaviors someone can perform: navigating between pages, opening an account, following an anchor, downloading a file, copying a command, and filtering the games list. I also check layout behavior at different widths, such as horizontal scrolling and touch target sizes.

I organized the E2E tests into separate files by flow, including navigation, home, career, accounts, workflow, tools, and responsiveness. That makes it easier to locate a scenario and understand which part of the site it covers. The tests validate features and interface states without comparing the wording of editorial texts.

The site is generated as [static files and published through GitHub Pages](https://github.com/kellen-xavier/ladydebug-workstation/blob/main/.github/workflows/pages.yml). The pipeline runs lint, type checks, tests, and browser tests against the production build before publishing the main branch version.

## What I am still learning

Building this portfolio is also helping me think about presenting technical experience clearly. I need to choose which details help explain a contribution, which links are useful, and where to state limitations instead of making claims that go beyond the available records.

I still want to review the accounts and keep improving navigation and readability on smaller screens. The structure already lets me update each part more independently: I can adjust Markdown text, reorganize a project in the typed data, or improve a component without rewriting the whole site.

The goal is to keep this space as a living record of my work and studies, with ways to check what is public and enough context to understand the rest.
