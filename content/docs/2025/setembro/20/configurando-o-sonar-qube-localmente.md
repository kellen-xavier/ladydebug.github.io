---
title: "Configurando o SonarQube Localmente"
date: 2025-09-20
weight: 1
---

**Isso não é um tutorial,** é mais para o entendimento e estudo sobre a ferramenta e como aplicar ela em projetos pequenos, até médio porte, em repositórios fechados (código privado). Bom, como eu já tinha o SonarQube instalado na minha máquina, abaixo segue como configurar o Docker.

---

## **Opção 1: Remover o container existente**

Para um trabalho de Pós-graduação eu tinha configurado para um projeto de estudo de análise de código, neste caso foi reconfigurar para outro projeto (depois eu configuro novamente correto para o projeto de estudo de análise de código).

`docker rm sonarqube`

![image1.png](content/docs/2025/setembro/20/img/image1.png)

Agora posso executar o comando para subir um novo container:

`docker run -d --name sonarqube -p 9000:9000 sonarqube:lts-community`

> Sim, a versão é gratuíta, para aprendizado antes de sair pagando algo que não sabe usar.
>

![image2.png](content/docs/2025/setembro/20/img/image2.png)

### **Opção 2: Substituir o container automaticamente**

Se quiser forçar a substituição, use o parâmetro --rm (remove ao parar) ou --replace (caso use Podman). No Docker, geralmente removemos manualmente como acima.

### **Opção 3: Verificar o status do container**

`docker start sonarqube`

Para encerrar use o comando:

`docker stop sonarqube`

## **Executar o SonarQube localmente**

Agora a parte que interessa é configurar localmente o SonarQube, e fazer um escaneamento básico.

Primeiro um setup de configuração (acho que vale adicionar isso no script de desenvolvimento).

### **1. Pré-requisitos**

- **Java 11 ou superior** instalado na máquina (SonarQube precisa do Java para rodar).
- **Docker** (opcional, mas facilita a execução do SonarQube — realmente).

### **2. Baixando e rodando o SonarQube**

Link de download: [https://www.sonarsource.com/open-source-editions/sonarqube-community-edition/](https://www.sonarsource.com/open-source-editions/sonarqube-community-edition/)

Aqui a primeira parte de ajustar o docker então precisa se atentar a deixar ele executando, corretamente, sem problemas.

`docker run -d --name sonarqube -p 9000:9000 sonarqube:lts-community`

Pronto! SonarQube rodando localmente.

![image3.png](content/docs/2025/setembro/20/img/image3.png)

Ajuste as configurações de senha e segue para a página:

![image.png](Configurando%20o%20SonarQube%20Localmente/image%203.png)

### **Configuração do SonarQube**

- Acesse [http://localhost:9000](http://localhost:9000/)
- Login padrão:
  - Usuário: admin
  - Senha: admin

Agora vamos configurar para fazer um escaneamento do projeto

### **Gerando um Token de autenticação**

1. No menu superior direito, clique no seu usuário > My Account > Security.
2. Em "Generate Tokens", crie um novo token (ex: nome-projeto-token).
3. Guarde esse token (será usado no scanner).

### **Instalando o SonarScanner**

O **SonarScanner** é o CLI para enviar seu código ao SonarQube. Ou seja, localmente via terminal vamos falar para ele ler o projeto e então temos a análise.

### **Instalação via NPM (para projetos Node):**

`npm install -g sonarqube-scanner`

Para referências de cada projeto segue: [https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/scanners/sonarscanner](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/scanners/sonarscanner)

### **Configurando o SonarScanner no Projeto**

Na raiz do projeto, crie um arquivo chamado `sonar-project.properties`:

Exemplo:

```jsx
sonar.projectKey=nome-projeto
sonar.projectName=Nome-projeto
sonar.projectVersion=1.0
sonar.sources=.
sonar.language=js,php
sonar.sourceEncoding=UTF-8
sonar.host.url=http://localhost:9000
sonar.login=SEU_TOKEN_AQUI
```

## **Problemas encontrados**

![problema encontrado ao rodar o escaneamento 2025-09-20_09-24.png](Configurando%20o%20SonarQube%20Localmente/problema_encontrado_ao_rodar_o_escaneamento_2025-09-20_09-24.png)

ERROR: You're not authorized to run analysis. Please contact the project administrator.

### **O que significa esse erro?**

O SonarScanner está tentando enviar os resultados da análise para o SonarQube, mas o usuário (ou token) configurado **não tem permissão** para realizar essa operação no projeto configurado no SonarQube.

**Perfeito! Vamos ver o que fiz de errado**: o nome do projeto no arquivo `sonar-project.properties` não estava igual ao que eu configurei no SonarQube local.

Agora pronto: quando executar o comando `sonar-scanner` vai executar o escaneamento no projeto e seguida mostrar em tela os resultados.

![TERMINAL_SUCESS_2025-09-20_09-33.png](content/docs/2025/setembro/20/img/TERMINAL_SUCESS_2025-09-20_09-33.png)

![EXECTUADO 2025-09-20_09-32.png](content/docs/2025/setembro/20/img/EXECTUADO_2025-09-20_09-32.png)
