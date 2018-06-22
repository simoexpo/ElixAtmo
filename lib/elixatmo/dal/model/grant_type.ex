defmodule ElixAtmo.Dal.Model.GrantType do
  @password :password
  @refresh_token :refresh_token

  def password, do: to_string(@password)
  def refresh_token, do: to_string(@refresh_token)
end
