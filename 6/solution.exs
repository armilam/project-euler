defmodule Solution do
  def answer do
    sum = 1..100
    |> Enum.to_list
    |> Enum.sum

    squares = 1..100
              |> Enum.to_list
              |> Enum.map(fn(x) -> x * x end)
              |> Enum.sum

    sum * sum - squares
  end
end

