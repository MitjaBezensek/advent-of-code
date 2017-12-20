defmodule Advent20 do
  def part1(input) do
    {_, index, _} =
      get_particle_info(input)
      |> Enum.reduce({0, 0, 10000}, &find_smallest_acc/2)

    index
  end

  def find_smallest_acc([_, _, acc], {count, min_index, min_acc}) do
    current_acc = get_particle_acc(acc)

    if current_acc < min_acc do
      {count + 1, count, current_acc}
    else
      {count + 1, min_index, min_acc}
    end
  end

  def part2(input),
    do:
      get_particle_info(input)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {p, i}, map -> Map.put(map, i, p) end)
      |> recurse

  def recurse(particles) do
    moved_particles = Enum.map(particles, &simulate_move/1)
    colided = Enum.flat_map(moved_particles, &get_collisions(&1, moved_particles))
    not_colided = Enum.reject(moved_particles, fn p -> Enum.member?(colided, p) end)

    if finished?(not_colided) do
      Enum.count(not_colided)
    else
      recurse(not_colided)
    end
  end

  def simulate_move({i, [[x, y, z], [vx, vy, vz], [ax, ay, az] = acc]}) do
    [new_vx, new_vy, new_vz] = new_v = [vx + ax, vy + ay, vz + az]
    new_position = [x + new_vx, y + new_vy, z + new_vz]
    {i, [new_position, new_v, acc]}
  end

  def get_collisions(particle, particles) do
    same_pos =
      particles
      |> Enum.filter(&have_same_pos?(&1, particle))

    case same_pos do
      [] -> []
      a -> [particle | a]
    end
  end

  def have_same_pos?({i1, [[x, y, z], _, _]}, {i2, [[x, y, z], _, _]}) when i1 != i2, do: true
  def have_same_pos?(_, _), do: false

  def finished?(particles) do
    can_any_stil_turn =
      particles
      |> Enum.map(fn {_, [_, [vx, vy, vz], [ax, ay, az]]} -> vx * ax + vy * ay + vz * az end)
      |> Enum.any?(&(&1 < 0))

    can_any_come_back =
      particles
      |> Enum.map(fn {_, [[x, y, z], [vx, vy, vz], _]} -> x * vx + y * vy + z * vz end)
      |> Enum.any?(&(&1 < 0))

    if can_any_stil_turn || can_any_come_back do
      false
    else
      [{_, acc} | rest] =
        particles
        |> Enum.map(&get_distance_and_acc/1)
        |> Enum.sort(fn {d1, _}, {d2, _} -> d1 > d2 end)

      Enum.reduce(rest, {acc, true}, &acc_are_descending/2)
    end
  end

  def acc_are_descending({_, acc}, {prev_acc, _}) when acc > prev_acc, do: {prev_acc, false}
  def acc_are_descending(_, {prev_acc, a}), do: {prev_acc, a}

  def get_particle_info(input), do: Enum.map(input, &parse_row/1)

  def parse_row(row),
    do:
      row
      |> String.replace(~r/[vap>]/, "")
      |> String.replace("=<", "")
      |> String.split(", ", trim: true)
      |> Enum.map(&to_integers/1)

  def to_integers(row),
    do:
      String.split(row, ",")
      |> Enum.map(&String.to_integer/1)

  def get_particle_acc([ax, ay, az]), do: abs(ax) + abs(ay) + abs(az)
  def get_distance_and_acc({_, [[x, y, z], _, acc]}), do: {x + y + z, get_particle_acc(acc)}
end

File.read!("input20") |> String.split("\n", trim: true) |> Advent20.part1() |> IO.inspect()
File.read!("input20") |> String.split("\n", trim: true) |> Advent20.part2() |> IO.inspect()