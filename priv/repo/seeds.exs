if Mix.env() == :test,
  do: Process.exit(self(), :normal)

File.read!("priv/repo/seeds.sql")
|> Rinha.Repo.query!();
