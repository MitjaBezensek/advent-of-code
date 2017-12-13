defmodule Advent3 do
  def generate(lastNum, next_element_fn),
    do: generate({1, 0, 0}, %{{0, 0} => 1}, 0, 0, 0, 0, lastNum, "right", next_element_fn)

  def generate({num, x, y}, _, _, _, _, _, lastNum, _, _) when num >= lastNum do
    IO.inspect(abs(x) + abs(y))
    IO.inspect(num)
  end

  def generate({num, x, y}, map, top, right, bottom, left, lastNum, "right", next_element_fn) do
    nextValue = next_element_fn.({num, x + 1, y}, map)
    nextElement = {nextValue, x + 1, y}
    map = Map.put(map, {x + 1, y}, nextValue)

    if x + 1 > right do
      generate(nextElement, map, top, right + 1, bottom, left, lastNum, "up", next_element_fn)
    else
      generate(nextElement, map, top, right, bottom, left, lastNum, "right", next_element_fn)
    end
  end

  def generate({num, x, y}, map, top, right, bottom, left, lastNum, "up", next_element_fn) do
    nextValue = next_element_fn.({num, x, y + 1}, map)
    nextElement = {nextValue, x, y + 1}
    map = Map.put(map, {x, y + 1}, nextValue)

    if y + 1 > top do
      generate(nextElement, map, top + 1, right, bottom, left, lastNum, "left", next_element_fn)
    else
      generate(nextElement, map, top, right, bottom, left, lastNum, "up", next_element_fn)
    end
  end

  def generate({num, x, y}, map, top, right, bottom, left, lastNum, "left", next_element_fn) do
    nextValue = next_element_fn.({num, x - 1, y}, map)
    nextElement = {nextValue, x - 1, y}
    map = Map.put(map, {x - 1, y}, nextValue)

    if x - 1 < left do
      generate(nextElement, map, top, right, bottom, left - 1, lastNum, "down", next_element_fn)
    else
      generate(nextElement, map, top, right, bottom, left, lastNum, "left", next_element_fn)
    end
  end

  def generate({num, x, y}, map, top, right, bottom, left, lastNum, "down", next_element_fn) do
    nextValue = next_element_fn.({num, x, y - 1}, map)
    nextElement = {nextValue, x, y - 1}
    map = Map.put(map, {x, y - 1}, nextValue)

    if y - 1 < bottom do
      generate(nextElement, map, top, right, bottom - 1, left, lastNum, "right", next_element_fn)
    else
      generate(nextElement, map, top, right, bottom, left, lastNum, "down", next_element_fn)
    end
  end

  def part1_next_element({num, _, _}, _), do: num + 1

  def part2_next_element({num, x, y}, map) do
    Enum.sum(
      for x_offset <- -1..1,
          y_offset <- -1..1,
          {:ok, value} <- [Map.fetch(map, {x + x_offset, y + y_offset})] do
        value
      end
    )
  end
end

Advent3.generate(368_078, &Advent3.part1_next_element/2)
Advent3.generate(368_078, &Advent3.part2_next_element/2)
