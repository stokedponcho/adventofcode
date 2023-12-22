defmodule DayThree do
  def calculate(input) do
    {numbers, symbols} =
      File.stream!(input)
      |> Enum.map(&String.trim(&1))
      |> parse()

    numbers
    |> Enum.map(fn {index, values} ->
      symbols_top = null_or_empty(Map.get(symbols, index - 1))
      symbols_middle = Map.get(symbols, index)
      symbols_bottom = null_or_empty(Map.get(symbols, index + 1))

      values
      |> Enum.filter(fn {coord, _} ->
        intersect(coord, symbols_top) ||
          intersect(coord, symbols_middle) ||
          intersect(coord, symbols_bottom)
      end)
      |> Enum.map(fn {_, number} ->
        String.to_integer(number)
      end)
    end)
    |> List.flatten()
    |> Enum.sum()
  end

  defp null_or_empty(val) when is_list(val), do: val
  defp null_or_empty(val) when is_nil(val), do: []

  defp parse(stream) do
    stream
    |> Enum.with_index()
    |> Enum.reduce({%{}, %{}}, fn {line, index}, {numbers, symbols} ->
      number_indices =
        Regex.scan(~r/(\d+)/, line, return: :index, capture: :all_but_first)
        |> List.flatten()

      number_values =
        Regex.scan(~r/(\d+)/, line, capture: :all_but_first)
        |> List.flatten()

      symbol_indices =
        Regex.scan(~r/([^\.^\d^\s])/, line, return: :index, capture: :all_but_first)
        |> List.flatten()

      values =
        number_indices
        |> Enum.with_index()
        |> Enum.map(fn {indices, i} ->
          {indices, number_values |> Enum.at(i)}
        end)

      {Map.put(numbers, index, values), Map.put(symbols, index, symbol_indices)}
    end)
  end

  defp intersect(number, symbols) when is_list(symbols) do
    symbols |> Enum.any?(&intersect(number, &1))
  end

  defp intersect(number, symbol) do
    symbol_pos = elem(symbol, 0)
    number_start = elem(number, 0)
    number_end = number_start + elem(number, 1) - 1

    number_start - 1 <= symbol_pos && symbol_pos <= number_end + 1
  end
end

# 4361
IO.inspect(DayThree.calculate("2023/day03_example"))
# 560670
IO.inspect(DayThree.calculate("2023/day03_input"))
