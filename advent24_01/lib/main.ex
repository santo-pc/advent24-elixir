defmodule Main do
  def main(_args \\ []) do
    solution1()
    solution2()
  end

  def solution1() do
    {list1, list2} =
      "./lib/input.txt"
      |> File.stream!()
      |> Enum.map(fn line ->
        [a, b] =
          line
          |> String.trim()
          |> String.split()
          |> Enum.map(&String.to_integer/1)

        {a, b}
      end)
      |> Enum.unzip()

    list1 = Enum.sort(list1)
    list2 = Enum.sort(list2)

    result =
      Enum.zip(list1, list2)
      |> Enum.map(fn {a, b} -> abs(a - b) end)
      |> Enum.sum()

    {fun, _} = __ENV__.function
    IO.inspect("#{fun} Result: #{result}")
  end

  def solution2() do
    {list1, list2} =
      "./lib/input.txt"
      |> File.stream!()
      |> Enum.map(fn line ->
        [a, b] =
          line
          |> String.trim()
          |> String.split()
          |> Enum.map(&String.to_integer/1)

        {a, b}
      end)
      |> Enum.unzip()

    freq = Enum.frequencies(list2)

    result =
      list1
      |> Enum.map(fn n -> n * Map.get(freq, n, 0) end)
      |> Enum.sum()

    {fun, _} = __ENV__.function
    IO.inspect("#{fun} Result: #{result}")
  end
end
