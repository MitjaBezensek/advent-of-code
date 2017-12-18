defmodule Advent18 do
  def duet(instructions) do
    i = get_instructions(instructions)
    execute_instructions(%{c: 0, i: i, r: %{}, freq: 0, finished: false})
  end

  def execute_instructions(%{finished: true, freq: freq}), do: freq

  def execute_instructions(%{c: current, i: instructions} = state) do
    case find_instruction(current, instructions) do
      {:snd, v} -> execute_snd1({:snd, v}, state)
      {:rcv, v} -> execute_rcv1({:rcv, v}, state)
      a -> execute_instruction(a, state)
    end
    |> execute_instructions
  end

  def duet2(instructions) do
    i = get_instructions(instructions)
    first = find_instruction(0, i)

    state1 = %{c: 0, i: i, r: %{"a" => 1, "b" => 2, "p" => 1}, next: first, queue: [], id: 0}
    state2 = %{c: 0, i: i, r: %{"a" => 1, "b" => 2, "p" => 0}, next: first, queue: [], id: 1}
    run_programs(state1, state2, 0)
  end

  def run_programs(%{next: {:rcv, _}, queue: []}, %{next: {:rcv, _}, queue: []}, count), do: count

  def run_programs(%{next: {:rcv, _}, queue: []} = state1, state2, count) do
    {state1, state2, count} = run(state2, state1, count)
    run_programs(state1, state2, count)
  end

  def run_programs(state1, %{next: {:rcv, _}, queue: []} = state2, count) do
    {state1, state2, _} = run(state1, state2, count)
    run_programs(state1, state2, count)
  end

  def run_programs(state1, state2, count) do
    {state1, state2, count} = run(state1, state2, count)
    run_programs(state1, state2, count)
  end

  def run(a, b, count) do
    case a.next do
      {:snd, v} ->
        execute_snd2(a, b, v, count)

      {:rcv, v} ->
        execute_rcv2(a, b, v, count)

      i ->
        state = execute_instruction(i, a)
        {%{state | next: find_instruction(state.c, state.i)}, b, count}
    end
  end

  def get_instructions(instructions),
    do:
      instructions
      |> Enum.map(&String.split(&1, " ", trim: true))
      |> Enum.map(&parse_instruction/1)
      |> Enum.with_index()

  def parse_instruction([i, r, v]), do: {String.to_atom(i), r, v}
  def parse_instruction([i, r]), do: {String.to_atom(i), r}

  def find_instruction(current, instructions) do
    {instruction, _} = Enum.find(instructions, fn {_, index} -> index == current end)
    instruction
  end

  def execute_instruction({:set, r, v}, state) do
    value = get_value(state.r, v)
    registers = Map.put(state.r, r, value)
    %{state | r: registers, c: state.c + 1}
  end

  def execute_instruction({:mul, r, v}, state), do: execute(r, v, state, &*/2)
  def execute_instruction({:add, r, v}, state), do: execute(r, v, state, &+/2)
  def execute_instruction({:mod, r, v}, state), do: execute(r, v, state, &rem/2)

  def execute_instruction({:jgz, r, v}, state) do
    v1 = get_value(state.r, r)
    v2 = get_value(state.r, v)

    if v1 > 0, do: %{state | c: state.c + v2}, else: %{state | c: state.c + 1}
  end

  def execute_snd1({:snd, r}, state), do: %{state | freq: get_value(state.r, r), c: state.c + 1}

  def execute_snd2(a, b, v, count) do
    count =
      case a.id do
        1 -> count + 1
        0 -> count
      end

    {
      %{b | queue: b.queue ++ [get_value(a.r, v)]},
      %{a | c: a.c + 1, next: find_instruction(a.c + 1, a.i)},
      count
    }
  end

  def execute_rcv1({:rcv, r}, state) do
    v = get_value(state.r, r)

    if v != 0 do
      %{state | finished: true}
    else
      %{state | c: state.c + 1}
    end
  end

  def execute_rcv2(a, b, v, count) do
    [first | rest] = a.queue
    r = Map.put(a.r, v, first)
    {%{a | r: r, c: a.c + 1, queue: rest, next: find_instruction(a.c + 1, a.i)}, b, count}
  end

  def execute(r, v, state, fun) do
    {_, registers} =
      Map.get_and_update(state.r, r, fn value ->
        case value do
          nil ->
            {nil, 0}

          m ->
            {m, fun.(m, get_value(state.r, v))}
        end
      end)

    %{state | r: registers, c: state.c + 1}
  end

  def get_value(r, v) do
    case Integer.parse(v) do
      :error -> Map.fetch!(r, v)
      {n, _} -> n
    end
  end
end

input = File.read!("input18")
input |> String.split("\n", trim: true) |> Advent18.duet() |> IO.inspect()
input |> String.split("\n", trim: true) |> Advent18.duet2() |> IO.inspect()