defmodule Advent17 do
  def spinlock(step), do: spinlock(step, [], 0, 0)

  def spinlock(_step, buffer, _pos, 2018),
    do: Enum.drop_while(buffer, fn el -> el != 2017 end) |> Enum.at(1)

  def spinlock(step, buffer, pos, count) do
    next_pos =
      case count do
        0 -> 1
        _ -> rem(step + pos, count)
      end

    buffer = List.insert_at(buffer, next_pos + 1, count)
    spinlock(step, buffer, next_pos + 1, count + 1)
  end

  def spinlock2(step), do: spinlock2(step, 0, 0, 0)
  def spinlock2(_, _, 50_000_001, result), do: result

  def spinlock2(step, pos, count, result) do
    next_pos =
      case count do
        0 -> 1
        _ -> rem(step + pos, count)
      end

    result =
      case next_pos do
        0 -> count
        _ -> result
      end

    spinlock2(step, next_pos + 1, count + 1, result)
  end
end

Advent17.spinlock(312) |> IO.inspect()
Advent17.spinlock2(312) |> IO.inspect()