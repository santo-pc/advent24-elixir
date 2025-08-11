defmodule Main do
  def main(_args \\ []) do
    solution1("./lib/input-test.txt")
    |> IO.inspect()
  end

  def solution1(file) do
    file
    |> File.stream!()
    |> Enum.map(fn content ->
      traverse(content)
    end)
  end

  # empty string → stop
  def traverse(""), do: :ok

  def traverse(content) do
    IO.puts("Actual: #{content}")

    case String.starts_with?(content, "mul") do
      true ->
        IO.puts("found MUL!")

        String.graphemes(content)
        |> Enum.slice(3..-1//1)
        |> Enum.join()
        |> traverse()

      false ->
        [_ | tail] = String.graphemes(content)
        traverse(Enum.join(tail))
    end
  end

  def get_params(content) do
    IO.puts(content)
    {true, 1, 1}
  end
end
