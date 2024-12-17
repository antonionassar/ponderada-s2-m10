# Ponderada Semana 2 - Deploying Backstage on Docker

_Antonio Nassar - Eng. Software - T06_

## Introdução: Backstage e Docker

O Backstage é uma ferramenta (plataforma open-source) desenvolvida pelo time do Spotify, focada em facilitar a criação de conexões internas entre os desenvolvedores, facilitando a gestão de microserviços, libs, APIs, documentos, entre outros, e tudo isso em um lugar único, por meio de uma interface amigável e de fácil navegação.

O Docker é uma plataforma focada em criar e gerenciar aplicações nos chamados containers. Um container é responsável por agrupar todos os arquivos e configurações (dependências) necessárias para que uma aplicação rode sem problemas, seja em um ambiente local ou num servidor da núvem. As chamadas Docker Images são pacotes leves e executáveis contendo tudo necessário para que o software rode adequadamente e sempre em prontidão. Com o Docker, desenvolvedores tem mais facilidade para rodar suas aplicações e também mais segurança e estabilidade, respectivamente.

---

## Passo a Passo: Configuração e Execução da Aplicação

#### 1. Instalação do Yarn

Verificando se o Yarn está instalado e sua versão.

![img](/imgs/bs-p1.png)

#### 2. Instalando Docker

Docker já hávia sido instalado corretamente, sendo esta apenas uma verificação dele.

![img](/imgs/bs-p2.png)

#### 3. Atualizando dependências do macOS

Visto a utilização de um MacBook Pro com chip ARM, algumas dependências precisaram ser atualizadas para suportar a aplicação (via Homebrew).

![img](/imgs/bs-p3.png)

#### 4. Criando a aplicação @backstage/create-app

Criando a aplicação com sucessor e verificando sua estrutura de pastas contendo os arquivos necessários.

![img](/imgs/bs-p4.png)
![img](/imgs/bs-p5.png)

#### 5. Rodando um "yarn install" e iniciando o servidor Backstage

Comandos no terminal para rodar o yarn.

![img](/imgs/bs-p6.png)
![img](/imgs/bs-p7.png)

#### 6. Servidor Backstage em funcionamento

Verifica-se que o servidor Backstage está em funcionamento.

![img](/imgs/bs-p8.png)
![img](/imgs/bs-p9.png)

#### 7. Ajustes de código (app-config.yaml e app-config.production.yaml)

Escrevememos e ajustamos os arquivos para rodarem adequadamente com as configurações da aplicação.

![img](/imgs/bs-p10.png)
![img](/imgs/bs-p11.png)
![img](/imgs/bs-p12.png)

#### 8. Definindo a estrutura do Dockerfile

Definindo um dockerfile adequado para suportar as configurações e necessidades da aplicação.

![img](/imgs/bs-p13.png)

#### 9. Criando uma imagem Docker

Gerando a imagem Docker para rodar a aplicação em um container.

![img](/imgs/bs-p14.png)
![img](/imgs/bs-p15.png)

---

### Conclusão:

Feitas estas etapas, a aplicação se encontra funcionando adequadamente, tanto o servidor e utilização da ferramenta Backstage, quanto a criação da imagem Docker, assim como o tutorial da atividade, respectivamente.
