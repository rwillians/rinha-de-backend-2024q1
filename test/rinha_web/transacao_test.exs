defmodule RinhaWeb.TransacaoTest do
  use RinhaWeb.ConnCase, async: true

  describe "POST /clientes/:cliente_id/transacoes" do
    test "422 :: quando tipo é inválido" do
      cliente = criar_cliente!()

      conn =
        req(:post, "/clientes/#{cliente.id}}/transacoes", %{
          tipo: "x",
          valor: 100_00,
          descricao: "test"
        })

      assert conn.status == 422
    end

    test "422 :: quando valor é inválido" do
      cliente = criar_cliente!()

      conn =
        req(:post, "/clientes/#{cliente.id}}/transacoes", %{
          tipo: "c",
          valor: "1FF",
          descricao: "test"
        })

      assert conn.status == 422
    end

    test "422 :: quando descricao é inválido" do
      cliente = criar_cliente!()

      conn1 = req(:post, "/clientes/#{cliente.id}}/transacoes", %{tipo: "c", valor: 100_00, descricao: ""})
      conn2 = req(:post, "/clientes/#{cliente.id}}/transacoes", %{tipo: "c", valor: 100_00, descricao: nil})
      conn3 = req(:post, "/clientes/#{cliente.id}}/transacoes", %{tipo: "c", valor: 100_00, descricao: "abcdefghijk"})

      assert conn1.status == 422
      assert conn2.status == 422
      assert conn3.status == 422
    end

    test "404 :: quando cliente não existe" do
      conn =
        req(:post, "/clientes/234093/transacoes", %{
          tipo: "c",
          valor: 100_00,
          descricao: "test"
        })

      assert conn.status == 404
    end

    test "200 :: quando transacao é criada com sucesso (crédito)" do
      cliente = criar_cliente!(limite: 200_00)

      conn =
        req(:post, "/clientes/#{cliente.id}/transacoes", %{
          tipo: "c",
          valor: 100_00,
          descricao: "test"
        })

      assert conn.status == 200

      body = Jason.decode!(conn.resp_body, keys: :atoms)
      assert body[:saldo] == 100_00
      assert body[:limite] == 200_00
    end

    test "200 :: quando transacao é criada com sucesso (débito)" do
      cliente = criar_cliente!(limite: 200_00)

      conn =
        req(:post, "/clientes/#{cliente.id}/transacoes", %{
          tipo: "d",
          valor: 100_00,
          descricao: "test"
        })

      assert conn.status == 200

      body = Jason.decode!(conn.resp_body, keys: :atoms)
      assert body[:saldo] == -100_00
      assert body[:limite] == 200_00
    end

    test "422 :: quando limite de saldo negativo é excedido" do
      cliente = criar_cliente!(limite: 150_00)

      conn1 = req(:post, "/clientes/#{cliente.id}/transacoes", %{tipo: "d", valor: 100_00, descricao: "test"})
      conn2 = req(:post, "/clientes/#{cliente.id}/transacoes", %{tipo: "d", valor: 100_00, descricao: "test"})

      assert conn1.status == 200
      assert conn2.status == 422
    end

    test "não vacila no limite quando tem concorrência" do
      cliente = criar_cliente!(limite: 100_00)

      tasks =
        for _ <- 1..150 do
          Task.async(fn ->
            Process.sleep(Enum.random(0..5))

            req(:post, "/clientes/#{cliente.id}/transacoes", %{
              tipo: "d",
              valor: 1_00,
              descricao: "teste"
            })
          end)
        end

      Enum.each(tasks, &Task.await/1)

      cliente = Rinha.Repo.get(Rinha.Cliente, cliente.id)

      assert cliente.saldo == -100_00
    end
  end
end
