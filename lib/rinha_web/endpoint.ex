defmodule RinhaWeb.Endpoint do
  use Plug.Router
  use Plug.ErrorHandler

  import Ex.Plug.Conn

  plug Plug.RequestId
  plug Plug.Logger, log: :info

  plug Plug.Static,
    at: "/",
    from: :spub,
    gzip: false,
    only: ~w(robots.txt favicon.ico)

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, {:json, json_decoder: Jason}],
    pass: ["*/*"]

  plug :match
  plug :dispatch

  get "/ping", to: RinhaWeb.PingRoute

  match _ do
    send_resp(conn, 404, "")
  end

  @impl Plug.ErrorHandler
  def handle_errors(conn, %{kind: _kind, reason: reason, stack: _stack}) do
    send_resp_json(conn, conn.status, %{
      errors: [%{message: inspect(reason)}]
    })
  end
end
