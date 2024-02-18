[
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}", "priv/repo/seeds.exs"],
  subdirectories: ["priv/repo/migrations"],
  import_deps: [:ecto, :plug],
  line_length: 100,
  locals_without_parens: [
    #
  ]
]
