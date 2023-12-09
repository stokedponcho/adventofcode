defmodule DayOne do
  def calibrate(input) do
    File.stream!(input)
    |> Enum.reduce(0, fn line, acc ->
      digits =
        Regex.scan(
          ~r/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/,
          line,
          catpure: :all_but_first
        )
        |> List.flatten()
        |> List.delete_at(0)

      acc + to_int(List.first(digits)) * 10 + to_int(List.last(digits))
    end)
  end

  defp to_int(str) do
    case str do
      s when s in ["one", "1"] -> 1
      s when s in ["two", "2"] -> 2
      s when s in ["three", "3"] -> 3
      s when s in ["four", "4"] -> 4
      s when s in ["five", "5"] -> 5
      s when s in ["six", "6"] -> 6
      s when s in ["seven", "7"] -> 7
      s when s in ["eight", "8"] -> 8
      s when s in ["nine", "9"] -> 9
      _ -> 0
    end
  end
end

IO.puts(DayOne.calibrate("day01_example"))
IO.puts(DayOne.calibrate("day01_example2"))
IO.puts(DayOne.calibrate("day01_input"))
