defmodule ExCommons.DateHelper do
  @doc """
  Converts an Elixir/Ecto date to common EU string format (dd/mm/yyyy).
  Uses string interpolation in order to support more date types.
  """
  def date_to_text(date) do
    "#{date}"
    |> String.split("-")
    |> Enum.reverse()
    |> Enum.join("/")
  end

  @doc """
  Converts an (dd/mm/yyyy) to an Elixir Date
  """
  def text_to_date(date) when is_binary(date) do
    date
    |> String.split("/")
    |> Enum.reverse()
    |> Enum.join("-")
    |> Date.from_iso8601!()
  end
end
