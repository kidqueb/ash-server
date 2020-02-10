defmodule AshServerWeb.Schema.SessionResolver do
  alias AshServerWeb.Authentication

  def login(%{email: email, password: password}, _info) do
    case Authentication.validate_password(email, password) do
      {:ok, user} ->
        {session_token, renew_token} = Authentication.create_tokens(user)
        {:ok, %{session_token: session_token, renew_token: renew_token, user: user}}

      {:error, _error} ->
        {:error, :invalid}
    end
  end

  def renew_session(_params, info) do
    with renew_token <- Map.get(info.context, :renew_token),
         {:ok, session} <- Authentication.validate_renew_token(renew_token) do
      {:ok,
       %{
         session_token: session.session_token,
         renew_token: session.renew_token,
         user: session.session_payload
       }}
    else
      _ ->
        {:error, :unauthorized}
    end
  end
end
