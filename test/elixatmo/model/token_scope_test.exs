defmodule ElixAtmo.Model.TokenScopeTest do
  use ExUnit.Case
  alias ElixAtmo.Model.TokenScope

  test "TokenScope functions should return the correct values" do
    assert TokenScope.access_camera() == "access_camera"
    assert TokenScope.access_presence() == "access_presence"
    assert TokenScope.read_camera() == "read_camera"
    assert TokenScope.read_homecoach() == "read_homecoach"
    assert TokenScope.read_presence() == "read_presence"
    assert TokenScope.read_station() == "read_station"
    assert TokenScope.read_thermostat() == "read_thermostat"
    assert TokenScope.write_camera() == "write_camera"
    assert TokenScope.write_thermostat() == "write_thermostat"
  end
end
