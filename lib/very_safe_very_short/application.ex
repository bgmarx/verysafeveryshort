defmodule VerySafeVeryShort.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {Redix, name: :redix},
      {Plug.Cowboy, scheme: :http, plug: VerySafeVeryShort.Router, options: [port: 4025]}
      # Starts a worker by calling: VerySafeVeryShort.Worker.start_link(arg)
      # {VerySafeVeryShort.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VerySafeVeryShort.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
