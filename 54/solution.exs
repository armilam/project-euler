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
    {parse_value(String.slice(card, 0..0)), String.slice(card, 1..1)} # parse_suit(String.slice(card, 1..1))}
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
  def value(hand) do
    [hand_type(hand)] ++ (
      Enum.map(hand, fn(card) -> elem(card, 0)  end)
      |> Enum.reverse
    )
  end

  def hand_type(hand) do
    cond do
      PokerHand.royal_flush?(hand) -> 10
      PokerHand.straight_flush?(hand) -> 9
      PokerHand.four_of_a_kind?(hand) -> 8
      PokerHand.full_house?(hand) -> 7
      PokerHand.flush?(hand) -> 6
      PokerHand.straight?(hand) -> 5
      PokerHand.three_of_a_kind?(hand) -> 4
      PokerHand.two_pair?(hand) -> 3
      PokerHand.one_pair?(hand) -> 2
      true -> 1
    end
  end

  def royal_flush?([{10, suit}, {11, suit}, {12, suit}, {13, suit}, {14, suit}]) do
    true
  end

  def royal_flush?(_) do
    false
  end

  def straight_flush?(hand) do
    straight?(hand) and flush?(hand)
  end

  def four_of_a_kind?([{value, _}, {value, _}, {value, _}, {value, _}, {_, _}]) do
    true
  end

  def four_of_a_kind?([{_, _}, {value, _}, {value, _}, {value, _}, {value, _}]) do
    true
  end

  def four_of_a_kind?(_) do
    false
  end

  def full_house?([{value1, _}, {value1, _}, {value1, _}, {value2, _}, {value2, _}]) do
    true
  end

  def full_house?([{value1, _}, {value1, _}, {value2, _}, {value2, _}, {value2, _}]) do
    true
  end

  def full_house?(_) do
    false
  end

  def flush?([{_, suit}, {_, suit}, {_, suit}, {_, suit}, {_, suit}]) do
    true
  end

  def flush?(_) do
    false
  end

  def straight?([{v1, _}, {v2, _}, {v3, _}, {v4, _}, {v5, _}]) when v2==v1+1 and v3==v2+1 and v4==v3+1 and v5==v4+1 do
    true
  end

  def straight?(_) do
    false
  end
 
  def three_of_a_kind?([{value, _}, {value, _}, {value, _}, {_, _}, {_, _}]) do
    true
  end

  def three_of_a_kind?([{_, _}, {value, _}, {value, _}, {value, _}, {_, _}]) do
    true
  end

  def three_of_a_kind?([{_, _}, {_, _}, {value, _}, {value, _}, {value, _}]) do
    true
  end

  def three_of_a_kind?(_) do
    false
  end

  def two_pair?([{value1, _}, {value1, _}, {value2, _}, {value2, _}, {_, _}]) do
    true
  end

  def two_pair?([{value1, _}, {value1, _}, {_, _}, {value2, _}, {value2, _}]) do
    true
  end

  def two_pair?([{_, _}, {value1, _}, {value1, _}, {value2, _}, {value2, _}]) do
    true
  end

  def two_pair?(_) do
    false
  end

  def one_pair?([{value, _}, {value, _}, {_, _}, {_, _}, {_, _}]) do
    true
  end

  def one_pair?([{_, _}, {value, _}, {value, _}, {_, _}, {_, _}]) do
    true
  end

  def one_pair?([{_, _}, {_, _}, {value, _}, {value, _}, {_, _}]) do
    true
  end

  def one_pair?([{_, _}, {_, _}, {_, _}, {value, _}, {value, _}]) do
    true
  end

  def one_pair?(_) do
    false
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
