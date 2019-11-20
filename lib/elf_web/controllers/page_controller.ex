defmodule ElfWeb.PageController do
  use ElfWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
