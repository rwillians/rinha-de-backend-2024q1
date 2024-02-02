defmodule Ex.Plug.Conn do
  @moduledoc """
  Extended functionality for `Plug.Conn`.
  """

  import Plug.Conn,
    only: [
      put_resp_header: 3,
      send_resp: 3
    ]

  @doc """
  Same as `Plug.Conn.send_resp/3`, but sets the response header
  "content-type: application/json" and sends a JSON-encoded body.
  """
  @spec send_resp_json(conn, status, body) :: conn
        when conn: Plug.Conn.t(),
             status: pos_integer,
             body: Jason.Encoder.t()

  def send_resp_json(conn, status, body) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(status, Jason.encode!(body))
  end
end
