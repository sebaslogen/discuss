defmodule Discuss.TopicController do
  @moduledoc false
  use Discuss.Web, :controller

  alias Discuss.Topic

  def new(conn, _) do
    changeset = Topic.changeset(%Topic{}, %{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)
    case Repo.insert(changeset) do
      {:ok, post} -> IO.inspect(post)
#    render conn,
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def index(conn, _) do
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end
end