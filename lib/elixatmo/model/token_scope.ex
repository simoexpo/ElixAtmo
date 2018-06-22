defmodule ElixAtmo.Model.TokenScope do
  @read_station :read_station
  @read_thermostat :read_thermostat
  @write_thermostat :write_thermostat
  @read_camera :read_camera
  @write_camera :write_camera
  @access_camera :access_camera
  @read_presence :read_presence
  @access_presence :access_presence
  @read_homecoach :read_homecoach

  def read_station, do: to_string(@read_station)
  def read_thermostat, do: to_string(@read_thermostat)
  def write_thermostat, do: to_string(@write_thermostat)
  def read_camera, do: to_string(@read_camera)
  def write_camera, do: to_string(@write_camera)
  def access_camera, do: to_string(@access_camera)
  def read_presence, do: to_string(@read_presence)
  def access_presence, do: to_string(@access_presence)
  def read_homecoach, do: to_string(@read_homecoach)
end
