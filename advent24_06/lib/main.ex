defmodule Main do
  def main(_args) do
    map =
      File.stream!("./lib/input.txt")
      |> Enum.with_index(fn line, y ->
        String.trim(line)
        |> String.to_charlist()
        |> Enum.with_index(fn char, x ->
          %{{x, y} => char}
        end)
      end)
      |> List.flatten()
      |> Enum.reduce(fn map, acc ->
        Map.merge(acc, map)
      end)

    initial_pos =
      map
      |> Enum.find(fn {_key, value} -> value == ?^ end)
      |> IO.inspect()

    result = nav(elem(initial_pos, 0), char_to_dir(elem(initial_pos, 1)), map)

    IO.inspect(result)
    IO.puts("Result size: ")
    IO.inspect(MapSet.size(result))
  end

  def char_to_dir(char) do
    case char do
      ?^ -> :up
      ?> -> :right
      ?v -> :down
      ?< -> :left
      _ -> :error
    end
  end

  def rotate_dir(dir) do
    case dir do
      :up -> :right
      :right -> :down
      :down -> :left
      :left -> :up
      _ -> :error
    end
  end

  def nav(pos, dir, map) do
    nav(pos, dir, map, MapSet.new() |> MapSet.put(pos))
  end

  def nav(nil, _dir, _map, result) do
    result
  end

  def nav(pos, dir, map, result) do
    IO.inspect(pos)

    next_pos = cal_next_pos(pos, dir)
    next = map[next_pos]

    case next do
      ?# ->
        IO.inspect("colission #{rotate_dir(dir)}")
        nav(pos, rotate_dir(dir), map, result)

      nil ->
        MapSet.put(result, pos)

      _ ->
        nav(next_pos, dir, map, MapSet.put(result, pos))
    end
  end

  def cal_next_pos({x, y}, dir) do
    case dir do
      :up ->
        {x, y - 1}

      :down ->
        {x, y + 1}

      :left ->
        {x - 1, y}

      :right ->
        {x + 1, y}

      _ ->
        {x, y}
    end
  end
end
