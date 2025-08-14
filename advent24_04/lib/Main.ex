defmodule Pos do
  defstruct col: 0, row: 0
end

defmodule Main do
  def main(_args \\ []) do
    solution1()
  end

  def solution1() do
    r =
      "./lib/input-test.txt"
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

    # IO.inspect(ri)

    result =
      ri
      |> findXmas(ri, 0)

    IO.puts("Solution1: #{result}")
  end

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
        {x - 1, y + 1}

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

  def findXmas(_, [], acc) do
    IO.puts("end")
    acc
  end

  def findXmas(mat, tail, acc) do
    case tail do
      [{x, y, "X"} | rest] ->
        # IO.inspect(tail)
        IO.puts("found X")
        found = expand(mat, {x, y})
        findXmas(mat, rest, acc + found)

      [_head | rest] ->
        # IO.inspect(head)
        findXmas(mat, rest, acc)

      [] ->
        acc
    end
  end

  def expand(mat, {x, y}) do
    [:right, :left, :down, :up, :leftup, :rightup, :rightdown, :leftdown]
    |> Enum.map(fn dir -> util(mat, {x, y}, "X", dir) end)
    |> Enum.sum()
  end

  def util(mat, {x, y}, progress, dir) when progress in ["X", "XM", "XMA"] do
    case get_item(mat, {x, y}, dir) do
      {new_x, new_y, item} ->
        IO.puts("{#{x}, #{y}}=#{item}")
        util(mat, {new_x, new_y}, progress <> item, dir)

      _ ->
        0
    end
  end

  def util(_mat, {_x, _y}, "XMAS", _dir) do
    1
  end

  def util(_mat, {_x, _y}, _, _dir) do
    0
  end
end
