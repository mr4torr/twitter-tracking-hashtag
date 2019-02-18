# Twitter integration
App que acompanha tweets de hashtags expecíficas

## Demo
[https://magrathealabs.herokuapp.com/]https://magrathealabs.herokuapp.com/

Usuário: admin@example.com
Senha: password


## Installation
A API do Twitter exige que você se autentique, então você precisará
[registrar seu app no Twitter][register]. Depois de registrar sua
aplicação.

[register]: https://apps.twitter.com/


Seu novo aplicativo receberá chaves access_token/secret para o aplicativo consumir a api. Você precisará
adicionar esses valores no arquivo `.env`, para isso faça uma cópia do arquivo `.env.example` e atribua o nome de `.env`

```bash
cp .env.example .env
```

```bash
// Arquivo .env
DEV_TWITTER_API_KEY=
DEV_TWITTER_SECRET_KEY=
DEV_TWITTER_ACCESS_TOKEN=
DEV_TWITTER_SECRET_TOKEN=

TEST_TWITTER_API_KEY=
TEST_TWITTER_SECRET_KEY=
TEST_TWITTER_ACCESS_TOKEN=
TEST_TWITTER_SECRET_TOKEN=

```

Antes de fazer o setup, você ainda conferir/preencher os dados do seu banco de dados no arquivo `config/database.yml`.

## Setup
Rode os comando abaixo para rodar o setup inicial.

```bash
bin/bundle install
bin/rails db:create
bin/rails db:migrate
yarn install
```

## Start
Para rodar o servidor basta rodar o comando abaixo e acessar em seu navegador pelo endereço `http://localhost:3000`.

```bash
bin/rails s
```
