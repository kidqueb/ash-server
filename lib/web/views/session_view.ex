defmodule AppWeb.SessionView do
  use AppWeb, :view

  alias AppWeb.UserView

  def render("success.json", _assigns) do
    %{success: true}
  end

  def render("error.json", %{reason: reason}) do
    %{reason: reason}
  end

  def render("logged_in.json", %{user: user, token: token}) do
    %{user: render_one(user, UserView, "user.json"),
      token: token}
  end
end
