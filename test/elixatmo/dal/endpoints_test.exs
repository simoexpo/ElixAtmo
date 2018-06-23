defmodule ElixAtmo.Dal.EndpointsTest do
  use ExUnit.Case
  alias ElixAtmo.Dal.Endpoints

  test "Endpoints functions should return the correct values" do
    assert Endpoints.host() == "https://api.netatmo.com"
    assert Endpoints.token() == "https://api.netatmo.com/oauth2/token"

    access_token = "access_token"
    device_id = "device_id"

    assert Endpoints.get_stations_data(access_token, nil) ==
             "https://api.netatmo.com/api/getstationsdata?access_token=#{access_token}"

    assert Endpoints.get_stations_data(access_token, device_id) ==
             "https://api.netatmo.com/api/getstationsdata?access_token=#{access_token}&device_id=#{
               device_id
             }"
  end
end
