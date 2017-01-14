defmodule Common.DateHelperTest do
  use ExUnit.Case

  alias Common.DateHelper

  test "date_to_text: successfully converted" do
    assert DateHelper.date_to_text(~D(2000-01-02)) == "02/01/2000"
  end

  test "text_to_date: successfully converted" do
    assert DateHelper.text_to_date("02/01/2000") == ~D(2000-01-02)
  end
end
