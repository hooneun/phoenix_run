defmodule PhoenixRunWeb.DashboardLive do
  use PhoenixRunWeb, :live_view

  import PhoenixRunWeb.Layouts

  def render(assigns) do
    ~H"""
    <.app>
      <div class="space-y-6">
        <h1 class="text-3xl font-bold text-gray-900">대시보드</h1>
        
    <!-- 통계 카드들 -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div class="bg-white p-6 rounded-lg shadow">
            <h2 class="text-lg font-semibold text-gray-900">총 사용자</h2>
            <p class="text-3xl font-bold text-blue-600">{@user_count}</p>
          </div>

          <div class="bg-white p-6 rounded-lg shadow">
            <h2 class="text-lg font-semibold text-gray-900">총 주문</h2>
            <p class="text-3xl font-bold text-green-600">{@order_count}</p>
          </div>

          <div class="bg-white p-6 rounded-lg shadow">
            <h2 class="text-lg font-semibold text-gray-900">수익</h2>
            <p class="text-3xl font-bold text-purple-600">₩{@revenue}</p>
          </div>
        </div>
        
    <!-- 액션 버튼들 -->
        <div class="flex space-x-4">
          <button
            phx-click="refresh_data"
            class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
          >
            데이터 새로고침
          </button>

          <.link
            navigate={~p"/products"}
            class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600"
          >
            상품 보기
          </.link>
        </div>
      </div>
    </.app>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "대시보드")
      |> assign(:user_count, 1_234)
      |> assign(:order_count, 567)
      |> assign(:revenue, "2,345,678")

    {:ok, socket}
  end

  def handle_event("refresh_data", _params, socket) do
    # 실제로는 데이터베이스에서 데이터를 가져옴
    socket =
      socket
      |> assign(:user_count, :rand.uniform(2000))
      |> assign(:order_count, :rand.uniform(1000))
      |> assign(:revenue, "#{:rand.uniform(5_000_000)}")
      |> put_flash(:info, "데이터가 새로고침되었습니다!")

    {:noreply, socket}
  end
end
