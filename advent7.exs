defmodule Advent7 do
  def get_weights(rows) do
    tree = build_tree(rows)
    investigate_unbalanced(find_root(tree), tree)
  end

  def get_root(rows), do: rows |> build_tree |> find_root

  def build_tree(rows), do: Enum.map(rows, &parse_element/1)

  def parse_element(row) do
    [head | children_string] = String.split(row, "->")
    head_and_weight = String.split(head, " ") |> Enum.map(&String.trim/1)
    children = get_children(children_string)

    %{
      node: Enum.at(head_and_weight, 0),
      weight: get_weight(head_and_weight),
      children: children
    }
  end

  def get_children([]), do: []

  def get_children(children_string) do
    children_string
    |> Enum.at(0)
    |> String.trim()
    |> String.split(",")
    |> Enum.map(fn c -> String.replace(c, " ", "") end)
  end

  def get_weight(head_and_weight) do
    head_and_weight
    |> Enum.at(1)
    |> String.replace("(", "")
    |> String.replace(")", "")
    |> String.to_integer()
  end

  def find_root(elements) do
    all_elements = elements |> Enum.map(fn el -> el.node end)
    child_elements = elements |> Enum.map(fn el -> el.children end) |> List.flatten()
    (all_elements -- child_elements) |> List.first()
  end

  def investigate_unbalanced(element, tree) do
    el = find_element(element, tree)
    children_weights = get_children_weights(el.children, tree)
    zipped = Enum.zip(children_weights, el.children)
    groupped = Enum.group_by(zipped, fn {value, _} -> value end)

    if Enum.count(groupped) > 1 do
      unbalanced_element =
        groupped
        |> Enum.reject(fn {_, value} -> Enum.count(value) > 1 end)
        |> List.first()

      {_, [{_, unbalanced}]} = unbalanced_element
      investigate_unbalanced(unbalanced, tree)
    else
      parent =
        tree
        |> Enum.filter(fn el -> Enum.member?(el.children, element) end)
        |> List.first()

      other_nodes_weight =
        get_children_weights(parent.children, tree)
        |> Enum.reject(fn w -> w == el.weight end)
        |> List.first()

      IO.inspect(el.weight - (get_element_weight(el.node, tree) - other_nodes_weight))
    end
  end

  def find_element(el, tree), do: Enum.filter(tree, fn e -> e.node == el end) |> List.first()

  def get_children_weights([], _), do: [0]

  def get_children_weights(children, tree) do
    children
    |> Enum.map(fn e -> get_element_weight(e, tree) end)
  end

  def get_element_weight(element, tree) do
    el = find_element(element, tree)
    el.weight + Enum.reduce(get_children_weights(el.children, tree), 0, &(&1 + &2))
  end
end

{:ok, input} = File.read("input7")
input |> String.trim() |> String.split("\n") |> Advent7.get_root() |> IO.inspect()
input |> String.trim() |> String.split("\n") |> Advent7.get_weights()
