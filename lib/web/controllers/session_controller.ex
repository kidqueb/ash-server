defmodule AppWeb.SessionController do
  use AppWeb, :controller

  alias App.Accounts
  alias App.Guardian

  action_fallback AppWeb.FallbackController

  def create(conn, %{"email" => email}) do
    Accounts.provide_token(email)
    render(conn, "success.json")
  end

  def show(conn, %{"token" => token}) do
    case Accounts.verify_token_value(token) do
      {:ok, user} ->
        with {:ok, jwt, _claims} <- Guardian.encode_and_sign(user) do
          render(conn, "logged_in.json", user: user, token: jwt)
        end

      {:error, reason} ->
        render(conn, "error.json", reason: reason)
    end
  end
end
