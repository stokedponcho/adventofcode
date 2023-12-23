defmodule DayFour do
  def points(input) do
    File.stream!(input)
    |> parse()
    |> Enum.reduce(0, fn %{winners: winners, candidates: candidates}, sum ->
      count =
        candidates
        |> Enum.filter(fn c -> Enum.member?(winners, c) end)
        |> Enum.count()

      case count == 0 do
        true -> sum
        _ -> sum + 2 ** (count - 1)
      end
    end)
  end

  def parse(lines) do
    lines
    |> Enum.map(fn line ->
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
        winners: Enum.at(numbers, 0) |> scan.(),
        candidates: Enum.at(numbers, 1) |> scan.()
      }
    end)
  end
end

# 13
IO.inspect(DayFour.points("2023/day04_example"))
# ?
IO.inspect(DayFour.points("2023/day04_input"))
