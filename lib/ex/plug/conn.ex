defmodule Ex.Plug.Conn do
  @moduledoc """
  Extendend functionalities for `Plug.Conn`.
  """

  import Plug.Conn, only: [put_resp_content_type: 2, send_resp: 3]

  @doc """
  Sends a JSON response with the given status and body.
  """
  @spec send_resp_json(conn, status, body) :: conn
        when conn: Plug.Conn.t(),
             status: pos_integer,
             body: Jason.Encoder.t()

  def send_resp_json(conn, status, body) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(body))
  end
end
