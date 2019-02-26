defmodule VerySafeVeryShort.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Redix, name: :redix},
      {Plug.Cowboy, scheme: :http, plug: VerySafeVeryShort.Router, options: [port: 4025]},
      {VerySafeVeryShort.Cache, []}
    ]

    opts = [strategy: :one_for_one, name: VerySafeVeryShort.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
