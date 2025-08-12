defmodule PhoenixRunWeb.HelloController do
  use PhoenixRunWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
