defmodule AshTplWeb.Schema do
  use Absinthe.Schema

  alias AshTpl.Accounts

  import_types(Absinthe.Type.Custom)
  import_types(AshTplWeb.Schema.UserTypes)

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
  #   [AshTplWeb.AuthMiddleware | middleware]
  # end
  # def middleware(middleware, _field, _object) do
  #   middleware
  # end
end
