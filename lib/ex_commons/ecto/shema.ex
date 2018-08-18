defmodule ExCommons.Ecto.Schema do
  @moduledoc """
  Helpers for Ecto
  """

  @bloat [:__meta__, :__struct__, :__cardinality__, :__field__, :__owner__]

  @doc """
  Strips ecto Schemas from meta-information, particularly usefull for calling
  `Poison.encode/1` on resulting map.
  """
  def strip_meta(items), do: ExCommons.Map.strip_keys(items, @bloat)
end
