defmodule ElixAtmo.Model.AppData do
  @fields %{
    app_id: :binary,
    client_secret: :binary
  }

  use SafeExStruct
end
