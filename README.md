# App

## Dependencies
* Phoenix - Web Framework
* Ecto - ORM
* Absinthe - GraphQL
* Pow - Authorization
* ExMachina - Test factories

## Getting Started
To start your Phoenix server:

  * Update `secret_key_base` with `mix phx.gen.secret`
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


## Generators

### `ash.gen.gql`
Included in the boilerplate is a generator for GraphQL resources. It's usage is nearly identical to `phx.gen.json`.

    mix ash.gen.gql Context Model models [schema]

In addition to the typical schema and context files, this command will create the following files:

* `lib/ash_web/schema/model/model_resolver.ex`
* `lib/ash_web/schema/model/model_types.ex`
* `test/support/factories/model_factory.ex`
* `test/ash_web/schema/model_resolver_test.exs`

It will also prompt you to add the following lines to your `schema.ex`

    import_types(AppWeb.Schema.ModelTypes)

    query do
      import_field(:model_queries)
    end

    mutation do
      import_field(:model_mutations)
    end
