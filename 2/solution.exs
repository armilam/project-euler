defmodule Solution do
  def answer() do
    fib(1, 2, 0)
  end

  def fib(_, b, sum) when b > 4000000 do
    sum
  end

  def fib(a, b, sum) when rem(b, 2) == 0 do
    fib(b, a+b, sum+b)
  end

  def fib(a, b, sum) do
    fib(b, a+b, sum)
  end
end

