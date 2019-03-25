defmodule AppWeb.UserResolverTest do
  use AppWeb.ConnCase
  import App.Factory

  alias App.TestUtils

  describe "user resolver" do
    test "lists all users", context do
      users = insert_list(3, :user)

      query = """
        {
          users {
            id
          }
        }
      """

      res =
        context.conn
        |> post("/graphql", %{query: query})
        |> json_response(200)

      assert res["data"] == %{"users" => TestUtils.to_id_array(users)}
    end

    test "finds an user by id", context do
      user = insert(:user)

      query = """
        {
          user(id: #{user.id}) {
            id
          }
        }
      """

      res =
        context.conn
        |> post("/graphql", %{query: query})
        |> json_response(200)

      assert res["data"] == %{"user" => %{"id" => to_string(user.id)}}
    end

    test "creates a new user", context do
      query = """
        mutation {
          createUser(
            email: "tim@tebow.com",
            firstName: "Tim",
            lastName: "Tebow"
          ) {
            success
            user {
              email
              firstName
              lastName
            }
          }
        }
      """

      res =
        context.conn
        |> post("/graphql", %{query: query})
        |> json_response(200)

      assert res["data"]["createUser"] == %{
        "success" => true,
        "user" => %{
          "email" => "tim@tebow.com",
          "firstName" => "Tim",
          "lastName" => "Tebow"
        }
      }
    end
  end
end
