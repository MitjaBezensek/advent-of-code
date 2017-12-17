defmodule Advent16 do
  def dance_more(moves) do
    dance_more(1, moves, "abcdefghijklmnop", %{})
  end

  def dance_more(count, moves, programs, dances) do
    new_order = dance(moves, programs)

    case Map.fetch(dances, new_order) do
      {:ok, _} ->
        dance_index = rem(1_000_000_000, count - 1)

        {result, _} =
          dances
          |> Enum.find(fn {_, val} -> val == dance_index end)

        result

      _ ->
        dances = Map.put(dances, new_order, count)
        dance_more(count + 1, moves, new_order, dances)
    end
  end

  def dance(moves), do: dance(moves, "abcdefghijklmnop")

  def dance(moves, programs) do
    programs =
      programs
      |> String.split("", trim: true)
      |> Enum.with_index()

    moves
    |> String.split(",", trim: true)
    |> Enum.map(&parse_move/1)
    |> Enum.reduce(programs, &perform_move/2)
    |> Enum.sort(fn {_, i1}, {_, i2} -> i1 < i2 end)
    |> Enum.map(fn {p, _} -> p end)
    |> Enum.join()
  end

  def parse_move("s" <> number), do: %{spin: String.to_integer(number)}

  def parse_move("x" <> rest) do
    [first, second] = String.split(rest, "/")
    %{change_by_index: %{first: String.to_integer(first), second: String.to_integer(second)}}
  end

  def parse_move("p" <> rest) do
    [first, second] = String.split(rest, "/")
    %{change: %{first: first, second: second}}
  end

  def perform_move(%{spin: number}, programs) do
    programs
    |> Enum.map(&spin_program(&1, number, Enum.count(programs)))
  end

  def perform_move(%{change_by_index: %{first: f, second: s}}, programs) do
    first = {p1, _} = get_element_by_index(f, programs)
    second = {p2, _} = get_element_by_index(s, programs)
    programs = List.delete(programs, first)
    programs = List.delete(programs, second)
    programs ++ [{p1, s}, {p2, f}]
  end

  def perform_move(%{change: %{first: f, second: s}}, programs) do
    first = {_, i1} = get_element(f, programs)
    second = {_, i2} = get_element(s, programs)
    programs = List.delete(programs, first)
    programs = List.delete(programs, second)
    programs ++ [{f, i2}, {s, i1}]
  end

  def spin_program({n, index}, number, length) do
    spin_position = length - number

    case spin_position > index do
      true -> {n, index + number}
      false -> {n, index - spin_position}
    end
  end

  def get_element_by_index(index, programs), do: Enum.find(programs, fn {_, i} -> i == index end)
  def get_element(el, programs), do: Enum.find(programs, fn {e, _} -> e == el end)
end

input = File.read!("input16") |> String.trim()
Advent16.dance(input) |> IO.inspect()
Advent16.dance_more(input) |> IO.inspect()