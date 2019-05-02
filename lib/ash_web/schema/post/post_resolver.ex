defmodule AshWeb.PostResolver do
  alias Ash.Forum
  alias AshWeb.ErrorHelper

  def all(_args, _info) do
    {:ok, Forum.list_posts()}
  end

  def find(%{id: id}, _info) do
    try do
      post = Ash.Forum.get_post!(id)
      {:ok, post}
    rescue
      e -> {:error, Exception.message(e)}
    end
  end

  def create(args, _info) do
    case Forum.create_post(args) do
      {:ok, post} -> {:ok, post}
      {:error, changeset} -> ErrorHelper.format_errors(changeset)
    end
  end

  def update(%{id: id, post: post_params}, _info) do
    Forum.get_post!(id)
    |> Forum.update_post(post_params)
  end

  def delete(%{id: id}, _info) do
    try do
      Ash.Forum.get_post!(id)
      |> Ash.Forum.delete_post
    rescue
      e -> {:error, Exception.message(e)}
    end
  end
end
