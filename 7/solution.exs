defmodule Solution do
  def answer do
    nth_prime(10001)
  end

  def nth_prime(n) do
    nth_prime(n - 1, 3, [2])
  end

  def nth_prime(n, i, prime_list) do
    cond do
      n == 0 -> Enum.reverse(prime_list) |> Enum.at(0)
      Enum.any?(prime_list, fn(x) -> rem(i, x) == 0 end) -> nth_prime(n, i + 1, prime_list)
      true -> nth_prime(n - 1, i + 1, prime_list ++ [i])
    end
  end
end

