defmodule PhoenixRunWeb.PageController do
  use PhoenixRunWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
