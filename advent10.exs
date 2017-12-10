defmodule Advent10 do
    import Bitwise
    def process1(input) do
        lengths = input |> String.split(",") |> Enum.map(fn el -> String.to_integer(el) end)
        result = run_once(lengths, starting_state()).list
        IO.inspect(Enum.at(result, 0) * Enum.at(result, 1)) 
    end

    def process2(input) do
        lengths = 
            input 
            |> to_charlist
            |> Enum.concat([17, 31, 73, 47, 23])

        Enum.reduce(1..64, starting_state(), fn (_, state) -> run_once(lengths, state) end).list
            |> Enum.chunk_every(16)
            |> Enum.map(fn chunk -> Enum.reduce(chunk, 0, &Bitwise.bxor/2) end)
            |> Enum.map(&Integer.to_string(&1, 16))
            |> Enum.map(&String.pad_leading(&1, 2, "0"))
            |> Enum.map(&String.downcase/1)
            |> Enum.join()
            |> IO.inspect
    end 

    def run_once(lengths, state), do: Enum.reduce(lengths, state, &hash/2)

    def starting_state do
        list = Enum.to_list(0..255)
        %{list: list, position: 0, skip: 0, length: Enum.count(list)}
    end

    def hash(length, state) do
        half = round(length / 2)
        list = swap(state.list, state.position, half, length) 
        %{state |
            list: list,
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

{:ok, input} = File.read("input10")
input |> String.trim() |> Advent10.process1
input |> String.trim() |> Advent10.process2