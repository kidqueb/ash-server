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
