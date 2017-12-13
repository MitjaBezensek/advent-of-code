defmodule Advent4 do
  def number_of_valid_passes(passes, reject_fun),
    do:
      passes
      |> Enum.reject(reject_fun)
      |> Enum.count()

  def has_duplicates?(row) do
    words =
      row
      |> String.split(" ")

    Enum.count(words) != Enum.count(Enum.uniq(words))
  end

  def has_anagrams?(row) do
    words =
      row
      |> String.split(" ")
      |> Enum.map(&String.codepoints/1)
      |> Enum.map(&Enum.sort/1)

    Enum.count(words) != Enum.count(Enum.uniq(words))
  end
end

{:ok, input} = File.read("input4")

input
|> String.trim()
|> String.split("\n")
|> Advent4.number_of_valid_passes(&Advent4.has_duplicates?/1)
|> IO.inspect()

input
|> String.trim()
|> String.split("\n")
|> Advent4.number_of_valid_passes(&Advent4.has_anagrams?/1)
|> IO.inspect()
