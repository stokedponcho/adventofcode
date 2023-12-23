# Thoughts: matrix using 2 maps made things harder to think about

defmodule DayThree do
  def parts(input) do
    {numbers_matrix, symbols_matrix} =
      File.stream!(input)
      |> Enum.map(&String.trim(&1))
      |> parse(~r/([^\d^\.^\s])/)

    numbers_matrix
    |> Enum.map(fn {y, xs} ->
      xs
      |> Enum.filter(fn {x, {length, _}} ->
        min_x = x - 1
        max_x = x + length
        min_y = y - 1
        max_y = y + 1

        symbols_matrix
        |> Enum.any?(fn {row, cols} ->
          cols
          |> Enum.any?(fn {col, _} ->
            min_x <= col and col <= max_x and
              min_y <= row and row <= max_y
          end)
        end)
      end)
      |> Enum.map(fn {_, {_, number}} -> number end)
    end)
    |> List.flatten()
    |> Enum.sum()
  end

  def gears(input) do
    {numbers_matrix, symbols_matrix} =
      File.stream!(input)
      |> Enum.map(&String.trim(&1))
      |> parse(~r/(\*)/)

    symbols_matrix
    |> Enum.map(fn {row, cols} ->
      cols
      |> Enum.map(fn {col, _} ->
        {adjacent_count, result} =
          numbers_matrix
          |> Enum.reduce({0, 1}, fn {y, xs}, acc ->
            xs
            |> Enum.reduce(acc, fn {x, {length, number}}, {count, product} ->
              if count > 2 do
                {count, product}
              else
                min_x = x - 1
                max_x = x + length
                min_y = y - 1
                max_y = y + 1

                row? = min_y <= row and row <= max_y
                col? = min_x <= col and col <= max_x

                case row? and col? do
                  true -> {count + 1, product * number}
                  false -> {count, product}
                end
              end
            end)
          end)

        case adjacent_count == 2 do
          true -> result
          false -> 0
        end
      end)
    end)
    |> List.flatten()
    |> Enum.sum()
  end

  defp parse(stream, pattern) do
    stream
    |> Enum.with_index()
    |> Enum.reduce({%{}, %{}}, fn {line, x}, {numbers_matrix, symbols_matrix} ->
      numbers =
        Regex.scan(~r/(\d+)/, line, return: :index, capture: :all_but_first)
        |> List.flatten()
        |> Enum.reduce(%{}, fn {offset, length}, acc ->
          y = offset
          value = String.slice(line, offset, length) |> String.to_integer()

          Map.put(acc, y, {length, value})
        end)

      symbols =
        Regex.scan(pattern, line, return: :index, capture: :all_but_first)
        |> List.flatten()
        |> Enum.reduce(%{}, fn {offset, length}, acc ->
          y = offset
          value = String.slice(line, offset, length)

          Map.put(acc, y, value)
        end)

      {Map.put(numbers_matrix, x, numbers), Map.put(symbols_matrix, x, symbols)}
    end)
  end
end

# 4361
IO.inspect(DayThree.parts("2023/day03_example"))
# 560670
IO.inspect(DayThree.parts("2023/day03_input"))
# 467835
IO.inspect(DayThree.gears("2023/day03_example"))
# 91622824
IO.inspect(DayThree.gears("2023/day03_input"))
