defmodule AshWeb.Schema do
  use Absinthe.Schema

  alias Ash.Accounts

  import_types(Absinthe.Type.Custom)
  import_types(AshWeb.Schema.GenericTypes)
  import_types(AshWeb.Schema.UserTypes)
  import_types(AshWeb.Schema.AuthTypes)

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
    import_fields(:auth_mutations)
  end

  # """
  # Plugins
  # """
  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end

  def dataloader do
    Dataloader.new()
    |> Dataloader.add_source(Accounts, Accounts.data())
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
  #   [AshWeb.AuthMiddleware | middleware]
  # end
  # def middleware(middleware, _field, _object) do
  #   middleware
  # end
end
