defmodule RinhaWeb.ExtratoTest do
  use RinhaWeb.ConnCase, async: true

  describe "GET /clientes/:cliente_id/extrato" do
    test "404 :: quando cliente não existe" do
      conn = req(:get, "/clientes/1/extrato")
      assert conn.status == 404
    end

    test "404 :: quando o id do cliente não é um número base 10 válido" do
      conn = req(:get, "/clientes/1FF/extrato")
      assert conn.status == 404
    end

    test "200 :: quando cliente existe" do
      cliente = criar_cliente!()

      conn = req(:get, "/clientes/#{cliente.id}/extrato")
      assert conn.status == 200

      body = Jason.decode!(conn.resp_body, keys: :atoms)
      assert body[:saldo][:total] == cliente.saldo
      assert body[:saldo][:limite] == cliente.limite
      assert is_binary(body[:saldo][:data_extrato])
      assert is_list(body[:ultimas_transacoes])
    end

    test "200 :: contem as últimas 10 transações do cliente" do
      cliente = criar_cliente!()

      transacoes = [
        %{"cliente_id" => cliente.id, "tipo" => "c", "valor" => 10_00, "descricao" => "1"},
        %{"cliente_id" => cliente.id, "tipo" => "c", "valor" => 20_00, "descricao" => "2"},
        %{"cliente_id" => cliente.id, "tipo" => "d", "valor" => 30_00, "descricao" => "3"},
        %{"cliente_id" => cliente.id, "tipo" => "c", "valor" => 40_00, "descricao" => "4"},
        %{"cliente_id" => cliente.id, "tipo" => "d", "valor" => 50_00, "descricao" => "5"},
        %{"cliente_id" => cliente.id, "tipo" => "c", "valor" => 60_00, "descricao" => "6"},
        %{"cliente_id" => cliente.id, "tipo" => "d", "valor" => 70_00, "descricao" => "7"},
        %{"cliente_id" => cliente.id, "tipo" => "c", "valor" => 80_00, "descricao" => "8"},
        %{"cliente_id" => cliente.id, "tipo" => "d", "valor" => 90_00, "descricao" => "9"},
        %{"cliente_id" => cliente.id, "tipo" => "c", "valor" => 100_00, "descricao" => "10"},
        %{"cliente_id" => cliente.id, "tipo" => "d", "valor" => 110_00, "descricao" => "11"},
      ]

      for payload <- transacoes do
        {:ok, _} = Rinha.postar_transacao(payload)
      end

      conn = req(:get, "/clientes/#{cliente.id}/extrato")
      assert conn.status == 200

      body = Jason.decode!(conn.resp_body)
      assert Enum.count(body["ultimas_transacoes"]) == 10

      actual = Enum.map(body["ultimas_transacoes"], &Map.drop(&1, ["realizada_em"]))
      expected = Enum.map(transacoes, &Map.drop(&1, ["cliente_id"]))

      assert actual == [
        Enum.at(expected, 10),
        Enum.at(expected, 9),
        Enum.at(expected, 8),
        Enum.at(expected, 7),
        Enum.at(expected, 6),
        Enum.at(expected, 5),
        Enum.at(expected, 4),
        Enum.at(expected, 3),
        Enum.at(expected, 2),
        Enum.at(expected, 1)
      ]
    end
  end
end
