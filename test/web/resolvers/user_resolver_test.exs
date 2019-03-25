defmodule AppWeb.UserResolverTest do
  use AppWeb.ConnCase
  import App.Factory

  describe "user resolver" do
    test "lists all users" do
      users = insert_list(3, :user)

      query = """
        {
          users {
            id
          }
        }
      """

      res = build_conn()
        |> post("/graphql", %{query: query})
        |> json_response(200)

      users_by_id = Enum.map(users, fn u -> %{"id" => to_string(u.id)} end)

      assert res["data"] == %{"users" => users_by_id}
    end

    test "finds an user by id" do
      user = insert(:user)

      query = """
        {
          user(id: #{user.id}) {
            id
          }
        }
      """

      res = build_conn()
        |> post("/graphql", %{query: query})
        |> json_response(200)

      assert res["data"] == %{"user" => %{"id" => to_string(user.id)}}
    end
  end
end
