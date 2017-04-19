defmodule Common.Ecto do

  @moduledoc """
  Helpers for Ecto
  """

  @exceptions [NaiveDateTime, DateTime]
  @bloat [:__meta__, :__struct__, :__cardinality__, :__field__, :__owner__]

  @doc """
  Strips ecto Schemas from meta-information, particularly usefull for calling
  `Poison.encode/1` on resulting map.
  """
  def strip_meta(list)   when is_list(list), do: Enum.map(list, &strip_meta/1)
  def strip_meta(schema) when is_map(schema) do
    Map.take(schema, Map.keys(schema) -- @bloat)
    |> Enum.map(&strip_meta/1) |> Enum.into(%{})
  end
  def strip_meta({key, %{__struct__: struct} = val})
    when struct in @exceptions, do: {key, val}
  def strip_meta({key, val}) when is_map(val), do: {key, strip_meta(val)}
  def strip_meta(data), do: data
end
 
