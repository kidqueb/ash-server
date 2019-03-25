defmodule AppWeb.UserResolverTest do
  use AppWeb.ConnCase
  import App.Factory

  alias App.TestUtils

  describe "user resolver" do
    test "lists all users", %{conn: conn} do
      users = insert_list(3, :user)
      query = """
        {
          users {
            id
          }
        }
      """

      res = conn
        |> post("/graphql", %{query: query})
        |> json_response(200)

      assert res["data"] == %{"users" => TestUtils.to_id_array(users)}
    end

    test "finds an user by id", %{conn: conn} do
      user = insert(:user)
      query = """
        {
          user(id: #{user.id}) {
            id
          }
        }
      """

      res = conn
        |> post("/graphql", %{query: query})
        |> json_response(200)

      assert res["data"] == %{"user" => %{"id" => to_string(user.id)}}
    end

    test "creates a new user", %{conn: conn} do
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

      res = conn
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

    test "updates a user", %{conn: conn} do
      user = insert(:user)
      query = """
        mutation UpdateUser($id: ID!, $user: UpdateUserParams!) {
          updateUser(id:$id, user:$user) {
            id
            email
            firstName
            lastName
          }
        }
      """
      variables = %{
        id: user.id,
        user: %{
          email: "tim@tebow.com",
          firstName: "Tim",
          lastName: "Tebow"
        }
      }

      res = conn
        |> post("/graphql", %{query: query, variables: variables})
        |> json_response(200)

      assert res["data"]["updateUser"] == %{
        "id" => to_string(user.id),
        "email" => "tim@tebow.com",
        "firstName" => "Tim",
        "lastName" => "Tebow"
      }
    end
  end

  test "deletes a user", %{conn: conn} do
    user = insert(:user)
    query = """
      mutation {
        deleteUser(id: #{user.id}) {
          success
        }
      }
    """

    res = conn
      |> post("/graphql", %{query: query})
      |> json_response(200)

    assert res["data"]["deleteUser"] == %{"success" => true}
  end
end
