defmodule AppWeb.UserViewTest do
  use App.DataCase
  import App.Factory
  alias AppWeb.UserView

  describe "user json views" do
    test "user.json" do
      user = insert(:user)
      rendered_user = UserView.render("user.json", user: user)

      assert rendered_user == %{
        id: user.id,
        email: user.email,
        firstName: user.first_name,
        lastName: user.last_name
      }
    end

    test "index.json" do
      user = insert(:user)
      rendered_users = UserView.render("index.json", users: [user])

      assert rendered_users == %{
        data: [UserView.render("user.json", user: user)]
      }
    end

    test "show.json" do
      user = insert(:user)
      rendered_user = UserView.render("show.json", user: user)

      assert rendered_user == %{
        data: UserView.render("user.json", user: user)
      }
    end
  end
end
