defmodule ExCommons.Ecto.Changeset do
  @moduledoc """
  Helpers for Ecto changeset
  """

  @doc """
  Gets changes as a simple map from a changeset
  ## Examples

  iex> ExCommons.Ecto.Changeset.get_changes(%{changes: %{some: :change}, valid?: true})
  %{some: :change}

  iex> changeset = %{changes: %{some: :change, other: %{changes: %{embed_change: true}, valid?: true}}, valid?: true}
  iex> ExCommons.Ecto.Changeset.get_changes(changeset)
  %{some: :change, other: %{embed_change: true}}

  iex> changeset = %{changes: %{root: %{changes: %{one: %{changes: %{two: true}, valid?: true}}, valid?: true}}, valid?: true}
  iex> ExCommons.Ecto.Changeset.get_changes(changeset)
  %{root: %{one: %{two: true}}}

  iex> changeset = %{changes: %{root: [%{changes: %{one: %{changes: %{two: true}, valid?: true}}, valid?: true}]}, valid?: true}
  iex> ExCommons.Ecto.Changeset.get_changes(changeset)
  %{root: [%{one: %{two: true}}]}
  """
  def get_changes(%{valid?: false}) do
    {:error, :invalid_changeset}
  end

  def get_changes(%{changes: changes, valid?: true}) do
    changes
    |> Enum.reduce([], fn {key, change}, acc ->
      [{key, get_changes(change)} | acc]
    end)
    |> Enum.into(%{})
  end

  def get_changes(changeset_list) when is_list(changeset_list) do
    Enum.map(changeset_list, &get_changes/1)
  end

  def get_changes(change) do
    change
  end

  @doc """
  Gets changes errors as a map.
  ## Examples

  iex> ExCommons.Ecto.Changeset.get_errors(%{changes: %{some: :change}, valid?: true})
  %{}

  iex> changeset = %{changes: %{other: %{changes: %{embed_change: true}, valid?: true}}, valid?: false, errors: [must: {"can't be blank", [validation: :required]}]}
  iex> ExCommons.Ecto.Changeset.get_errors(changeset)
  %{must: {"can't be blank", [validation: :required]}}

  iex> changeset = %{changes: %{other: %{changes: %{embed_change: true}, errors: [must: {"can't be blank", [validation: :required]}], valid?: false}}, valid?: false, errors: []}
  iex> ExCommons.Ecto.Changeset.get_errors(changeset)
  %{other: %{must: {"can't be blank", [validation: :required]}}}

  iex> changeset = %{changes: %{other: [%{changes: %{embed_change: true}, errors: [must: {"can't be blank", [validation: :required]}], valid?: false}]}, valid?: false, errors: []}
  iex> ExCommons.Ecto.Changeset.get_errors(changeset)
  %{other: [%{must: {"can't be blank", [validation: :required]}}]}
  """
  def get_errors(%{valid?: true}) do
    %{}
  end

  def get_errors(%{changes: changes, valid?: false, errors: errors}) do
    changes
    |> Enum.reduce(errors, fn {key, change}, acc ->
      empty_map = %{}

      case get_errors(change) do
        ^empty_map -> acc
        errors -> [{key, errors} | acc]
      end
    end)
    |> Enum.into(%{})
  end

  def get_errors(changeset_list) when is_list(changeset_list) do
    Enum.map(changeset_list, &get_errors/1)
  end

  def get_errors(_) do
    %{}
  end
end
