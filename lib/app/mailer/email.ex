defmodule App.Email do
  use Bamboo.Phoenix, view: AppWeb.EmailView

  def login_request(token, user) do
    new_email()
    |> to(user.email)
    |> from("hello@production.com")
    |> subject("App Login Request")
    |> assign(:token, token)
    |> assign(:url, env_url())
    |> render(:login_request)
  end

  defp env_url do
    if Mix.env() == :prod, do: "https://production.com/", else: "http://localhost:3000/"
  end
end
