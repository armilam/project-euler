defmodule Solution do
  def answer() do
    sum(1..999)
  end

  def sum(range) do
    Enum.reduce(range, 0, fn(i, acc) -> acc + ((rem(i, 5) == 0 || rem(i, 3) == 0) && i || 0) end)
  end
end


