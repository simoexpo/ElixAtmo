defmodule ElixAtmo do
  alias ElixAtmo.Dal.NetatmoDal
  alias ElixAtmo.Model.UserData
  alias ElixAtmo.Model.AppData

  @moduledoc """
  Documentation for ElixAtmo.
  """

  @doc """
  Get access token.

  ## Examples

      iex> ElixAtmo.getAccessToken()
      {:ok, %ElixAtmo.Model.Token{
        access_token: "XXX",
        expires_in: 10800,
        refresh_token: "YYY",
        scope: ["read_station"]
      }}

  """
  def get_access_token(user_data = %UserData{}, app_data = %AppData{}, scopes) do
    NetatmoDal.get_access_token(user_data, app_data, scopes)
  end

  @doc """
  Refresh an access token.

  ## Examples

  #    iex> ElixAtmo.refreshAccessToken(access_token)
  #    {:ok, %ElixAtmo.Model.Token{
  #      access_token: "XXX",
  #      expires_in: 10800,
  #      refresh_token: "YYY",
  #      scope: ["read_station"]
  #    }}

  """
  def refresh_access_token(refresh_token, app_data = %AppData{}) do
    NetatmoDal.refresh_access_token(refresh_token, app_data)
  end

  @doc """
  Retrieve data from weather station.

  ## Examples

  #    iex> ElixAtmo.getWeatherData(access_token)
  #    data

  """
  def get_weather_data(access_token, device_id \\ nil) do
    NetatmoDal.get_weather_data(access_token, device_id)
  end
end
