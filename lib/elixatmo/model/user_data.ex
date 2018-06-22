defmodule ElixAtmo.Model.UserData do
  @fields %{
    email: :binary,
    password: :binary
  }

  use SafeExStruct
end
