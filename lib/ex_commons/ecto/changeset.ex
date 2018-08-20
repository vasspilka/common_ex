defmodule ExCommons.Ecto.Changeset do
  @moduledoc """
  Helpers for Ecto changeset
  """

  @doc """
  Gets changes as a simple map from a changeset
  ## Examples

  iex> ExCommons.Ecto.Changeset.get_changes(%{changes: %{some: :change}})
  %{some: :change}

  iex> changeset = %{changes: %{some: :change, other: %{changes: %{embed_change: true}}}}
  iex> ExCommons.Ecto.Changeset.get_changes(changeset)
  %{some: :change, other: %{embed_change: true}}

  iex> changeset = %{changes: %{root: %{changes: %{one: %{changes: %{two: true}}}}}}
  iex> ExCommons.Ecto.Changeset.get_changes(changeset)
  %{root: %{one: %{two: true}}}
  """
  def get_changes(%{changes: changes}) do
    changes
    |> Enum.reduce([], fn {key, change}, acc ->
      [{key, get_changes(change)} | acc]
    end)
    |> Enum.into(%{})
  end

  def get_changes(change) do
    change
  end
end
