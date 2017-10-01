defmodule Solution do
  def answer() do
    File.stream!("p054_poker.txt")
    |> Stream.map(fn(line) -> parse_line(line) end)
    |> Enum.to_list
    |> Enum.count(fn([player1_hand, player2_hand]) ->
      winner?(player1_hand, player2_hand)
    end)
  end

  def parse_line(line) do
    [parse_hand(String.slice(line, 0..13)), parse_hand(String.slice(line, 15..-1))]
  end

  def parse_hand(hand) do
    parsed_hand = String.split(hand, " ")
    |> Enum.map(&parse_card/1)

    HandSort.sort_by_number(parsed_hand)
  end

  def parse_card(card) do
    {parse_value(String.slice(card, 0..0)), String.slice(card, 1..1)}
  end

  def parse_suit(suit) do
    case suit do
      "H" -> :hearts
      "D" -> :diamonds
      "C" -> :clubs
      "S" -> :spades
    end  
  end

  def parse_value(value) do
    case value do
      "A" -> 14
      "K" -> 13
      "Q" -> 12
      "J" -> 11
      "T" -> 10  
      other -> String.to_integer(other)
    end  
  end

  def winner?(player1_hand, player2_hand) do
    PokerHand.value(player1_hand) > PokerHand.value(player2_hand)
  end

end

defmodule PokerHand do
  def values(hand) do
    Enum.map(hand, fn(card) -> elem(card, 0) end)
  end

  def value(hand) do
    cond do
      elem({match, value} = PokerHand.royal_flush?(hand), 0) -> [10] ++ value
      elem({match, value} = PokerHand.straight_flush?(hand), 0) -> [9] ++ value
      elem({match, value} = PokerHand.four_of_a_kind?(hand), 0) -> [8] ++ value
      elem({match, value} = PokerHand.full_house?(hand), 0) -> [7] ++ value
      elem({match, value} = PokerHand.flush?(hand), 0) -> [6] ++ value
      elem({match, value} = PokerHand.straight?(hand), 0) -> [5] ++ value
      elem({match, value} = PokerHand.three_of_a_kind?(hand), 0) -> [4] ++ value
      elem({match, value} = PokerHand.two_pair?(hand), 0) -> [3] ++ value
      elem({match, value} = PokerHand.one_pair?(hand), 0) -> [2] ++ value
      true -> [1] ++ (values(hand) |> Enum.reverse)
    end
  end

  def royal_flush?(hand) do
    case hand do
      [{10, suit}, {11, suit}, {12, suit}, {13, suit}, {14, suit}] ->
        {true, values(hand) |> Enum.reverse}
      _ -> {false, []}
    end
  end

  def straight_flush?(hand) do
    case hand do
      [{v1, suit}, {v2, suit}, {v3, suit}, {v4, suit}, {v5, suit}] when v2==v1+1 and v3==v2+1 and v4==v3+1 and v5==v4+1 ->
        {true, (values(hand) |> Enum.reverse)}
      _ -> {false, []}
    end
  end

  def four_of_a_kind?(hand) do
    case hand do
      [{value, _}, {value, _}, {value, _}, {value, _}, {other_value, _}] ->
        {true, [value, other_value]}
      [{other_value, _}, {value, _}, {value, _}, {value, _}, {value, _}] ->
        {true, [value, other_value]}
      _ -> {false, []}
    end
  end

  def full_house?(hand) do
    case hand do
      [{v1, _}, {v1, _}, {v1, _}, {v2, _}, {v2, _}] -> full_house_value(v1, v2)
      [{v1, _}, {v1, _}, {v2, _}, {v2, _}, {v2, _}] -> full_house_value(v1, v2)
      _ -> {false, []}
    end
  end

  def full_house_value(v1, v2) when v1 > v2 do
    {true, [v1, v2]}
  end

  def full_house_value(v1, v2) when v1 < v2 do
    {true, [v2, v1]}
  end

  def flush?(hand) do
    case hand do
      [{_, suit}, {_, suit}, {_, suit}, {_, suit}, {_, suit}] ->
        {true, (values(hand) |> Enum.reverse)}
      _ -> {false, []}
    end
  end

  def straight?(hand) do
    case hand do
      [{v1, _}, {v2, _}, {v3, _}, {v4, _}, {v5, _}] when v2==v1+1 and v3==v2+1 and v4==v3+1 and v5==v4+1 ->
        {true, (values(hand) |> Enum.reverse)}
      _ -> {false, []}
    end
  end

  def three_of_a_kind?(hand) do
    case hand do
      [{value, _}, {value, _}, {value, _}, {v2, _}, {v3, _}] ->
        {true, [value] ++ ([v2, v3] |> Enum.sort |> Enum.reverse)}
      [{v2, _}, {value, _}, {value, _}, {value, _}, {v3, _}] ->
        {true, [value] ++ ([v2, v3] |> Enum.sort |> Enum.reverse)}
      [{v2, _}, {v3, _}, {value, _}, {value, _}, {value, _}] ->
        {true, [value] ++ ([v2, v3] |> Enum.sort |> Enum.reverse)}
      _ -> {false, []}
    end
  end

  def two_pair?(hand) do
    case hand do
      [{v1, _}, {v1, _}, {v2, _}, {v2, _}, {v3, _}] ->
        {true, ([v1, v2] |> Enum.sort |> Enum.reverse) ++ [v3]}
      [{v1, _}, {v1, _}, {v3, _}, {v2, _}, {v2, _}] ->
        {true, ([v1, v2] |> Enum.sort |> Enum.reverse) ++ [v3]}
      [{v3, _}, {v1, _}, {v1, _}, {v2, _}, {v2, _}] ->
        {true, ([v1, v2] |> Enum.sort |> Enum.reverse) ++ [v3]}
      _ -> {false, []}
    end
  end

  def one_pair?(hand) do
    case hand do
      [{value, _}, {value, _}, {v2, _}, {v3, _}, {v4, _}] ->
        {true, [value] ++ ([v2, v3, v4] |> Enum.sort |> Enum.reverse)}
      [{v2, _}, {value, _}, {value, _}, {v3, _}, {v4, _}] ->
        {true, [value] ++ ([v2, v3, v4] |> Enum.sort |> Enum.reverse)}
      [{v2, _}, {v3, _}, {value, _}, {value, _}, {v4, _}] ->
        {true, [value] ++ ([v2, v3, v4] |> Enum.sort |> Enum.reverse)}
      [{v2, _}, {v3, _}, {v4, _}, {value, _}, {value, _}] ->
        {true, [value] ++ ([v2, v3, v4] |> Enum.sort |> Enum.reverse)}
      _ -> {false, []}
    end
  end
end

defmodule HandSort do
  def sort_by_number(hand) do
    Enum.sort_by(hand, &sort_by_number_value/1)
  end

  def sort_by_number_value(card) do
    (elem(card, 0) * 100) + suit_value(elem(card, 1))
  end

  def sort_by_suit(hand) do
    Enum.sort_by(hand, &sort_by_suit_value/1)
  end

  def sort_by_suit_value(card) do
    elem(card, 0) + (suit_value(elem(card, 1)) * 100)
  end
  
  def suit_value(suit) do
    case suit do
      "H" -> 1
      "D" -> 2
      "C" -> 3
      "S" -> 4
    end
  end
end

