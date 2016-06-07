defmodule Meep.RoomChannel do
  use Phoenix.Channel
  require Logger

  @doc """
  Authorize socket to subscribe and broadcast events on this channel & topic
  Possible Return Values
  `{:ok, socket}` to authorize subscription for channel for requested topic
  `:ignore` to deny subscription/broadcast on this channel
  for the requested topic
  """
  def join("rooms:lobby", message, socket) do
    message = Map.put(message, :qty, 0)
    Logger.debug(inspect message)
    Process.flag(:trap_exit, true)
    :timer.send_interval(10_000, :ping)
    send(self, {:after_join, message})

    {:ok, socket}
  end

  def join("rooms:" <> _private_subtopic, _message, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_info({:after_join, msg}, socket) do
    broadcast! socket, "user:entered", %{user: msg["user"]}
    qty = OrderService.get_qty
    push socket, "join", %{status: "connected", qty: qty}
    {:noreply, socket}
  end
  def handle_info(:ping, socket) do
    push socket, "new:msg", %{user: "SYSTEM", body: "ping"}
    {:noreply, socket}
  end

  def terminate(reason, _socket) do
    Logger.debug"> leave #{inspect reason}"
    :ok
  end

  def handle_in("new:msg", msg, socket) do
    broadcast! socket, "new:msg", %{user: msg["user"], body: msg["body"]}
    {:reply, {:ok, %{msg: msg["body"]}}, assign(socket, :user, msg["user"])}
  end

  def handle_in("update:qty", qty_msg, socket) do
    case Integer.parse(qty_msg["qty"]) do
      :error -> 0
        {:error, %{reason: "invalid number"}}
      {qty, _rem} ->
        OrderService.update_qty qty
        broadcast! socket, "update:qty", %{user: qty_msg["user"], qty: qty}
        {:reply, {:ok, %{qty: qty}}, assign(socket, :user, qty_msg["user"])}
    end
  end
end
