defmodule OrderServiceTest do
  use ExUnit.Case

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Meep.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Meep.Repo, {:shared, self()})
    {:ok, pid} = GenServer.start_link(OrderService, Meep.Repo)
    {:ok, [pid: pid]}
  end

  test "update qty" do
    OrderService.update_qty(1)
    assert OrderService.get_qty == 1
  end
end

