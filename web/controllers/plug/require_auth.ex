defmodule Discuss.Plugs.RequireAuth do
  @moduledoc false
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Router.Helpers

  def init(_) do
  end

  def call(conn, _) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in.")
      |> redirect(to: Helpers.topic_path(conn, :index))
      |> halt() # Stop pipping the connection to next plug/controller
    end
  end
end