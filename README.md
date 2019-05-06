# Ash

## Dependencies
* Phoenix - Web Framework
* Ecto - ORM
* Absinthe - GraphQL
* Bamboo - Email handling
* ExMachina - Test factories

## Getting Started
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Swap out secret keys by generating new ones using `mix guardian.gen.secret`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Authentication
Passwordless auth that allows user's to sign up with just an email address. Email links need to be customized based on the front-ends architecture. In development we can go to [`localhost:4000/outbox`](http://localhost:4000/outbox) to intercept all emails being sent out from Bamboo.

### Generate GQL
Included in the boilerplate is a generator for GraphQL resources. It's usage is nearly identical to `phx.gen.json`.

#### Usage
`mix ash.gen.gql Context Model models column:boolean other_column:string user_id:references:users`

In addition to the typical schema and context files, this command will create the following files:

* `lib/ash_web/schema/model/model_resolver.ex`
* `lib/ash_web/schema/model/model_types.ex`
* `test/support/factories/model_factory.ex`
* `test/ash_web/schema/model_resolver_test.exs`

It will also prompt you to add the following lines to your `schema.ex`

```
 import_types(AshWeb.Schema.ModelTypes)
 
 query do
  import_field(:model_queries)
 end
 
 mutation do
  import_field(:model_mutations)
 end
```
