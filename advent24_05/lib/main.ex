defmodule Main do
  def main(_args \\ []) do
    Solution1.solve("./lib/input-test.txt")
  end
end

defmodule Solution1 do
  def solve(input) do
    {rules, updates} =
      input
      |> File.stream!()
      |> Enum.map(fn line ->
        line
        |> String.trim()
        |> String.split("|")
      end)
      |> Enum.split_while(fn line -> length(line) == 2 end)
      |> IO.inspect()

    left =
      rules
      |> Enum.map(fn list -> Enum.map(list, &String.to_integer/1) end)
      |> Enum.group_by(fn [k, _v] -> k end, fn [_k, v] -> v end)
      |> IO.inspect()

    right =
      rules
      |> Enum.map(fn list -> Enum.map(list, &String.to_integer/1) end)
      |> Enum.group_by(fn [_k, v] -> v end, fn [k, _v] -> k end)
      |> IO.inspect()

    updates
    |> Enum.reject(&Enum.any?(&1, fn i -> i == "" end))
    |> List.flatten()
    |> Enum.map(fn line ->
      line
      |> IO.inspect()
      |> String.split(",")
      |> IO.inspect()
      |> Enum.map(&String.to_integer(&1))
    end)
    # |> IO.inspect()
    |> Enum.map(fn update ->
      is_correct(update, left, right)
    end)
    |> Enum.reject(&is_nil(&1))
    |> Enum.filter(&(&1 == true))
    |> Enum.sum()
    |> IO.inspect()
  end

  def is_correct(update, left, right) do
    is_correct(update, left, right, update)
  end

  def is_correct(update, left, right, update) do
    test([], update, left, right, update)
  end

  def test(_head, [], _left, _right, update) do
    IO.puts("end")
    Enum.at(update, update |> length() |> div(2))
  end

  def test(head, tail, left, right, update) do
    [current | tail] = tail
    IO.puts("-")
    IO.inspect(head, charlists: :as_list)
    IO.inspect(current, charlists: :as_list)
    IO.inspect(tail, charlists: :as_list)

    correct_right =
      case left[current] do
        nil ->
          IO.puts("not in map (left) #{current}")
          true

        afters ->
          tail
          |> Enum.all?(fn x -> x in afters end)
      end

    correct_left =
      case right[current] do
        nil ->
          IO.puts("not in map (right) #{current}")
          true

        befores ->
          head
          |> Enum.all?(fn x -> x in befores end)
      end

    if correct_right && correct_left do
      test([current | head], tail, left, right, update)
    else
      nil
    end
  end
end
