defmodule ElixAtmo.Model.Token do
  @fields %{
    access_token: :binary,
    expires_in: :integer,
    refresh_token: :binary,
    scope: {:list, :binary}
  }

  use SafeExStruct
end
