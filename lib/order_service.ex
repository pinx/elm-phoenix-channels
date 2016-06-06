defmodule OrderService do
  use GenServer

  alias Meep.Order

  def start_link(repo) do
    case repo.get(Order, 1) do
      nil -> repo.insert!(%Order{qty: 0})
      _ -> 0
    end
    GenServer.start_link(__MODULE__, repo, name: __MODULE__)
  end

  def update_qty(qty) do
    GenServer.call(__MODULE__, {:update_qty, qty})
  end

  def get_qty do
    GenServer.call(__MODULE__, :get_qty)
  end


  def handle_call({:update_qty, qty}, _caller, repo) do
    %Order{id: 1}
    |> Ecto.Changeset.change(%{qty: qty})
    |> repo.update()
    {:reply, qty, repo}
  end

  def handle_call(:get_qty, _caller, repo) do
    result = repo.get!(Order, 1)
    {:reply, result.qty, repo}
  end
end

