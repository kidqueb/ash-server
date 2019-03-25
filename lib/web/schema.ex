defmodule AppWeb.Schema do
  use Absinthe.Schema

  import_types Absinthe.Type.Custom
  import_types AppWeb.Schema.AccountTypes

  # =============================
  # Queries
  # =============================
  query do
    # Accounts
    import_fields :user_queries
  end

  # =============================
  # Mutations
  # =============================
  mutation do
    # Accounts
    import_fields :user_mutations
  end

  # =============================
  # Subscriptions
  # =============================
  # subscription do
  #   import_fields :thing_subscriptions
  # end
end
