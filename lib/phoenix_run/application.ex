defmodule PhoenixRun.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhoenixRunWeb.Telemetry,
      PhoenixRun.Repo,
      {DNSCluster, query: Application.get_env(:phoenix_run, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhoenixRun.PubSub},
      # Start a worker by calling: PhoenixRun.Worker.start_link(arg)
      # {PhoenixRun.Worker, arg},
      # Start to serve requests, typically the last entry
      PhoenixRunWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixRun.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixRunWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
