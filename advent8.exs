defmodule Advent8 do
  def calculate(rows) do
    registers =
      rows
      |> Enum.map(&parse_command/1)
      |> Enum.reduce(%{max: 0}, &apply_command/2)

    IO.inspect("Part 2")
    IO.inspect(get_register_value(registers, "max"))
    registers = Map.delete(registers, "max")
    IO.inspect("Part 1")
    IO.inspect(registers |> Map.values() |> Enum.max())
  end

  def parse_command(row) do
    [command, condition] = String.split(row, "if")

    %{
      command: get_command(command, &get_inc_or_dec/1),
      condition: get_command(condition, &get_operation/1)
    }
  end

  def get_command(command, operation_finder) do
    [register, command, value] = command |> String.trim() |> String.split(" ")

    %{
      register: register,
      command: operation_finder.(command),
      value: String.to_integer(value)
    }
  end

  def get_inc_or_dec("inc"), do: &Kernel.+/2
  def get_inc_or_dec("dec"), do: &Kernel.-/2
  def get_operation("<"), do: &Kernel.</2
  def get_operation("<="), do: &Kernel.<=/2
  def get_operation(">"), do: &Kernel.>/2
  def get_operation(">="), do: &Kernel.>=/2
  def get_operation("=="), do: &Kernel.==/2
  def get_operation("!="), do: &Kernel.!=/2

  def apply_command(command, registers) do
    current_value = get_register_value(registers, command.condition.register)

    if command.condition.command.(current_value, command.condition.value) do
      value = get_register_value(registers, command.command.register)
      new_value = command.command.command.(value, command.command.value)
      registers = Map.put(registers, command.command.register, new_value)
      max = get_register_value(registers, "max")

      if new_value > max do
        Map.put(registers, "max", new_value)
      else
        registers
      end
    else
      registers
    end
  end

  def get_register_value(registers, register) do
    case Map.fetch(registers, register) do
      {:ok, value} -> value
      :error -> 0
    end
  end
end

{:ok, input} = File.read("input8")
input |> String.trim() |> String.split("\n") |> Advent8.calculate()
