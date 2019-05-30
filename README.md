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

## Authentication
By default Ash uses a hybrid authentication setup. User's aren't required to use a password if they don't want. It is up to the front-end to make the call on if it should request a token to be sent to the user or if they're trying to login with a email/password combination.

### Usage
To request a token sent to a user's email we can use the `emailLogin` mutation.

    mutation {
      emailLogin(email: "example@email.com") {
        success
      }
    }

    # {data: { 
    #   emailLogin: { success: true }
    # }}

In dev, emails can be intercepted at [`localhost:4000/outbox`](http://localhost:4000/outbox) or you can grab the token from the logged params. Once they recieve the token via email it can be authenticated with the `login` mutation.

    mutation {
      login(token: "auth_token_from_the_email") {
        token
        user {
          id
          email
        }
      }
    }

    # ... login: {
    #   token: "jwt_to_be_sent_with_requests",
    #   user: {
    #     id: 1
    #     email: example@email.com
    #   }
    # }} ...

Alternatively we can use the `login` mutation to authenticate a email/password combination if they've setup a password.

    mutation {
      login(email: "example@email.com", password: "some_pw") {
        token
        user {
          id
          email
        }
      }
    }

    # ... login: {
    #   token: "jwt_to_be_sent_with_requests",
    #   user: {
    #     id: 1
    #     email: example@email.com
    #   }
    # }} ...

### Using _only_ **Passwordless** Auth
In order to rip out the password auth you can make the following changes:

1. Remove references to `password`, `password_hash` and `put_password_hash` from `lib/ash/accounts/user.ex`. Also kill `password_hash` in `priv/repo/migrations/XXXXXXXX_create_users.exs`
1. Remove `authenticate_password` and `check_password` definitions from `lib/ash/accounts.ex`
1. Remove related `login` and `encode_and_sign` definitions from `lib/ash_web/schema/auth_resolver.ex`
1. `comeonin` and `argon2_elixir` can be removed from `mix.exs`.

### Using _only_ **Password** Auth
This is a little more invovled as there are entire schemas created to handle email auth. In order to rip out the passwordless auth you can make the following changes:

1. Delete migrations and context files related to `auth_tokens` and `auth_requests`.
1. Remove references to any `[action]_auth_token` and `[action]_auth_token` functions in `lib/ash/accounts.ex`. Also remove the `provide_token`, `verify_token_value`, `send_token` and `create_token` function definitions.
1. Remove `has_many(:auth_tokens, AuthToken)` from `lib/ash/accounts/user.ex`.
1. Remove related  `email_login` and `login` definitions from `lib/ash_web/schema/auth_resolver.ex`
1. Remove `Bamboo` config from `./config/[env].exs` files.
1. Delete Bamboo related templates located at `lib/ash_web/templates`, email view at `lib/ash_web/views/email_view.ex` and `lib/ash/mailer{.ex}` module files.
1. `bamboo` can be removed from `mix.exs`.

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

    import_types(AshWeb.Schema.ModelTypes)

    query do
      import_field(:model_queries)
    end

    mutation do
      import_field(:model_mutations)
    end
