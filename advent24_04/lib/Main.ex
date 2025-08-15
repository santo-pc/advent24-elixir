defmodule Main do
  def main(_args \\ []) do
    # Solution1.solve()
    Solution2.solve()
  end
end

defmodule Solution2 do
  def solve() do
    flat_dict =
      "./lib/input.txt"
      |> File.stream!()
      |> Enum.map(fn line ->
        line
        |> String.trim()
        |> String.graphemes()
      end)
      |> Enum.with_index()
      |> Enum.map(fn {list, idx} ->
        list
        |> Enum.with_index()
        |> Enum.map(fn {item, inner_idx} ->
          {idx, inner_idx, item}
        end)
      end)
      |> List.flatten()

    result =
      flat_dict
      |> find_x(flat_dict, 0)

    IO.puts("Solution 2: #{result}")
  end

  def find_x(_mat, [], acc) do
    acc
  end

  def find_x(mat, [{x, y, "A"} | tail], acc) do
    acc = if is_x_mas(mat, {x, y}), do: acc + 1, else: acc
    find_x(mat, tail, acc)
  end

  def find_x(mat, [_ | tail], acc) do
    find_x(mat, tail, acc)
  end

  def is_x_mas(mat, {x, y}) do
    [:diagleft, :diagright]
    |> Enum.all?(fn dir ->
      line = get_line(mat, {x, y}, dir)

      if Enum.any?(line, &is_nil/1) do
        false
      else
        word = line |> Enum.map(&elem(&1, 2)) |> Enum.join()
        word in ["MAS", "SAM"]
      end
    end)
  end

  def get_line(mat, pos, :hor) do
    [
      Util.get_item(mat, Util.new_pos(pos, :left)),
      Util.get_item(mat, pos),
      Util.get_item(mat, Util.new_pos(pos, :right))
    ]
  end

  def get_line(mat, pos, :ver) do
    [
      Util.get_item(mat, Util.new_pos(pos, :up)),
      Util.get_item(mat, pos),
      Util.get_item(mat, Util.new_pos(pos, :down))
    ]
  end

  def get_line(mat, pos, :diagleft) do
    [
      Util.get_item(mat, Util.new_pos(pos, :leftup)),
      Util.get_item(mat, pos),
      Util.get_item(mat, Util.new_pos(pos, :rightdown))
    ]
  end

  def get_line(mat, pos, :diagright) do
    [
      Util.get_item(mat, Util.new_pos(pos, :rightup)),
      Util.get_item(mat, pos),
      Util.get_item(mat, Util.new_pos(pos, :leftdown))
    ]
  end
end

defmodule Util do
  def new_pos({x, y}, dir) do
    case dir do
      :right ->
        {x + 1, y}

      :left ->
        {x - 1, y}

      :down ->
        {x, y + 1}

      :up ->
        {x, y - 1}

      :leftup ->
        {x - 1, y - 1}

      :rightup ->
        {x + 1, y - 1}

      :rightdown ->
        {x + 1, y + 1}

      :leftdown ->
        {x - 1, y + 1}
    end
  end

  def get_item(mat, {col, row}, dir) do
    get_item(mat, new_pos({col, row}, dir))
  end

  def get_item(mat, {col, row}) do
    mat
    |> Enum.find(fn {x, y, _} -> x == col && y == row end)
  end
end

defmodule Solution1 do
  def solve() do
    r =
      "./lib/input.txt"
      |> File.stream!()
      |> Enum.map(fn line ->
        line
        |> String.trim()
        |> String.graphemes()
      end)

    ri =
      Enum.with_index(r)
      |> Enum.map(fn {list, idx} ->
        list
        |> Enum.with_index()
        |> Enum.map(fn {item, inner_idx} ->
          {idx, inner_idx, item}
        end)
      end)
      |> List.flatten()

    result =
      ri
      |> find_x_mas(ri, 0)

    IO.puts("Solution 1: #{result}")
  end

  def find_x_mas(_, [], acc) do
    acc
  end

  def find_x_mas(mat, tail, acc) do
    case tail do
      [{x, y, "X"} | rest] ->
        found = expand(mat, {x, y})
        find_x_mas(mat, rest, acc + found)

      [_head | rest] ->
        find_x_mas(mat, rest, acc)

      [] ->
        acc
    end
  end

  def expand(mat, {x, y}) do
    [:right, :left, :down, :up, :leftup, :rightup, :rightdown, :leftdown]
    |> Enum.map(fn dir -> expand(mat, {x, y}, "X", dir) end)
    |> Enum.sum()
  end

  def expand(mat, {x, y}, progress, dir) when progress in ["X", "XM", "XMA"] do
    case Util.get_item(mat, {x, y}, dir) do
      {new_x, new_y, item} ->
        expand(mat, {new_x, new_y}, progress <> item, dir)

      _ ->
        0
    end
  end

  def expand(_mat, {_x, _y}, "XMAS", _dir) do
    1
  end

  def expand(_mat, {_x, _y}, _, _dir) do
    0
  end
end
