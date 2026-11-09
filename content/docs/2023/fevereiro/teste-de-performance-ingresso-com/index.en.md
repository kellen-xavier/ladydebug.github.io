---
title: "Performance testing: a brief analysis of ingresso.com"
date: 2023-02-04T00:35:15Z
slug: teste-de-performance-uma-breve-analise-do-site-ingresso-com
description: "A record from 2023 about performance problems during ticket presales and the importance of performance testing."
tags: [testes, performance, qualidade]
draft: false
---

> Originally published on [Medium](https://medium.com/@kellenxaviier/teste-de-performance-uma-breve-an%C3%A1lise-do-site-ingresso-com-90e89aacb9e6) on February 4, 2023. This record preserves the original article and images; the English text is a translation.

*An analysis for study and workplace application of software testing.*

## A real example for applying performance tests

Over the last decade, online shopping has grown exponentially. More and more people are choosing to shop online instead of buying in physical stores. The COVID-19 pandemic gave this model a boost, both by increasing purchases among existing online shoppers and by attracting new consumers. All of this generates much more traffic on pages and servers, raising the need for a robust, secure solution with good performance.

In addition to much higher everyday traffic than was usual, there are peaks on specific dates and at particular times of the year, such as holidays, celebrations, and major events. Unfortunately, it is not common to see a bottleneck on large sales portals, causing extreme slowness, authentication failures, and pages going down.

Today we will discuss Black Friday and Ingresso.com as examples for exploring **performance testing**. Black Friday is an event that always takes place on the last Friday in November. Online stores need to be ready for the expected demand. It is unacceptable to know so far in advance that traffic will peak and still be unprepared, creating a negative customer experience and missing opportunities for greater business revenue. This happens both because frustrated users avoid returning to the platform and because the server cannot complete the purchase transaction.

### Problems such as

- Server outages;
- Slow navigation;
- A slow purchase flow, to the point that completing a purchase becomes impossible;
- Instability;
- Bugs;

## A real example of what happens without performance testing

Around noon, a peak time, on November 29, 2021, ingresso.com, one of the largest cinema ticket sales websites, could not handle the number of simultaneous visitors buying presale tickets for the most anticipated movie of the year.

![Spider-Man: No Way Home page on ingresso.com](ingresso-com-pre-venda.png "Image taken from ingresso.com")

The instability was so severe that some people spent *more than an hour trying to complete a purchase*. Some users who managed to complete the purchase flow were charged but did not receive their tickets and had to request a refund.

![Loading indicator during the ingresso.com purchase flow](ingresso-com-falha-na-compra.png "Image taken from ingresso.com")

![Connection error displayed on ingresso.com](ingresso-com-instabilidade.png "Image taken from ingresso.com")

### Other problems also occurred

- Server outages, preventing users from accessing the site;
- An incomplete main flow, leaving users unable to make a purchase;
- Endless loading, with slowness in the purchase flow leading back to a server outage;

### And many bugs

- Account logout: users were forcibly logged out in the middle of the purchase flow, often without being told, creating purchase conflicts;
- Page redirects: the location of the cinema showing selected for the purchase changed, again without informing the user;
- Movie no longer available: the site displayed the movie as though it were no longer showing;
- Generic messages: users encountered errors, but the messages were imprecise. The same message appeared for several different errors, making the flow frustrating;

![Ingresso.com reporting no upcoming movies](ingresso-com-erros.png "ingresso.com website")

### The instability was so severe that it generated memes

![Memes about instability during the Spider-Man ticket presale](meme-instabilidade.png)

### Others were not so happy

![Comments on ingresso.com's Instagram post about the presale](instagram-reclamacoes-1.png "Instagram — @ingressocom")

![Users reporting ticket purchase failures](instagram-reclamacoes-2.png "Instagram — @ingressocom")

### Post with a statement from ingresso.com

![Ingresso.com's statement about record simultaneous traffic](instagram-nota-de-esclarecimento.png "Instagram — @ingressocom")

> Performance tests help prevent the situations described above and maintain an application's quality and scalability!

### Some types of performance testing

- Load testing;
- Stress testing;
- Long-duration or endurance testing;
- Configuration testing;
- Regression testing: a testing cycle to validate performance improvements;

When planning system testing, consider regression tests too. What is the core of your system? Which feature cannot stop working? Answering those questions can help identify where to focus regression testing. Alongside regression tests, it is worth having *a minimum level of unit test coverage to ensure that fixes requested or required by performance tests do not introduce new bugs*.

> For regression testing, automate the main flow end to end and talk to developers about covering it with unit tests.

In the ingresso.com example, high traffic was already expected because of the hype surrounding a major premiere. Another example mentioned earlier was *Black Friday*, when many people visit websites to shop.

> The example in [this reference video](https://youtu.be/o_FMy9NT_XU?t=2144) discusses tests at iFood that run every minute against its main flow: placing an order. That cannot stop working in the application. In this case, those tests are planned to run continuously.
>
> **PS**: this text is intended only to analyze and study an event. It is not an attempt to disparage ingresso.com.

## Sources

*Performance testing reading*: <https://www.testar.me/teste-de-performance>

*Meme pages*: @superhelandia, @lastimarvel, @nerdonautas\
*References*: ingresso.com, its website and Instagram account.

*Reference and study videos*:\
[168 — Software no iFood com Braca: Arquitetura e Testes! | theWiseDev-chat](https://youtu.be/o_FMy9NT_XU?t=2144)

[Como fazer o Ingresso.com escalar? | Conceitos Intermediários de Web](https://youtu.be/0TMr8rsmU-k)\
The video above analyzes ingresso.com with an [emphasis on testing](https://youtu.be/0TMr8rsmU-k?t=2797).
