defmodule Advent9 do
    def count(input) do
        no_exclamations = 
            input
                |> String.trim
                |> String.replace("!!!!", "")
                |> String.replace("!!", "")
                |> String.replace(~r/!./, "")
                |> String.codepoints
        no_exclamations
            |> Enum.reduce(%{started: false, result: []}, &remove_garbage/2)
            |> Map.fetch!(:result)
            |> count_groups
            |> Map.fetch!(:sum)
            |> IO.inspect
        
        no_exclamations
            |> Enum.reduce(%{started: false, result: 0}, &count_garbage/2)
            |> Map.fetch!(:result)
            |> IO.inspect
    end

    def remove_garbage("<", acc), do: Map.put(acc, :started, true)
    def remove_garbage(">", acc), do: Map.put(acc, :started, false)
    def remove_garbage(el, %{started: true} = acc), do: acc
    def remove_garbage(el, acc), do: Map.put(acc, :result, acc.result ++ [el])

    def count_groups(list), do: Enum.reduce(list, %{level: 0, sum: 0}, &add_current_element/2)

    def add_current_element("{", acc), do: Map.put(acc, :level, acc.level + 1)
    def add_current_element("}", acc) do
        map = Map.put(acc, :level, acc.level - 1)
        Map.put(map, :sum, acc.sum + acc.level)
    end
    def add_current_element(",", acc), do: acc

    def count_garbage("<", %{started: false} = acc), do: Map.put(acc, :started, true)
    def count_garbage("<", %{started: true} = acc), do: Map.put(acc, :result, acc.result + 1)
    def count_garbage(">", acc), do: Map.put(acc, :started, false)
    def count_garbage(_, %{started: true} = acc), do: Map.put(acc, :result, acc.result + 1)
    def count_garbage(_, acc), do: acc 
end

{:ok, input} = File.read("input9")
input |> Advent9.count