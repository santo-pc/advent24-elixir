defmodule Main do
  def main(_args \\ []) do
    # solution1("./lib/input.txt")
    # |> IO.inspect()

    IO.puts("Solution2: ")

    solution2("./lib/input-test.txt")
    # solution2("./lib/input.txt")
    |> IO.puts()
  end

  def solution2(file) do
    file
    |> File.stream!()
    |> Enum.map(fn content ->
      traverse2(content, 0, 1)
    end)
    |> Enum.sum()

    # IO.puts("Solution2 = #{r}")
  end

  def get_params2(str) do
    # IO.puts("Get params #{str}")

    case Regex.run(~r/^(\d+),(\d+)\)/, str) do
      [_, a, b] -> [String.to_integer(a), String.to_integer(b)]
      _ -> []
    end
  end

  # empty string → stop
  def traverse2("", acc, _) do
    # IO.puts("End of things: result it: #{acc}")
    acc
  end

  def traverse2(content, acc, enable) do
    # IO.puts("Actual: #{content}")
    # IO.puts("Acc: #{acc}")

    cond do
      String.starts_with?(content, "do()") ->
        # IO.puts("Found do()")

        String.graphemes(content)
        |> Enum.slice(4..-1//1)
        |> Enum.join()
        |> traverse2(acc, 1)

      String.starts_with?(content, "don't()") ->
        # IO.puts("Found don't()")

        String.graphemes(content)
        |> Enum.slice(7..-1//1)
        |> Enum.join()
        |> traverse2(acc, 0)

      String.starts_with?(content, "mul(") && enable == 1 ->
        # IO.puts("Found mul(")
        r =
          case String.slice(content, 4..-1//1)
               |> get_params2() do
            [a, b] -> a * b
            [] -> 0
          end

        #
        # String.graphemes(content)
        # |> Enum.slice(4..-1//1)
        # |> get_params()
        # |> Enum.reduce(fn x, acc -> x * acc end)
        #
        String.graphemes(content)
        |> Enum.slice(4..-1//1)
        |> Enum.join()
        |> traverse2(acc + r * enable, enable)

      true ->
        [_ | tail] = String.graphemes(content)
        traverse2(Enum.join(tail), acc, enable)
    end
  end

  def solution1(file) do
    file
    |> File.stream!()
    |> Enum.map(fn content ->
      traverse(content, 0)
    end)
    |> Enum.sum()

    # IO.puts("Solution1 = #{r}")
  end

  # empty string → stop
  def traverse("", acc) do
    # IO.puts("End of things: result it: #{acc}")
    acc
  end

  def traverse(content, acc) do
    # IO.puts("Actual: #{content}")
    # IO.puts("Acc: #{acc}")

    case String.starts_with?(content, "mul(") do
      true ->
        # IO.puts("found mul(")
        ### i need to capture up until the next `)`
        r =
          String.graphemes(content)
          # chop the `mul(` part
          |> Enum.slice(4..-1//1)
          |> get_params()
          |> Enum.reduce(fn x, acc -> x * acc end)

        String.graphemes(content)
        |> Enum.slice(4..-1//1)
        |> Enum.join()
        |> traverse(acc + r)

      false ->
        [_ | tail] = String.graphemes(content)
        traverse(Enum.join(tail), acc)
    end
  end

  def get_params2(str) do
    IO.puts("#{str}")

    case Regex.run(~r/^(\d+),(\d+)\)/, str) do
      [_, a, b] -> [String.to_integer(a), String.to_integer(b)]
      _ -> []
    end
  end

  def get_params(content) do
    i = Enum.find_index(content, &(&1 == ")"))

    inside_p =
      Enum.slice(content, 0..(i - 1))
      |> Enum.join()
      |> String.split(",")
      |> Enum.map(fn n ->
        try do
          # IO.puts("Trying to parse n:{#{n}}")
          String.to_integer(n)
        rescue
          ArgumentError ->
            # IO.puts("Invalid params")
            nil
        end
      end)

    IO.inspect(inside_p)
    IO.puts("#{Enum.at(inside_p, 0)},#{Enum.at(inside_p, 1)}")

    case inside_p |> Enum.all?(&(&1 != nil)) && length(inside_p) == 2 do
      true -> inside_p
      false -> [0, 0]
    end
  end
end
