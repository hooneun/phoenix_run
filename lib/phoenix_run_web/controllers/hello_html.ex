defmodule PhoenixRunWeb.HelloHTML do
  use PhoenixRunWeb, :html

  embed_templates "hello_html/*"

  # # sigil
  # def index(assigns) do
  #   ~H"""
  #   Hello!
  #   """
  # end
end
