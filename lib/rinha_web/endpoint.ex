defmodule RinhaWeb.Endpoint do
  use Plug.Router
  use Plug.ErrorHandler

  plug Plug.Static,
    at: "/",
    from: :rinha,
    gzip: false,
    only: ~w(favicon.ico robots.txt)

  plug Plug.RequestId
  plug Plug.Logger, log: :info

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, {:json, json_decoder: Jason}],
    pass: ["*/*"]

  plug :match
  plug :dispatch

  #
  #   ROUTES
  #

  get "/ping" do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "pong!")
  end

  #
  #   ERROR HANDLING
  #

  match _ do
    conn
    |> put_status(404)
    |> send_resp()
  end

  @impl Plug.ErrorHandler
  def handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    send_resp(conn, conn.status, "Something went wrong")
  end
end
