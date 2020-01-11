defmodule AshWeb.RegistrationController do
  use AshWeb, :controller

  alias Plug.Conn
  alias AshWeb.ErrorHelper

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

      {:error, changeset, conn} ->
        {:error, errors} = ErrorHelper.format_errors(changeset)

        response = %{
          error: %{
            status: 500,
            message: "Couldn't register",
            errors: errors
          }
        }

        conn
        |> put_status(500)
        |> json(response)
    end
  end
end
