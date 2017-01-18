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
end
