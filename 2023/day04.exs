defmodule DayFour do
  def points(input) do
    File.stream!(input)
    |> Enum.map(&parse(&1))
    |> Enum.reduce(0, fn %{winners: winners, candidates: candidates}, sum ->
      count = candidates |> Enum.count(fn c -> Enum.member?(winners, c) end)

      case count == 0 do
        true -> sum
        _ -> sum + 2 ** (count - 1)
      end
    end)
  end

  def stacks(input) do
    cards =
      File.stream!(input)
      |> Enum.map(&parse(&1))

    decks =
      1..Enum.count(cards)
      |> Enum.reduce(%{}, fn c, acc -> Map.put(acc, c, 1) end)

    cards
    |> Enum.with_index(1)
    |> Enum.reduce(decks, fn {%{winners: winners, candidates: candidates}, card}, acc ->
      count = candidates |> Enum.count(fn c -> Enum.member?(winners, c) end)

      first = card + 1
      last = card + count

      cond do
        first <= last ->
          to_add = Map.get(acc, card)

          first..last
          |> Enum.reduce(acc, fn i, sub_acc ->
            existing = Map.get(sub_acc, i)

            Map.put(sub_acc, i, existing + to_add)
          end)

        true ->
          acc
      end
    end)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.sum()
  end

  def parse(line) do
    numbers =
      line
      |> String.trim()
      |> String.split(":")
      |> Enum.at(1)
      |> String.split("|")

    scan = fn str ->
      Regex.scan(~r/(\d+)/, str, capture: :all_but_first)
      |> List.flatten()
      |> Enum.map(&String.to_integer(&1))
    end

    %{
      winners: List.first(numbers) |> scan.(),
      candidates: List.last(numbers) |> scan.()
    }
  end
end

# 13
IO.inspect(DayFour.points("2023/day04_example"))
# 25010
IO.inspect(DayFour.points("2023/day04_input"))
# 30
IO.inspect(DayFour.stacks("2023/day04_example"))
# 9924412
IO.inspect(DayFour.stacks("2023/day04_input"))
