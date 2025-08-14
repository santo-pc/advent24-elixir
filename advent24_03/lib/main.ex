defmodule Main do
  def main(_args \\ []) do
    solution1("./lib/input.txt")
    solution2("./lib/input.txt")
  end

  def solution2(file) do
    result =
      File.read!(file)
      |> traverse2(0, 1)

    {fun, _} = __ENV__.function
    IO.inspect("#{fun} Result: #{result}")
  end

  def get_params2(str) do
    reg = Regex.run(~r/^(\d{1,3}),(\d{1,3})\)/, str)

    case reg do
      [_, a, b] ->
        rest = String.slice(str, 4..-1//1)
        nums = [String.to_integer(a), String.to_integer(b)]
        {Enum.reduce(nums, &*/2), rest}

      _ ->
        {0, str}
    end
  end

  # do()
  def traverse2("do()" <> rest, acc, _enable) do
    traverse2(rest, acc, 1)
  end

  # don't()
  def traverse2("don't()" <> rest, acc, _enable) do
    traverse2(rest, acc, 0)
  end

  # mul(...)
  def traverse2("mul(" <> rest, acc, 1) do
    {r, remaining} = get_params2(rest)
    traverse2(remaining, acc + r, 1)
  end

  # fallback case — shift by one character
  def traverse2(<<_::binary-size(1), tail::binary>>, acc, enable) do
    traverse2(tail, acc, enable)
  end

  # base case — no content left
  def traverse2("", acc, _enable), do: acc

  def solution1(file) do
    result =
      file
      |> File.stream!()
      |> Enum.map(fn content ->
        traverse(content, 0)
      end)
      |> Enum.sum()

    {fun, _} = __ENV__.function
    IO.inspect("#{fun} Result: #{result}")
  end

  # empty string → stop
  def traverse("", acc) do
    acc
  end

  def traverse(content, acc) do
    case String.starts_with?(content, "mul(") do
      true ->
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

  def get_params(content) do
    i = Enum.find_index(content, &(&1 == ")"))

    inside_p =
      Enum.slice(content, 0..(i - 1))
      |> Enum.join()
      |> String.split(",")
      |> Enum.map(fn n ->
        try do
          String.to_integer(n)
        rescue
          ArgumentError ->
            nil
        end
      end)

    case inside_p |> Enum.all?(&(&1 != nil)) && length(inside_p) == 2 do
      true -> inside_p
      false -> [0, 0]
    end
  end
end
