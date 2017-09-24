defmodule Solution do
  def answer() do
    # This works, but is very inefficient. I think we can make flat_map_reduce useful.
    Enum.flat_map(100..999, fn(a) -> Enum.map(a..999, fn(b) -> a * b end) end)
    |> Enum.filter(fn(product) -> palindrome?(Kernel.inspect(product)) end)
    |> Enum.max
  end

  def palindrome?(a) when byte_size(a) < 2 do
    true
  end

  def palindrome?(a) do
    String.slice(a, 0..0) == String.slice(a, -1..-1) && palindrome?(String.slice(a, 1..-2)) 
  end
end
