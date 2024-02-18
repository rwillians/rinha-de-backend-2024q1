if Mix.env() != :test do
  File.read!("priv/repo/seeds.sql")
  |> Rinha.Repo.query!();
end
