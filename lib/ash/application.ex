defmodule Ash.Ashlication do
  # See https://hexdocs.pm/elixir/Ashlication.html
  # for more information on OTP Ashlications
  @moduledoc false

  use Ashlication

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Ash.Repo,
      # Start the endpoint when the application starts
      AshWeb.Endpoint
      # Starts a worker by calling: Ash.Worker.start_link(arg)
      # {Ash.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ash.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    AshWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
