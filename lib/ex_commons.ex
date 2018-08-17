defmodule ExCommons do
  @doc """
  Transforms module name to key, useful for polymorphism in ecto associations.

  ## Examples

      iex> ExCommons.module_to_key(Some.ModuleName)
      :module_name

      iex> ExCommons.module_to_key("SomeString")
      {:error, %{message: "SomeString is not module name"}}
  """
  def module_to_key(module) when is_atom(module) do
    module |> Module.split() |> List.last() |> Macro.underscore() |> String.to_atom()
  end

  def module_to_key(module),
    do: {:error, %{message: module <> " is not module name"}}

  @doc """
  Deconstructs tuples to return their output, will raise on error
  and on unknown tuples.

  ## Examples

      iex> ExCommons.deconstruct({:ok, "Output"})
      "Output"

      iex> ExCommons.deconstruct({:safe, "Safe"})
      "Safe"

      iex> ExCommons.deconstruct({:error, %{message: "Error"}})
      ** (RuntimeError) Error

      iex> ExCommons.deconstruct({:unknown, nil})
      ** (RuntimeError) Can't handle :unknown.
  """

  def deconstruct({:ok, output}), do: output
  def deconstruct({:safe, output}), do: output
  def deconstruct({:error, error}), do: raise(error[:message])
  def deconstruct({type, _}) when is_atom(type), do: raise("Can't handle :#{type}.")

  @doc """
  Converts nil to any value, defaults to 0.
  Can iterate over lists, and maps, and keyword lists (also handles tuples).
  It will change only values of the enumerable/tuple types.

  ## Examples

     iex> ExCommons.escape_nil(nil)
     0

     iex> ExCommons.escape_nil(nil, "")
     ""

     iex> ExCommons.escape_nil(123)
     123

     iex> ExCommons.escape_nil([1.23, 456, nil])
     [1.23, 456, 0]

     iex> ExCommons.escape_nil([a: "a", b: "b", c: nil], "c")
     [a: "a", b: "b", c: "c"]

     ## Warning: it will reorder the map.
     iex> ExCommons.escape_nil(%{c: nil, a: "a", b: "b"}, "c")
     %{a: "a", b: "b", c: "c"}
  """
  def escape_nil(n, x \\ 0)

  def escape_nil(nil, x), do: x
  def escape_nil({key, nil}, x), do: {key, x}

  def escape_nil(xn, x) when is_list(xn),
    do: Enum.map(xn, &escape_nil(&1, x))

  def escape_nil(xn, x) when is_map(xn),
    do: Enum.map(xn, &escape_nil(&1, x)) |> Enum.into(%{})

  def escape_nil({key, val}, _), do: {key, val}
  def escape_nil(n, _), do: n

  @doc """
  Drops all mime types from a string

  ## Examples

  iex> ExCommons.drop_mimes("file_name.pdf")
  "file_name"

  iex> ExCommons.drop_mimes("file.with.three.mimes")
  "file"
  """
  @spec drop_mimes(String.t()) :: String.t()
  def drop_mimes(str) when is_binary(str) do
    str |> String.split(".") |> Enum.at(0)
  end
end
