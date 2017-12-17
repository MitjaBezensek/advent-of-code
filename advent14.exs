defmodule Advent14 do
  def count_used_squares(input), do: input |> Enum.reduce(0, &count_ones/2)

  def get_groups(input) do
    present_nodes =
      input
      |> Enum.with_index()
      |> Enum.filter(fn {x, _} -> x != "0" end)

    indexes = present_nodes |> Enum.map(fn {_, index} -> index end)

    connections =
      indexes
      |> Enum.map(&build_connections(&1, indexes))
      |> Enum.reduce(%{}, fn {index, neighbors}, map -> Map.put(map, index, neighbors) end)

    Advent12.count_groups(0, Map.keys(connections), connections)
    |> IO.inspect()
  end

  def build_connections(index, indexes), do: {index, get_neighbors(index, indexes)}

  def get_neighbors(index, indexes) do
    row = div(index, 128)
    column = rem(index, 128)
    left = get_left(row, column, index)
    right = get_right(row, column, index)
    above = index - 128
    below = index + 128

    [left, right, above, below] |> Enum.filter(fn el -> Enum.member?(indexes, el) end)
  end

  def get_left(row, 0, index), do: -1
  def get_left(_, _, index), do: index - 1
  def get_right(row, 127, index), do: -1
  def get_right(_, _, index), do: index + 1

  def get_disk_state(input) do
    0..127
    |> Enum.to_list()
    |> Enum.map(fn el -> Advent10.process2("#{input}-#{el}") end)
    |> Enum.join()
    |> String.codepoints()
    |> Enum.map(&convert_hex_to_binary/1)
    |> Enum.join()
    |> String.codepoints()
  end

  def convert_hex_to_binary(number) do
    number
    |> Integer.parse(16)
    |> Tuple.to_list()
    |> List.first()
    |> Integer.to_string(2)
    |> String.pad_leading(4, "0000")
  end

  def count_ones("1", state), do: state + 1
  def count_ones(_, state), do: state
end

defmodule Advent12 do
  def count_groups(n, [], _), do: n

  def count_groups(n, list, connections) do
    [node | _] = list
    group = find_connected_nodes(connections, [node], [])
    count_groups(n + 1, list -- group, connections)
  end

  def find_connected_nodes(_, [], result), do: result

  def find_connected_nodes(connections, [first | rest], result) do
    result = List.flatten([first, result])

    case Map.fetch(connections, first) do
      {:ok, value} ->
        conn = value |> Enum.filter(fn el -> !Enum.member?(result, el) end)
        find_connected_nodes(connections, Enum.uniq(rest ++ conn), result)

      _ ->
        find_connected_nodes(connections, rest, result)
    end
  end
end

defmodule Advent10 do
  require Bitwise

  def process2(input) do
    lengths =
      input
      |> to_charlist
      |> Enum.concat([17, 31, 73, 47, 23])

    Enum.reduce(1..64, starting_state(), fn _, state -> run_once(lengths, state) end).list
    |> Enum.chunk_every(16)
    |> Enum.map(fn chunk -> Enum.reduce(chunk, 0, &Bitwise.bxor/2) end)
    |> Enum.map(&Integer.to_string(&1, 16))
    |> Enum.map(&String.pad_leading(&1, 2, "0"))
    |> Enum.map(&String.downcase/1)
    |> Enum.join()
    |> IO.inspect()
  end

  def run_once(lengths, state), do: Enum.reduce(lengths, state, &hash/2)

  def starting_state do
    list = Enum.to_list(0..255)
    %{list: list, position: 0, skip: 0, length: Enum.count(list)}
  end

  def hash(length, state) do
    half = round(length / 2)
    list = swap(state.list, state.position, half, length)

    %{
      state
      | list: list,
        position: rem(state.position + length + state.skip, state.length),
        skip: state.skip + 1
    }
  end

  def swap(list, _, 0, _), do: list

  def swap(list, position, remaining, length) do
    num_elements = Enum.count(list)
    first_el_pos = rem(position, num_elements)
    second_el_pos = rem(position + length - 1, num_elements)
    el1 = Enum.at(list, first_el_pos)
    el2 = Enum.at(list, second_el_pos)
    list = List.update_at(list, first_el_pos, fn _ -> el2 end)
    list = List.update_at(list, second_el_pos, fn _ -> el1 end)
    swap(list, position + 1, remaining - 1, length - 2)
  end
end

input = "uugsqrei"
# Run this once to generate a file with disk contents since the Day 10 solution is slow
#   input
#   |> Advent14.get_disk_state()
# # output = File.write(input, output)
File.read!(input)
|> String.codepoints()
|> Advent14.count_used_squares()
|> IO.inspect()

File.read!(input)
|> String.replace("\n", "")
|> String.codepoints()
|> Advent14.get_groups()