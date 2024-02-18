FROM elixir:1.16.1-alpine AS build

WORKDIR /app
ARG MIX_ENV=prod

COPY mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

COPY rel/ rel/
COPY config/ config/
COPY lib/ lib/
COPY priv/ priv/
RUN mix do compile, release

#

FROM elixir:1.16.1-alpine AS release

WORKDIR /app
ARG MIX_ENV=prod

COPY --from=build /app/_build/${MIX_ENV}/rel/rinha /app

ENTRYPOINT ["/app/bin/rinha"]
CMD [ "start" ]
