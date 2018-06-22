defmodule ElixAtmo.Dal.Endpoints do
  @host "https://api.netatmo.com"
  @token_endpoint "/oauth2/token"
  @get_weather_data_endpoint "/api/getstationsdata"

  def host, do: @host
  def token, do: "#{host()}#{@token_endpoint}"

  def get_weather_data(access_token, nil),
    do: "#{host()}#{@get_weather_data_endpoint}?access_token=#{access_token}"

  def get_weather_data(access_token, device_id),
    do:
      "#{host()}#{@get_weather_data_endpoint}?access_token=#{access_token}&device_id=#{device_id}"
end
