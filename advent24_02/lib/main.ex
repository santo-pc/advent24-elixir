defmodule Main do
  def main(_args \\ []) do
    rows = read_file()
    # solution1(rows)
    solution2(rows)
  end

  def solution2(rows) do
    safes =
      rows
      |> Enum.map(fn row ->
        is_sorted_with_damping(row)
      end)
      |> Enum.filter(fn r -> r == true end)
      |> Enum.count()

    IO.puts("Safes: #{safes}")
  end

  def is_sorted_with_damping(row) do
    IO.puts("first try")

    case is_sorted2(row) do
      {true, _} ->
        IO.puts("true")
        true

      # first try did not work, lets bruteforce it
      {false, _} ->
        row
        |> Enum.with_index()
        |> Enum.map(fn {_, idx} -> remove_from_list(row, idx) end)
        |> Enum.map(fn l -> is_sorted2(l) end)
        |> Enum.any?(fn {r, _} -> r == true end)
    end
  end

  def remove_from_list(row, idx) do
    {left, right} = Enum.split(row, idx)
    left ++ tl(right)
  end

  ## entry to rec.
  def is_sorted2(row) do
    IO.inspect(row)
    order = is_asc(row)
    [a, b | tail] = row
    is_sorted2(a, b, tail, order, 0)
  end

  ## recursive
  def is_sorted2(a, b, tail, order, idx) do
    diff = a - b

    case abs(diff) >= 1 && abs(diff) <= 3 && diff < 0 == order do
      true ->
        case tail do
          [next | tail] -> is_sorted2(b, next, tail, order, idx + 1)
          [] -> {true, 0}
        end

      false ->
        {false, idx}
    end
  end

  def solution1(rows) do
    safes =
      rows
      |> Enum.map(fn row ->
        IO.inspect(row, charlists: false)
        asc = is_asc(row)

        row
        |> is_sorted(asc)
        |> Enum.find(true, fn x -> x == false end)
      end)
      |> Enum.filter(fn r -> r == true end)
      |> Enum.count()

    IO.inspect(safes)
  end

  def is_sorted(nums, order) do
    nums
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] ->
      diff = a - b
      valid = abs(diff) >= 1 && abs(diff) <= 3 && diff < 0 == order
      valid
    end)
  end

  def is_asc(nums) do
    [a, b] =
      nums
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.find(fn [a, b] -> a - b != 0 end)

    a - b < 0
  end

  def read_file() do
    "./lib/input.txt"
    |> File.stream!()
    |> Enum.map(fn line ->
      line
      |> String.trim()
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
