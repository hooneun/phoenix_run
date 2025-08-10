defmodule PhoenixRunWeb.ErrorJSONTest do
  use PhoenixRunWeb.ConnCase, async: true

  test "renders 404" do
    assert PhoenixRunWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert PhoenixRunWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
