defmodule AshServerWeb.Schema do
  use Absinthe.Schema

  alias AshServer.Accounts
  alias AshServerWeb.Middleware

  import_types(Absinthe.Type.Custom)
  import_types(AshServerWeb.Schema.SessionTypes)
  import_types(AshServerWeb.Schema.UserTypes)
  import_types(AshServerWeb.Schema.PostTypes)

  enum :sort_order do
    value(:asc)
    value(:desc)
  end

  input_object :integer_filter do
    field :eq, :integer
    field :lt, :integer
    field :lte, :integer
    field :gt, :integer
    field :gte, :integer
  end

  # """
  # Queries
  # """
  query do
    import_fields(:session_queries)
    import_fields(:user_queries)
    import_fields(:post_queries)
  end

  # """
  # Mutations
  # """
  mutation do
    import_fields(:session_mutations)
    import_fields(:user_mutations)
    import_fields(:post_mutations)
  end

  # """
  # Plugins
  # """
  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end

  def dataloader do
    Dataloader.new()
    |> Dataloader.add_source(:accounts, Accounts.Loader.data())
  end

  def context(ctx) do
    Map.put(ctx, :loader, dataloader())
  end

  # """
  # Subscriptions
  # """
  # subscription do
  #   import_fields :thing_subscriptions
  # end

  # def middleware(middleware, _field, %Absinthe.Type.Object{identifier: identifier})
  #     when identifier in [:query, :subscription, :mutation] do
  #   [AshServerWeb.AuthMiddleware | middleware]
  # end

  def middleware(middleware, _field, %{identifier: identifier})
      when identifier in [:query, :mutation] do
    middleware ++ [Middleware.QueryErrors]
  end

  def middleware(middleware, _field, %{identifier: :mutation}) do
    middleware ++ [Middleware.ChangesetErrors]
  end

  def middleware(middleware, _field, _object), do: middleware
end
