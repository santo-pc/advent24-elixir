defmodule Main do
  def main(_args \\ []) do
    # Solution1.solve("./lib/input.txt")
    Solution2.solve("./lib/input-test.txt")
  end
end

defmodule Solution2 do
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

    rules =
      rules
      |> Enum.map(fn list -> Enum.map(list, &String.to_integer/1) end)
      |> Enum.group_by(fn [k, _v] -> k end, fn [_k, v] -> v end)
      |> IO.inspect()

    invalids =
      updates
      |> IO.inspect()
      |> Enum.reject(&Enum.any?(&1, fn i -> i == "" end))
      |> List.flatten()
      |> Enum.map(fn line ->
        line
        |> String.split(",")
        |> Enum.map(&String.to_integer(&1))
      end)
      |> Enum.filter(&(is_valid(&1, rules) == nil))

    IO.puts("These are the invalids")
    IO.inspect(invalids)

    invalids
    |> Enum.map(fn wrong_update -> fix_update(wrong_update, rules) end)
    |> IO.inspect()
    |> Enum.map(fn update ->
      Enum.at(
        update,
        update |> length() |> div(2)
      )
      |> IO.inspect()
    end)
    |> Enum.sum()
    |> IO.inspect()
  end

  def fix_update(update, rules) do
    {new_list, _} =
      update
      |> Enum.reduce({[], nil}, fn current, {acc, prev} ->
        if prev != nil && should_swap?(prev, current, rules) do
          # swap previous and current
          # replace last element of acc with current, then prepend prev
          acc =
            acc
            |> List.replace_at(length(acc) - 1, current)
            # ensures acc is always a list
            |> List.wrap()

          {[prev | acc], current}
        else
          {[current | acc], current}
        end
      end)

    IO.puts("New list")
    Enum.reverse(new_list) |> IO.inspect()
  end

  def should_swap?(a, b, rules) do
    case rules[b] do
      nil ->
        true

      rules_b ->
        rules_b
        |> Enum.any?(fn x -> x == a end)
    end
  end

  def swap(list, i, j) do
    vi = Enum.at(list, i)
    vj = Enum.at(list, j)

    list
    |> List.replace_at(i, vj)
    |> List.replace_at(j, vi)
  end

  # base case
  def is_valid([], _) do
    IO.puts("end ")
    true
  end

  # check
  def is_valid(tail, dict) do
    [current | tail] = tail

    # try to find one rule that challenges current before all tail items
    correct =
      tail
      |> Enum.all?(fn item ->
        case dict[item] do
          nil -> true
          rules_item -> not Enum.member?(rules_item, current)
        end
      end)

    IO.puts(
      "Current #{inspect(current, pretty: true, charlists: :as_lists)} vs #{inspect(tail, pretty: true, charlists: :as_lists)}: valid?: #{inspect(correct, pretty: true, charlists: :as_lists)}"
    )

    if correct do
      is_valid(tail, dict)
    else
      IO.puts("end- false")
      nil
    end
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

    dict =
      rules
      |> Enum.map(fn list -> Enum.map(list, &String.to_integer/1) end)
      |> Enum.group_by(fn [k, _v] -> k end, fn [_k, v] -> v end)
      |> IO.inspect()

    updates
    |> IO.inspect()
    |> Enum.reject(&Enum.any?(&1, fn i -> i == "" end))
    |> List.flatten()
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer(&1))
    end)
    |> Enum.map(fn update ->
      case is_valid(update, dict) do
        true -> Enum.at(update, update |> length() |> div(2))
        nil -> nil
      end
    end)
    |> Enum.reject(&is_nil(&1))
    |> Enum.sum()
    |> IO.inspect()
  end

  # base case
  def is_valid([], _) do
    IO.puts("end ")
    true
  end

  # check 
  def is_valid(tail, dict) do
    [current | tail] = tail

    # try to find one rule that challenges current before all tail items
    correct =
      tail
      |> Enum.all?(fn item ->
        case dict[item] do
          nil -> true
          rules_item -> not Enum.member?(rules_item, current)
        end
      end)

    IO.puts(
      "Current #{inspect(current, pretty: true, charlists: :as_lists)} vs #{inspect(tail, pretty: true, charlists: :as_lists)}: valid?: #{inspect(correct, pretty: true, charlists: :as_lists)}"
    )

    if correct do
      is_valid(tail, dict)
    else
      IO.puts("end- false")
      nil
    end
  end
end
