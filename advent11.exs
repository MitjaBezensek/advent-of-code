defmodule Advent11 do
    def follow_path(input) do
        moves = 
            input
                |> Enum.group_by(fn v -> v end)
                |> Enum.map(fn {el, list} -> %{String.to_atom(el) => Enum.count(list)} end)
                |> Enum.reduce(%{}, fn (el, acc) -> Enum.into(el, acc) end)
                |> simplify(:n, :s)
                |> simplify(:nw, :se)
                |> simplify(:ne, :sw)
        sum(moves.n, moves.s, moves.se, moves.sw, moves.ne, moves.nw)
    end

    def simplify(map, a, b) do
        n1 = Map.fetch!(map, a)
        n2 = Map.fetch!(map, b)
        min = min(n1, n2)
        Map.merge(map, %{a => n1 - min, b => n2 - min})
    end

    def sum(n, 0, 0, 0, ne, nw), do: n + max(ne, nw)
    def sum(n, 0, se, 0, ne, 0), do: ne + max(n, se)
    def sum(n, 0, 0, sw, 0, nw), do: nw + max(n, sw)
    def sum(n, 0, se, sw, 0, 0), do: abs(n - min(se, sw)) + abs(se - sw)
    def sum(0, s, se, sw, 0, 0), do: s + max(se, sw)
    def sum(0, s, se, 0, ne, 0), do: se + max(s, ne)
    def sum(0, s, 0, sw, 0, nw), do: sw + max(s, nw)
    def sum(0, s, 0, 0, ne, nw), do: abs(s - min(ne, nw)) + abs(ne - nw)

    def follow_path2(input), do:
        Enum.to_list(30..Enum.count(input))
            |> Enum.map(fn length -> Enum.take(input, length) end)
            |> Enum.reduce(%{max_value: 0}, &get_length/2)
            |> Map.fetch!(:max_value)

    def get_length(el, %{max_value: m}), do: %{max_value: max(m, follow_path(el))}
end

input = File.read!("input11") |> String.trim |> String.split(",")
Advent11.follow_path(input) |> IO.inspect
Advent11.follow_path2(input) |> IO.inspect