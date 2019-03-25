defmodule AppWeb.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(AppWeb.Schema.AccountTypes)

  # =============================
  # Queries
  # =============================
  query do
    # Accounts
    import_fields(:user_queries)
  end

  # =============================
  # Mutations
  # =============================
  mutation do
    # Accounts
    import_fields(:user_mutations)
  end

  # =============================
  # Subscriptions
  # =============================
  # subscription do
  #   import_fields :thing_subscriptions
  # end


  # def middleware(middleware, _field, %Absinthe.Type.Object{identifier: identifier})
  #     when identifier in [:query, :subscription, :mutation] do
  #   [AppWeb.AuthMiddleware | middleware]
  # end
  # def middleware(middleware, _field, _object) do
  #   middleware
  # end
end
