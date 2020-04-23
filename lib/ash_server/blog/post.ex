defmodule AshServer.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :is_public, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :is_public])
    |> validate_required([:title, :body, :is_public])
  end

  import Ecto.Query, warn: false

  def filter_with(query, filter) do
    Enum.reduce(filter, query, fn
      {:title, title}, query ->
        from q in query, where: ilike(q.title, ^"%#{title}%")
      {:body, body}, query ->
        from q in query, where: ilike(q.body, ^"%#{body}%")
      {:is_public, is_public}, query ->
        from q in query, where: ilike(q.is_public, ^"%#{is_public}%")
    end)
  end
end
