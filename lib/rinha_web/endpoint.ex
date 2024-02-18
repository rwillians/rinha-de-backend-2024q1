defmodule RinhaWeb.Endpoint do
  use Plug.Router
  use Plug.ErrorHandler

  import Ex.Plug.Conn
  import Rinha, only: [pegar_extrato: 1, postar_transacao: 1]

  plug Plug.Parsers,
    parsers: [{:json, json_decoder: Jason}],
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

  get "/clientes/:cliente_id/extrato" do
    case pegar_extrato(conn.params["cliente_id"]) do
      {:ok, extrato} -> send_resp_json(conn, 200, extrato)
      {:error, :cliente_nao_encontrado} -> send_resp(conn, 404, "")
    end
  end

  post "/clientes/:cliente_id/transacoes" do
    case postar_transacao(conn.params) do
      {:ok, balanco} -> send_resp_json(conn, 200, balanco)
      {:error, :cliente_nao_encontrado} -> send_resp(conn, 404, "")
      {:error, :limite_excedido} -> send_resp(conn, 422, "")
      {:error, %Ecto.Changeset{}} -> send_resp(conn, 422, "")
    end
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
