defmodule Common do
  @doc """
  Transforms module name to key, useful for polymorphism in ecto associations.

  ## Examples

      iex> Common.module_to_key(Some.ModuleName)
      :module_name

      iex> Common.module_to_key("SomeString")
      {:error, %{message: "SomeString is not module name"}}
  """
  def module_to_key(module) when is_atom(module) do
    module
    |> Module.split() |> List.last() |> Macro.underscore() |> String.to_atom()
  end
  def module_to_key(module),
    do: {:error, %{message: IO.inspect(module) <> " is not module name"}}

  @doc """
  Deconstructs tuples to return their output, will raise on error
  and on unknown tuples.

  ## Examples

      iex> Common.deconstruct({:ok, "Output"})
      "Output"

      iex> Common.deconstruct({:safe, "Safe"})
      "Safe"

      iex> Common.deconstruct({:error, %{message: "Error"}})
      ** (RuntimeError) Error

      iex> Common.deconstruct({:unknown, nil})
      ** (RuntimeError) Can't handle :unknown.
  """

  def deconstruct({:ok, output}), do: output
  def deconstruct({:safe, output}), do: output
  def deconstruct({:error, error}), do: raise error[:message]
  def deconstruct({type, _}) when is_atom(type), do: raise "Can't handle :#{type}."
end
