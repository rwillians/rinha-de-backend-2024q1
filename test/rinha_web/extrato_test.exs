defmodule RinhaWeb.ExtratoTest do
  use RinhaWeb.ConnCase, async: true

  describe "GET /clientes/:cliente_id/extrato" do
    test "404 :: quando cliente não existe" do
      conn = conn(:get, "/clientes/1/extrato") |> dispatch()
      assert conn.status == 404
    end

    test "404 :: quando o id do cliente não é um número base 10 válido" do
      conn = conn(:get, "/clientes/1FF/extrato") |> dispatch()
      assert conn.status == 404
    end

    test "200 :: quando cliente existe" do
      cliente =
        Rinha.Repo.insert!(%Rinha.Cliente{
          id: Enum.random(1..5000),
          limite: 100_00,
          saldo: 0
        })

      conn = conn(:get, "/clientes/#{cliente.id}/extrato") |> dispatch()
      assert conn.status == 200

      body = Jason.decode!(conn.resp_body, keys: :atoms)
      assert body[:saldo][:total] == cliente.saldo
      assert body[:saldo][:limite] == cliente.limite
      assert is_binary(body[:saldo][:data_extrato])
      assert is_list(body[:ultimas_transacoes])
    end
  end
end
