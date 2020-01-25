defmodule AshServerWeb.Schema do
  use Absinthe.Schema

  alias AshServer.Accounts
  alias AshServerWeb.{ChangesetErrors, QueryErrors}

  import_types(Absinthe.Type.Custom)
  import_types(AshServerWeb.Schema.UserTypes)

  enum :sort_order do
    value(:asc)
    value(:desc)
  end

  # """
  # Queries
  # """
  query do
    import_fields(:user_queries)
  end

  # """
  # Mutations
  # """
  mutation do
    import_fields(:user_mutations)
  end

  # """
  # Plugins
  # """
  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end

  def dataloader do
    Dataloader.new()
    |> Dataloader.add_source(Accounts, Accounts.Loader.data())
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
    middleware ++ [QueryErrors]
  end

  def middleware(middleware, _field, %{identifier: :mutation}) do
    middleware ++ [ChangesetErrors]
  end

  def middleware(middleware, _field, _object), do: middleware
end
