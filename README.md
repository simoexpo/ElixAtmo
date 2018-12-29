# ElixAtmo [![Build Status](https://travis-ci.org/simoexpo/ElixAtmo.svg?branch=master)](https://travis-ci.org/simoexpo/ElixAtmo) [![Coverage Status](https://coveralls.io/repos/github/simoexpo/ElixAtmo/badge.svg?branch=master)](https://coveralls.io/github/simoexpo/ElixAtmo?branch=master) [![codebeat badge](https://codebeat.co/badges/ea970de3-b5ed-4b07-9d62-f4fb31dcb475)](https://codebeat.co/projects/github-com-simoexpo-elixatmo-master)

## What is it?

ElixAtmo is client for the NetAtmo API written in elixir.

## Supported API

* `get_access_token`: to retrieve an access token for a certain user
* `refresh_token`: to refresh an expired access token
* `get_stations_data`: to retrieve the data from a user weather stations
* more to come...

## Examples

##### get_access_token:
```elixir
user_data = %UserData{email: "user@email.com", password: "password"}
app_data = %AppData{app_id: "app_id", client_secret: "secret"}
scopes = [ElixAtmo.Model.TokenScope.read_station()]
{:ok, token} = ElixAtmo.get_access_token(user_data, app_data, scopes)
```

##### refresh_access_token:
```elixir
# token = %ElixAtmo.Model.Token{}
app_data = %AppData{app_id: "app_id", client_secret: "secret"}
{:ok, stations_data} = ElixAtmo.refresh_access_token(token.refresh_token, app_data)
```

##### get_stations_data:
```elixir
# token = %ElixAtmo.Model.Token{}
{:ok, stations_data} = ElixAtmo.get_stations_data(token.access_token)
```

## Installation

```elixir
def deps do
  [
    {:elixatmo, git: "git://github.com/simoexpo/ElixAtmo.git", tag: "v0.2.0"}
  ]
end
```
