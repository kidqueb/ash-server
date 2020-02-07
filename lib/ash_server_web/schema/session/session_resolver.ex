defmodule AshServerWeb.Schema.SessionResolver do
  alias AshServerWeb.Authentication

  def login(%{email: email, password: password}, _info) do
    case Authentication.validate_password(email, password) do
      {:ok, user} ->
        [session_token, refresh_token] = Authentication.create_tokens(user)
        {:ok, %{
          session_token: session_token,
          refresh_token: refresh_token,
          user: user
        }}

      {:error, _error} ->
        {:error, "Invalid credentials"}
    end
  end
end
