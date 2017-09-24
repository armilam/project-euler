defmodule Solution do
  def answer() do
    Enum.reduce(2..20, 1, fn(a, acc) -> lcm(a, acc) end)
  end

  def lcm(a, b) do
    round(a * b / gcd(a, b))
  end

  def gcd(a, b) when b == 0 do
    a
  end

  def gcd(a, b) do
    gcd(b, rem(a, b))
  end
end

