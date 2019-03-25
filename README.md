# App

## Getting Started
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Boilerplate Features
Many apps have a baseline set of features that are necessary to kick-off dev. This boilerplate includes alot of those, but some may need to be pruned based on the application's needs.

### Authentication
Passwordless auth that allows user's to sign up with just an email address. Email links need to be customized based on the front-ends architecture. In development we can go to [`localhost:4000/outbox`](http://localhost:4000/outbox) to intercept all emails being sent out from Bamboo.
