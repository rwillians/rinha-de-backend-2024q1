defmodule RinhaWeb.PingRoute do
  use RinhaWeb, type: :route

  @impl Plug
  def call(conn, _opts) do
    # @todo check if the database connection is working
    send_resp(conn, 200, "pong!")
  end
end
