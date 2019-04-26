defmodule AshWeb.UserResolverTest do
  use AshWeb.ConnCase
  import Ash.Factory

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

      res = post_gql(conn, %{query: query})

      assert res["data"] == %{"users" => to_id_array(users)}
    end

    test "finds a user by id", %{conn: conn} do
      user = insert(:user)

      query = """
        {
          user(id: #{user.id}) {
            id
            email
            firstName
            lastName
          }
        }
      """

      res = post_gql(conn, %{query: query})

      assert res["data"] == %{"user" => %{
        "id" => to_string(user.id),
        "email" => user.email,
        "firstName" => user.first_name,
        "lastName" => user.last_name
      }}
    end

    test "creates a new user", %{conn: conn} do
      user_params = params_for(:user, %{
        email: "tim@tebow.com",
        first_name: "Tim",
        last_name: "Tebow"
      })

      query = """
        mutation {
          createUser(
            email: "#{user_params.email}",
            firstName: "#{user_params.first_name}",
            lastName: "#{user_params.last_name}"
          ) {
            email
            firstName
            lastName
          }
        }
      """

      res = post_gql(conn, %{query: query})

      assert res["data"]["createUser"] == %{
        "email" => user_params.email,
        "firstName" => user_params.first_name,
        "lastName" => user_params.last_name
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

      res = post_gql(conn, %{query: query, variables: variables})

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
          id
        }
      }
    """

    res = post_gql(conn, %{query: query})

    assert res["data"]["deleteUser"] == %{"id" => to_string(user.id)}
  end
end
