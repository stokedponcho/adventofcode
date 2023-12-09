defmodule Game do
  defstruct [:id, :red, :green, :blue]
end

defmodule DayTwo do
  def possible(input, bag) do
    File.stream!(input)
    |> Enum.map(&parse_game/1)
    |> Enum.reduce(0, fn game, acc ->
      can_fit =
        game.red <= bag.red &&
          game.green <= bag.green &&
          game.blue <= bag.blue

      case can_fit do
        true -> acc + game.id
        false -> acc
      end
    end)
  end

  def minimum(input) do
    File.stream!(input)
    |> Enum.map(&parse_game/1)
    |> Enum.reduce(0, fn game, acc ->
      acc + game.red * game.green * game.blue
    end)
  end

  defp parse_game(game) do
    Regex.scan(
      ~r/(Game (?<id>\d+):)|((?<red>\d+) red)|((?<green>\d+) green)|((?<blue>\d+) blue)/,
      game,
      capture: ["id", "red", "green", "blue"]
    )
    |> List.zip()
    |> Enum.map(fn group ->
      group
      |> Tuple.to_list()
      |> Enum.reject(&(&1 == ""))
      |> Enum.map(&String.to_integer(&1))
    end)
    |> Enum.with_index()
    |> Enum.reduce(
      %Game{},
      fn group, acc ->
        index = elem(group, 1)
        values = elem(group, 0)

        case index do
          0 -> %{acc | id: values |> List.first()}
          1 -> %{acc | red: values |> Enum.max()}
          2 -> %{acc | green: values |> Enum.max()}
          3 -> %{acc | blue: values |> Enum.max()}
          _ -> acc
        end
      end
    )
  end
end

# 8
IO.inspect(DayTwo.possible("day02_example", %{red: 12, green: 13, blue: 14}))
# 2286
IO.inspect(DayTwo.minimum("day02_example"))
# 2331
IO.inspect(DayTwo.possible("day02_input", %{red: 12, green: 13, blue: 14}))
# 71585
IO.inspect(DayTwo.minimum("day02_input"))
