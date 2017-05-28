defmodule Discuss.AuthController do
  @moduledoc false
  use Discuss.Web, :controller
  plug Ueberauth

  alias Discuss.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: params["provider"]}
    changeset = User.changeset(%User{}, user_params)
    signin(conn, user_params.email, changeset)
  end

  defp signin(conn, email, changeset) do
    case insert_or_update_user(email, changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))
      {:error, _} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: topic_path(conn, :index))
    end
  end

  defp insert_or_update_user(email, changeset) do
    case Repo.get_by(User, email: email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end
end