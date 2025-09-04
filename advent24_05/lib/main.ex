defmodule Main do
  def main(_args \\ []) do
    # Solution1.solve("./lib/input.txt")
    Solution2.solve("./lib/input.txt")
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

    fixed_ones =
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
      |> Enum.map(fn wrong_update -> Bubble.fix_update(wrong_update, rules) end)

    fixed_ones
    |> Enum.map(fn update ->
      Enum.at(
        update,
        update |> length() |> div(2)
      )
    end)
    |> Enum.sum()
    |> IO.inspect()
  end

  # base case
  def is_valid([], _) do
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

    if correct do
      is_valid(tail, dict)
    else
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
      nil
    end
  end
end

defmodule Bubble do
  # Public function
  def fix_update(list, rules) do
    # Repeat passes until fully sorted
    do_bubble(list, length(list), rules)
  end

  # Private recursive function: stop when no more passes
  defp do_bubble(list, 0, _rules), do: list

  defp do_bubble(list, n, rules) do
    list
    |> bubble_pass(rules)
    |> do_bubble(n - 1, rules)
  end

  # Private single-pass bubble
  defp bubble_pass([a, b | rest], rules) do
    if should_swap?(a, b, rules) do
      # swap a and b
      [b | bubble_pass([a | rest], rules)]
    else
      [a | bubble_pass([b | rest], rules)]
    end
  end

  # Base case for single-element or empty list
  defp bubble_pass(list, _rules), do: list

  # Example swap function (replace with your rules)
  defp should_swap?(a, b, rules) do
    case rules[b] do
      nil ->
        false

      rules_b ->
        is_b_before_a =
          rules_b
          |> Enum.any?(fn x -> x == a end)

        is_b_before_a
    end
  end
end
