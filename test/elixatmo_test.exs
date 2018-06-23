defmodule ElixAtmoTest do
  use ExUnit.Case, async: false
  import Mock
  alias ElixAtmo.Dal.NetatmoDal
  alias ElixAtmo.Model.UserData
  alias ElixAtmo.Model.AppData
  alias ElixAtmo.Model.Token

  test "get_access_token should retrieve an access token" do
    user_data = %UserData{email: "simoexpo@email.com", password: "password"}
    app_data = %AppData{app_id: "id", client_secret: "secret"}
    scopes = ["scope_1", "scope_2"]

    expected_token = %Token{
      access_token: "access_token",
      expires_in: 1000,
      refresh_token: "refresh_token",
      scope: scopes
    }

    with_mock NetatmoDal,
      get_access_token: fn ^user_data, ^app_data, ^scopes ->
        {:ok, expected_token}
      end do
      {:ok, token} = ElixAtmo.get_access_token(user_data, app_data, scopes)
      assert token == expected_token
      assert called(NetatmoDal.get_access_token(user_data, app_data, scopes))
    end
  end

  test "get_access_token should return :error if the netatmo dal return an error" do
    user_data = %UserData{email: "simoexpo@email.com", password: "password"}
    app_data = %AppData{app_id: "id", client_secret: "secret"}
    scopes = ["scope_1", "scope_2"]

    with_mock NetatmoDal,
      get_access_token: fn ^user_data, ^app_data, ^scopes ->
        :error
      end do
      assert :error == ElixAtmo.get_access_token(user_data, app_data, scopes)
      assert called(NetatmoDal.get_access_token(user_data, app_data, scopes))
    end
  end

  test "refresh_access_token should refresh the access token" do
    refresh_token = "refresh_token"
    app_data = %AppData{app_id: "id", client_secret: "secret"}

    expected_token = %Token{
      access_token: "access_token",
      expires_in: 1000,
      refresh_token: "refresh_token",
      scope: ["scope_1", "scope_2"]
    }

    with_mock NetatmoDal,
      refresh_access_token: fn ^refresh_token, ^app_data ->
        {:ok, expected_token}
      end do
      {:ok, token} = ElixAtmo.refresh_access_token(refresh_token, app_data)
      assert token == expected_token
      assert called(NetatmoDal.refresh_access_token(refresh_token, app_data))
    end
  end

  test "refresh_access_token should return :error if the netatmo dal return an error" do
    refresh_token = "refresh_token"
    app_data = %AppData{app_id: "id", client_secret: "secret"}

    with_mock NetatmoDal,
      refresh_access_token: fn ^refresh_token, ^app_data ->
        :error
      end do
      :error = ElixAtmo.refresh_access_token(refresh_token, app_data)
      assert called(NetatmoDal.refresh_access_token(refresh_token, app_data))
    end
  end

  test "get_weather_data should call netatmo and retrieve data from weather station" do
    access_token = "access_token"

    expected_stations_data = %{
      "body" => %{
        "devices" => [
          %{
            "_id" => "XX:XX:XX:XX:XX:XX",
            "cipher_id" => "cipher_id",
            "date_setup" => 1_514_559_334,
            "last_setup" => 1_514_559_334,
            "type" => "NAMain",
            "last_status_store" => 1_529_619_234,
            "module_name" => "module_name",
            "firmware" => 135,
            "last_upgrade" => 1_514_559_337,
            "wifi_status" => 22,
            "co2_calibrating" => false,
            "station_name" => "station_name",
            "data_type" => [
              "Temperature",
              "CO2",
              "Humidity",
              "Noise",
              "Pressure"
            ],
            "place" => %{
              "altitude" => 833,
              "city" => "city",
              "country" => "IT",
              "timezone" => "Europe/Rome",
              "location" => [
                9.1900328466799,
                45.464199306884
              ]
            },
            "dashboard_data" => %{
              "time_utc" => 1_529_619_215,
              "Temperature" => 24.1,
              "CO2" => 561,
              "Humidity" => 58,
              "Noise" => 35,
              "Pressure" => 1023.3,
              "AbsolutePressure" => 926.2,
              "min_temp" => 24.1,
              "max_temp" => 24.2,
              "date_min_temp" => 1_529_619_215,
              "date_max_temp" => 1_529_618_612,
              "temp_trend" => "stable",
              "pressure_trend" => "down"
            },
            "modules" => [
              %{
                "_id" => "XX:XX:XX:XX:XX:XX",
                "type" => "NAModule1",
                "module_name" => "module_name",
                "data_type" => [
                  "Temperature",
                  "Humidity"
                ],
                "last_setup" => 1_514_559_418,
                "dashboard_data" => %{
                  "time_utc" => 1_529_619_188,
                  "Temperature" => 15.7,
                  "Humidity" => 75,
                  "min_temp" => 15.7,
                  "max_temp" => 16,
                  "date_min_temp" => 1_529_619_188,
                  "date_max_temp" => 1_529_618_573,
                  "temp_trend" => "down"
                },
                "firmware" => 46,
                "last_message" => 1_529_619_227,
                "last_seen" => 1_529_619_188,
                "rf_status" => 79,
                "battery_vp" => 5648,
                "battery_percent" => 85
              }
            ]
          }
        ],
        "user" => %{
          "mail" => "user@mail.com",
          "administrative" => %{
            "lang" => "it-IT",
            "reg_locale" => "it-IT",
            "country" => "IT_IT",
            "unit" => 0,
            "windunit" => 0,
            "pressureunit" => 0,
            "feel_like_algo" => 0
          }
        }
      },
      "status" => "ok",
      "time_exec" => 0.064925909042358,
      "time_server" => 1_529_619_830
    }

    with_mock ElixAtmo.Dal.NetatmoDal,
      get_stations_data: fn ^access_token, nil ->
        {:ok, expected_stations_data}
      end do
      {:ok, stations_data} = ElixAtmo.get_stations_data(access_token)
      assert stations_data == expected_stations_data
      assert called(ElixAtmo.Dal.NetatmoDal.get_stations_data(access_token, nil))
    end
  end

  test "get_weather_data return :error if netatmo call doesn't reply as expected" do
    access_token = "access_token"

    with_mock ElixAtmo.Dal.NetatmoDal,
      get_stations_data: fn ^access_token, nil ->
        :error
      end do
      assert :error = ElixAtmo.get_stations_data(access_token)
      assert called(ElixAtmo.Dal.NetatmoDal.get_stations_data(access_token, nil))
    end
  end
end
