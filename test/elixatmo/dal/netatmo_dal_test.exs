defmodule ElixAtmo.Dal.NetatmoDalTest do
  use ExUnit.Case, async: false
  import Mock

  alias ElixAtmo.Dal.NetatmoDal
  alias ElixAtmo.Dal.Endpoints
  alias ElixAtmo.Dal.Model.GrantType
  alias ElixAtmo.Model.UserData
  alias ElixAtmo.Model.AppData
  alias ElixAtmo.Model.Token

  setup do
    bypass = Bypass.open()
    mocked_host = endpoint_url(bypass.port)
    {:ok, bypass: bypass, mocked_host: mocked_host}
  end

  defp endpoint_url(port), do: "http://localhost:#{port}"

  test "get_access_token should call netatmo and retrieve an access token", %{
    bypass: bypass,
    mocked_host: mocked_host
  } do
    endpoint = "/oauth2/token"
    scopes = ["scope_1", "scope_2"]
    user_data = %UserData{email: "simoexpo@email.com", password: "password"}
    app_data = %AppData{app_id: "id", client_secret: "secret"}

    expected_request = %{
      "grant_type" => GrantType.password(),
      "client_id" => "id",
      "client_secret" => "secret",
      "username" => "simoexpo@email.com",
      "password" => "password",
      "scope" => Enum.join(scopes, " ")
    }

    expected_response =
      Poison.encode!(%{
        "access_token" => "access_token",
        "expires_in" => 1000,
        "refresh_token" => "refresh_token",
        "scope" => scopes
      })

    expected_token = %Token{
      access_token: "access_token",
      expires_in: 1000,
      refresh_token: "refresh_token",
      scope: scopes
    }

    Bypass.expect_once(bypass, "POST", endpoint, fn conn ->
      {:ok, body, _} = Plug.Conn.read_body(conn)
      assert URI.decode_query(body) == expected_request
      Plug.Conn.resp(conn, 200, expected_response)
    end)

    with_mock Endpoints, token: fn -> "#{mocked_host}#{endpoint}" end do
      {:ok, token} = NetatmoDal.get_access_token(user_data, app_data, scopes)
      assert token == expected_token
    end
  end

  test "get_access_token should return :error if netatmo call doesn't reply as expected", %{
    bypass: bypass,
    mocked_host: mocked_host
  } do
    endpoint = "/oauth2/token"
    scopes = ["scope_1", "scope_2"]
    user_data = %UserData{email: "simoexpo@email.com", password: "password"}
    app_data = %AppData{app_id: "id", client_secret: "secret"}

    expected_request = %{
      "grant_type" => GrantType.password(),
      "client_id" => "id",
      "client_secret" => "secret",
      "username" => "simoexpo@email.com",
      "password" => "password",
      "scope" => Enum.join(scopes, " ")
    }

    Bypass.expect_once(bypass, "POST", endpoint, fn conn ->
      {:ok, body, _} = Plug.Conn.read_body(conn)
      assert URI.decode_query(body) == expected_request
      Plug.Conn.resp(conn, 500, "")
    end)

    with_mock Endpoints, token: fn -> "#{mocked_host}#{endpoint}" end do
      assert :error == NetatmoDal.get_access_token(user_data, app_data, scopes)
    end
  end

  test "get_access_token return :error if netatmo call fail" do
    endpoint = Endpoints.token()
    scopes = ["scope_1", "scope_2"]
    user_data = %UserData{email: "simoexpo@email.com", password: "password"}
    app_data = %AppData{app_id: "id", client_secret: "secret"}

    expected_request =
      {:form,
       [
         grant_type: GrantType.password(),
         client_id: "id",
         client_secret: "secret",
         username: "simoexpo@email.com",
         password: "password",
         scope: Enum.join(scopes, " ")
       ]}

    with_mock HTTPoison,
      post: fn ^endpoint, ^expected_request ->
        {:error, %HTTPoison.Error{reason: "error"}}
      end do
      assert :error == NetatmoDal.get_access_token(user_data, app_data, scopes)
    end
  end

  test "refresh_access_token should call netatmo and refresh a token", %{
    bypass: bypass,
    mocked_host: mocked_host
  } do
    endpoint = "/oauth2/token"
    refresh_token = "refresh_token"
    app_data = %AppData{app_id: "id", client_secret: "secret"}
    scopes = ["scope_1", "scope_2"]

    expected_request = %{
      "grant_type" => GrantType.refresh_token(),
      "client_id" => "id",
      "client_secret" => "secret",
      "refresh_token" => refresh_token
    }

    expected_response =
      Poison.encode!(%{
        "access_token" => "access_token",
        "expires_in" => 1000,
        "refresh_token" => "refresh_token",
        "scope" => scopes
      })

    expected_token = %Token{
      access_token: "access_token",
      expires_in: 1000,
      refresh_token: "refresh_token",
      scope: scopes
    }

    Bypass.expect_once(bypass, "POST", endpoint, fn conn ->
      {:ok, body, _} = Plug.Conn.read_body(conn)
      assert URI.decode_query(body) == expected_request
      Plug.Conn.resp(conn, 200, expected_response)
    end)

    with_mock Endpoints, token: fn -> "#{mocked_host}#{endpoint}" end do
      {:ok, token} = NetatmoDal.refresh_access_token(refresh_token, app_data)
      assert token == expected_token
    end
  end

  test "refresh_access_token should return :error if netatmo call doesn't reply as expected", %{
    bypass: bypass,
    mocked_host: mocked_host
  } do
    endpoint = "/oauth2/token"
    refresh_token = "refresh_token"
    app_data = %AppData{app_id: "id", client_secret: "secret"}

    expected_request = %{
      "grant_type" => GrantType.refresh_token(),
      "client_id" => "id",
      "client_secret" => "secret",
      "refresh_token" => refresh_token
    }

    Bypass.expect_once(bypass, "POST", endpoint, fn conn ->
      {:ok, body, _} = Plug.Conn.read_body(conn)
      assert URI.decode_query(body) == expected_request
      Plug.Conn.resp(conn, 500, "")
    end)

    with_mock Endpoints, token: fn -> "#{mocked_host}#{endpoint}" end do
      assert :error == NetatmoDal.refresh_access_token(refresh_token, app_data)
    end
  end

  test "refresh_access_token return :error if netatmo call fail" do
    endpoint = Endpoints.token()
    refresh_token = "refresh_token"
    app_data = %AppData{app_id: "id", client_secret: "secret"}

    expected_request =
      {:form,
       [
         grant_type: GrantType.refresh_token(),
         refresh_token: refresh_token,
         client_id: "id",
         client_secret: "secret"
       ]}

    with_mock HTTPoison,
      post: fn ^endpoint, ^expected_request ->
        {:error, %HTTPoison.Error{reason: "error"}}
      end do
      assert :error == NetatmoDal.refresh_access_token(refresh_token, app_data)
    end
  end

  test "get_weather_data should call netatmo and retrieve data from weather station", %{
    bypass: bypass,
    mocked_host: mocked_host
  } do
    endpoint = "/api/getstationsdata"
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

    Bypass.expect_once(bypass, "GET", endpoint, fn conn ->
      query_param =
        conn
        |> Plug.Conn.fetch_query_params()
        |> Map.get(:query_params)
        |> Map.get("access_token")

      assert query_param == access_token
      Plug.Conn.resp(conn, 200, Poison.encode!(expected_stations_data))
    end)

    with_mock Endpoints,
      get_stations_data: fn ^access_token, nil ->
        "#{mocked_host}#{endpoint}?access_token=#{access_token}"
      end do
      {:ok, weather_data} = NetatmoDal.get_stations_data(access_token, nil)
      assert weather_data == expected_stations_data
    end
  end

  test "get_weather_data return :error if netatmo call doesn't reply as expected", %{
    bypass: bypass,
    mocked_host: mocked_host
  } do
    endpoint = "/api/getstationsdata"
    access_token = "access_token"

    Bypass.expect_once(bypass, "GET", endpoint, fn conn ->
      query_param =
        conn
        |> Plug.Conn.fetch_query_params()
        |> Map.get(:query_params)
        |> Map.get("access_token")

      assert query_param == access_token
      Plug.Conn.resp(conn, 500, "")
    end)

    with_mock Endpoints,
      get_stations_data: fn ^access_token, nil ->
        "#{mocked_host}#{endpoint}?access_token=#{access_token}"
      end do
      assert :error == NetatmoDal.get_stations_data(access_token, nil)
    end
  end

  test "get_weather_data return :error if netatmo call fail" do
    access_token = "access_token"
    endpoint = Endpoints.get_stations_data(access_token, nil)

    with_mock HTTPoison,
      get: fn ^endpoint ->
        {:error, %HTTPoison.Error{reason: "error"}}
      end do
      assert :error == NetatmoDal.get_stations_data(access_token, nil)
    end
  end
end
