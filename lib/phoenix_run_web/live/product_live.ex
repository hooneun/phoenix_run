defmodule PhoenixRunWeb.ProductLive do
  use PhoenixRunWeb, :live_view

  import PhoenixRunWeb.Layouts

  def render(assigns) do
    ~H"""
    <.app>
      <div class="space-y-6">
        <div class="flex justify-between items-center">
          <h1 class="text-3xl font-bold text-gray-900">상품 목록</h1>

          <button
            phx-click="add_product"
            class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600"
          >
            상품 추가
          </button>
        </div>
        
    <!-- 상품 목록 -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <%= for product <- @products do %>
            <div class="bg-white p-6 rounded-lg shadow hover:shadow-lg transition-shadow">
              <h3 class="text-lg font-semibold text-gray-900">{product.name}</h3>
              <p class="text-gray-600 mt-2">{product.description}</p>
              <div class="flex justify-between items-center mt-4">
                <span class="text-2xl font-bold text-green-600">₩{product.price}</span>
                <button
                  phx-click="delete_product"
                  phx-value-id={product.id}
                  class="text-red-500 hover:text-red-700"
                  data-confirm="정말 삭제하시겠습니까?"
                >
                  삭제
                </button>
              </div>
            </div>
          <% end %>
        </div>
        
    <!-- 빈 상태 -->
        <%= if Enum.empty?(@products) do %>
          <div class="text-center py-12">
            <div class="text-gray-400 text-6xl mb-4">📦</div>
            <h3 class="text-lg font-medium text-gray-900">상품이 없습니다</h3>
            <p class="text-gray-600">첫 번째 상품을 추가해보세요!</p>
          </div>
        <% end %>
      </div>
    </.app>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "상품 목록")
      |> assign(:products, sample_products())

    {:ok, socket}
  end

  def handle_event("add_product", _params, socket) do
    new_product = %{
      id: System.unique_integer([:positive]),
      name: "새 상품 #{:rand.uniform(100)}",
      description: "멋진 새 상품입니다",
      price: "#{:rand.uniform(100_000)}"
    }

    products = [new_product | socket.assigns.products]

    socket =
      socket
      |> assign(:products, products)
      |> put_flash(:info, "상품이 추가되었습니다!")

    {:noreply, socket}
  end

  def handle_event("delete_product", %{"id" => id}, socket) do
    id = String.to_integer(id)
    products = Enum.reject(socket.assigns.products, &(&1.id == id))

    socket =
      socket
      |> assign(:products, products)
      |> put_flash(:info, "상품이 삭제되었습니다!")

    {:noreply, socket}
  end

  # 샘플 데이터
  defp sample_products do
    [
      %{
        id: 1,
        name: "스마트폰",
        description: "최신 스마트폰입니다",
        price: "899,000"
      },
      %{
        id: 2,
        name: "노트북",
        description: "고성능 노트북입니다",
        price: "1,299,000"
      },
      %{
        id: 3,
        name: "이어폰",
        description: "무선 이어폰입니다",
        price: "199,000"
      }
    ]
  end
end
