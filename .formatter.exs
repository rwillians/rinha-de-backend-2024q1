[
  inputs: ["*.{exs}", "{config,lib,test}/**/*.{ex,exs}", "priv/*/seeds.exs"],
  subdirectories: ["priv/repo/migrations"],
  import_deps: [:ecto, :plug],
  line_length: 100,
  # locals_without_parens: [
  #   #
  # ]
]
