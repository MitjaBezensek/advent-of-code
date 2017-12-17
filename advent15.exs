defmodule Advent15 do
  require Bitwise
  def judge(a, b, div_a, div_b, total), do: judge(a, b, div_a, div_b, 0, total)
  def judge(_, _, _, _, count, 0), do: count

  def judge(a, b, div_a, div_b, count, total) do
    a = generate(a, 16807, div_a)
    b = generate(b, 48271, div_b)
    lowest_16_a = Bitwise.band(a, 0xFFFF)
    lowest_16_b = Bitwise.band(b, 0xFFFF)

    count =
      case lowest_16_a == lowest_16_b do
        true -> count + 1
        false -> count
      end

    judge(a, b, div_a, div_b, count, total - 1)
  end

  def generate(n, m, d) do
    new_n = rem(n * m, 2_147_483_647)

    if rem(new_n, d) == 0 do
      new_n
    else
      generate(new_n, m, d)
    end
  end
end

a = 634
b = 301
Advent15.judge(a, b, 1, 1, 40_000_000) |> IO.inspect()
Advent15.judge(a, b, 4, 8, 5_000_000) |> IO.inspect()