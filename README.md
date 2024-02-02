# Rinha de Backend 2024Q1

This repository has for objectives:
1) recreate the library [`Bookk`](https://github.com/rwillians/book)
   that helps with the manipulation of double-entry ledgers, for
   educational purposes; and
2) implement a solution for the [Rinha de Backend](#todo) challenge,
   2024Q1 edition.

You'll find a log of the progress and their related PRs at the end of
this document.


## Summary

* Instructions on how to run locally
* Progress log


## Instructions on how to run locally

> [!WARNING]
> You need postgres exposed locally at port `5432`. If it is exposed
> to a different port, then use the environment variables
> `TEST_DATABASE_URL`, `DEV_DATABASE_URL` and `DATABASE_URL` to set
> the connection url for the test, development and production
> environment, respectivelly.

You'll need both Elixir (`~> 1.16`) and Erlang (`~> 26.2`) installed in
your machine. The recommended way of doing it is by using [`asdf`](https://asdf-vm.com/).
Navigate to the project's root directory then execute:

```bash
asdf install
```

Now install the project's dependencies:

```bash
mix deps.get
```

## Test environment

Create the test database and import its schema:

```bash
MIX_ENV=test mix do ecto.create, ecto.load
```

Run tests:

```bash
mix test
```

### Development environment

Create the dev database and import its schema:

```bash
mix do ecto.create, ecto.load
```

Execute the application with a terminal attached:

```bash
iex -S mix
```

### Production environment (release mod)

Create the production database and import its schema:

```bash
MIX_ENV="prod" \
DATABASE_URL="postgres://postgres:postgres@localhost:5432/rinha_prod" \
ECTO_SSL_ENABLED="false" \
mix do ecto.create, ecto.load
```

Compile the release:

```bash
rm -rf _build/prod/lib/rinha _build/prod/rel/rinha && \
   MIX_ENV=prod mix do compile --force, release
```

Run the application:

```bash
MIX_ENV="prod" \
DATABASE_URL="postgres://postgres:postgres@localhost:5432/rinha_prod" \
ECTO_SSL_ENABLED=false \
HTTP_SERVER_ENABLED=true \
PORT=3000 \
_build/prod/rel/rinha/bin/rinha start
```

> [!NOTE]
> Replace the `DATABASE_URL` environment variable according to your
> needs.


## Progress Log

**Setup**:
- [ ] [**PR#1**](https://github.com/rwillians/rinha-de-backend-2024q1/pull/1) :: create application boilerplate;
- [ ] **PR#2** :: containerize the application;

**Recreating Bookk**:
- [ ] **PR#3** :: create an account and update its balance;
- [ ] **PR#4** :: update an account's balance in a ledger;
- [ ] **PR#6** :: in-memory state;
- [ ] **PR#5** :: using a chart of accounts;
- [ ] **PR#6** :: introduce interledger journal entries;
- [ ] **PR#7** :: create a DSL (Domain Specific Language) for journalizing;

**Solving the Challenge**: tbd.
