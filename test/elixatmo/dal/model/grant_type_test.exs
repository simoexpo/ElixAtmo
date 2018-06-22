defmodule ElixAtmo.Dal.Model.GrantTypeTest do
  use ExUnit.Case
  alias ElixAtmo.Dal.Model.GrantType

  test "GrantType functions should return the correct values" do
    assert GrantType.password() == "password"
    assert GrantType.refresh_token() == "refresh_token"
  end
end
