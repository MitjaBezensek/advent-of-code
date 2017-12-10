defmodule Advent9 do
    def count(input) do
        no_exclamations = 
            input
                |> String.trim
                |> String.replace("!!!!", "")
                |> String.replace("!!", "")
                |> String.replace(~r/!./, "")
                |> String.codepoints

        removed_garbage = no_exclamations |> Enum.reduce(%{garbage_started: false, result: [], garbage_count: 0}, &remove_garbage/2)
        removed_garbage
            |> Map.fetch!(:result)
            |> count_groups
            |> Map.fetch!(:sum)
            |> IO.inspect
        IO.inspect(Map.fetch!(removed_garbage, :garbage_count))
    end

    def remove_garbage("<", %{garbage_started: false} = acc), do: Map.put(acc, :garbage_started, true)
    def remove_garbage(">", acc), do: Map.put(acc, :garbage_started, false)
    def remove_garbage(_, %{garbage_started: true} = acc), do: Map.put(acc, :garbage_count, acc.garbage_count + 1)
    def remove_garbage(el, acc), do: Map.put(acc, :result, acc.result ++ [el])

    def count_groups(list), do: Enum.reduce(list, %{level: 0, sum: 0}, &add_current_element/2)

    def add_current_element("{", acc), do: Map.put(acc, :level, acc.level + 1)
    def add_current_element("}", acc) do
        map = Map.put(acc, :level, acc.level - 1)
        Map.put(map, :sum, acc.sum + acc.level)
    end
    def add_current_element(",", acc), do: acc
end

{:ok, input} = File.read("input9")
input |> Advent9.count