defmodule ExCommons.Map do
  @moduledoc """
  Helpers for Maps and Structs.
  """

  @exceptions [NaiveDateTime, DateTime]

  @doc """
  Strips selected keys from maps, that can be in a list, or and embedded within.
  Will not strip keys from NaiveDateTime, and DateTime, unless given directly.

  ## Examples

  iex> ExCommons.Map.strip_keys(%{}, [])
  %{}

  iex> ExCommons.Map.strip_keys([%{key: :val}], [:key])
  [%{}]

  iex> ExCommons.Map.strip_keys(%{embed: %{layered: %{key: :val}}}, [:key])
  %{embed: %{layered: %{}}}
  """
  @spec strip_keys(Map.t | [Map.t], [Atom.t]) :: Map.t | [Map.t]
  def strip_keys(list, keys) when is_list(list) do
    Enum.map(list, &strip_keys(&1, keys))
  end

  def strip_keys(map, keys) when is_map(map) do
    Map.take(map, Map.keys(map) -- keys) |> Enum.map(&strip_keys(&1, keys)) |> Enum.into(%{})
  end

  def strip_keys({key, %{__struct__: struct} = val}, _keys)
  when struct in @exceptions,
    do: {key, val}

  def strip_keys({key, val}, keys)
  when is_map(val) or is_list(val),
    do: {key, strip_keys(val, keys)}

  def strip_keys(data, _keys), do: data
end
