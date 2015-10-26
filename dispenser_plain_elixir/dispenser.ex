defmodule Dispenser do
  def start() do
    Dispenser.Server.start()
  end

  def current_ticket(pid) do
    Dispenser.Server.current_ticket(pid)
  end

  def take_ticket(pid) do
    Dispenser.Server.take_ticket(pid)
  end

  def reset(pid) do
    Dispenser.Server.reset(pid)
  end

  def stop(pid) do
    Dispenser.Server.stop(pid)
  end
end
