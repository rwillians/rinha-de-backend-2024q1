# Rinha de Backend 2024Q1 - Elixir com Maizena

Um repo de P99 11ms na média¹ de todas as requests. Sem otimizações — ok tem 2 queries levement otimizadas —, sem procedures, sem cache, utilizando query builder e data mapper. Apenas o bom e velho Elixir com PostgreSQL (e HAProxy fazendo proxy L4).

Não sabe por onde começar a ler o código? Experimente começar por `lib/rinha_web/endpoint.ex` e, então, siga as dependências.

_¹ Testado em um Intel Core i3-1215u (8T, 2Pc máx 4.40GHz, 4Ec máx 3.30GHz), 16GB LPDDR5 2400MHz com SSD M.2 SATA._
