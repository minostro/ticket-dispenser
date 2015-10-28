defmodule Dispenser.Server do
  def loop(ticket_id) do
    receive do
      {from, ref, :take_ticket} ->
        send from, {self(), ref, ticket_id}
        loop(ticket_id + 1)
      {from, ref, :current_ticket} ->
        send from, {self(), ref, ticket_id}
        loop(ticket_id)
      {:reset} ->
        loop(1)
      {:stop} ->
        true
    end
  end

  # # API
  def start() do
    spawn(Dispenser.Server, :loop, [1])
  end

  def take_ticket(pid) do
    ref = make_ref()
    send pid, {self(), ref, :take_ticket}
    receive do
      {^pid, ^ref, msg} -> msg
    end
  end

  def current_ticket(pid) do
    ref = make_ref()
    send pid, {self(), ref, :current_ticket}
    receive do
      {^pid, ^ref, msg} -> msg
    end
  end

  def reset(pid) do
    send pid, {:reset}
  end

  def stop(pid) do
    send pid, {:stop}
  end
end
