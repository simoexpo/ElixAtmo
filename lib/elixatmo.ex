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

      iex> user_data = %UserData{email: "user@email.com", password: "password"}
      iex> app_data = %AppData{app_id: "app_id", client_secret: "secret"}
      iex> scopes = [ElixAtmo.Model.TokenScope.read_station()]
      iex> ElixAtmo.get_access_token(user_data, app_data, scopes)
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

      iex> app_data = %AppData{app_id: "app_id", client_secret: "secret"}
      iex> refresh_token = "refresh_token"
      iex> ElixAtmo.refresh_access_token(access_token, app_data)
      {:ok, %ElixAtmo.Model.Token{
        access_token: "XXX",
        expires_in: 10800,
        refresh_token: "YYY",
        scope: ["read_station"]
      }}

  """
  def refresh_access_token(refresh_token, app_data = %AppData{}) do
    NetatmoDal.refresh_access_token(refresh_token, app_data)
  end

  @doc """
  Retrieve data from weather station.

  ## Examples

      iex> ElixAtmo.get_stations_data(access_token)
      {:ok, %{
        #json data
      }}

  """
  def get_stations_data(access_token, device_id \\ nil) do
    NetatmoDal.get_stations_data(access_token, device_id)
  end
end
