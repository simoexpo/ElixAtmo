defmodule ElixAtmo.Dal.NetatmoDal do
  require Logger

  alias ElixAtmo.Dal.Model.GrantType
  alias ElixAtmo.Dal.Endpoints
  alias ElixAtmo.Model.Token
  alias ElixAtmo.Model.UserData
  alias ElixAtmo.Model.AppData

  def get_access_token(
        %UserData{email: email, password: password},
        %AppData{app_id: app_id, client_secret: client_secret},
        scopes
      ) do
    scopes_field = Enum.join(scopes, " ")

    body =
      {:form,
       [
         grant_type: GrantType.password(),
         client_id: app_id,
         client_secret: client_secret,
         username: email,
         password: password,
         scope: scopes_field
       ]}

    case HTTPoison.post(Endpoints.token(), body) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Jason.decode!()
        |> Token.create(ignore_unknown_fields: true, allow_string_keys: true)

      {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
        Logger.error("Error while getting access token: status code #{code}, body #{body}")
        :error

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("Unexpected error while getting access token: #{inspect(reason)}")
        :error
    end
  end

  def refresh_access_token(refresh_token, %AppData{app_id: app_id, client_secret: client_secret}) do
    body =
      {:form,
       [
         grant_type: GrantType.refresh_token(),
         refresh_token: refresh_token,
         client_id: app_id,
         client_secret: client_secret
       ]}

    case HTTPoison.post(Endpoints.token(), body) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Jason.decode!()
        |> Token.create(ignore_unknown_fields: true, allow_string_keys: true)

      {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
        Logger.error("Error while refreshing access token: status code #{code}, body #{body}")
        :error

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("Unexpected error while refreshing access token: #{inspect(reason)}")
        :error
    end
  end

  def get_stations_data(access_token, device_id) do
    url = Endpoints.get_stations_data(access_token, device_id)

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Jason.decode()

      {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
        Logger.error("Error while getting weather info: status code #{code}, body #{body}")
        :error

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("Unexpected error while getting weather info: #{inspect(reason)}")
        :error
    end
  end
end
