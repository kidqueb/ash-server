defmodule AshServerWeb.RegistrationController do
  use AshServerWeb, :controller

  alias Plug.Conn
  alias AshServerWeb.ErrorHelper

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, %{"user" => user_params}) do
    conn
    |> Pow.Plug.create_user(user_params)
    |> case do
      {:ok, _user, conn} ->
        response = %{
          data: %{
            token: conn.private[:api_auth_token],
            renew_token: conn.private[:api_renew_token]
          }
        }

        json(conn, response)

      {:error, changeset, _conn} ->
        response = AshServerWeb.ChangesetView.render("error.json", %{changeset: changeset})
        json(conn, response)
    end
  end
end
