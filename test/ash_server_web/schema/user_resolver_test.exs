defmodule AshServerWeb.UserResolverTest do
  use AshServerWeb.ConnCase
  import AshServer.Factory

  describe "user resolver" do
    test "lists all users", %{conn: conn} do
      users = insert_list(3, :user)

      query = """
        {
          users { id }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response["data"]["users"] == to_id_array(users)
    end

    test "finds a user by id", %{conn: conn} do
      user = insert(:user)

      query = """
        {
          user(id: #{user.id}) {
            id
            email
          }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response["data"]["user"] == %{
        "id" => to_string(user.id),
        "email" => user.email,
      }
    end

    test "errors when finding nonexistent user by id", %{conn: conn} do
      query = """
        {
          user(id: 0) { id }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response == %{
        "data" => %{"user" => nil},
        "errors" => [%{
          "locations" => [%{"column" => 0, "line" => 2}],
          "message" => "User not found",
          "path" => ["user"]
        }]
      }
    end

    test "creates a new user", %{conn: conn} do
      user_params = params_for(:user, %{
        email: "tim@tebow.com",
        password: "somepassword",
        confirm_password: "somepassword",
      })

      query = """
        mutation {
          createUser(
            email: "#{user_params.email}",
            password: "#{user_params.password}",
            confirmPassword: "#{user_params.confirm_password}"
          ) {
            email
          }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response["data"]["createUser"] == %{
        "email" => user_params.email
      }
    end

    @tag :authenticated
    test "users can update themselves", %{conn: conn} do
      %{current_user: current_user} = conn.assigns

      query = """
        mutation UpdateUser($id: ID!, $user: UpdateUserParams!) {
          updateUser(id: $id, user: $user) {
            id
            email
          }
        }
      """

      variables = %{
        id: current_user.id,
        user: %{
          password: "password",
          confirmPassword: "password",
          currentPassword: "test_password"
        }
      }

      response = post_gql(conn, %{query: query, variables: variables})

      assert response["data"]["updateUser"] == %{
        "id" => to_string(current_user.id),
        "email" => current_user.email,
      }
    end

    @tag :authenticated
    test "users can't update someone else", %{conn: conn} do
      user = insert(:user)

      query = """
        mutation UpdateUser($id: ID!, $user: UpdateUserParams!) {
          updateUser(id: $id, user: $user) {
            id
            email
          }
        }
      """

      variables = %{
        id: user.id,
        user: %{
          password: "password",
          confirmPassword: "password",
          currentPassword: "test_password"
        }
      }

      response = post_gql(conn, %{query: query, variables: variables})

      assert response == %{
        "data" => %{"updateUser" => nil},
        "errors" => [%{
          "locations" => [%{"column" => 0, "line" => 2}],
          "message" => "unauthorized",
          "path" => ["updateUser"]
        }]
      }
    end

    test "errors when updating nonexistent user", %{conn: conn} do
      query = """
        mutation UpdateUser($id: ID!, $user: UpdateUserParams!) {
          updateUser(id: $id, user: $user) {
            id
            email
          }
        }
      """

      variables = %{
        id: "0",
        user: %{}
      }

      response = post_gql(conn, %{query: query, variables: variables})

      assert response == %{
        "data" => %{"updateUser" => nil},
        "errors" => [%{
          "locations" => [%{"column" => 0, "line" => 2}],
          "message" => "User not found",
          "path" => ["updateUser"]
        }]
      }
    end

    @tag :authenticated
    test "users can delete themselves", %{conn: conn} do
      current_user = conn.assigns.current_user

      query = """
        mutation {
          deleteUser(id: #{current_user.id}) { id }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response["data"]["deleteUser"] == %{
        "id" => to_string(current_user.id)
      }
    end

    test "errors when deleting nonexistent users", %{conn: conn} do
      query = """
        mutation {
          deleteUser(id: 0) { id }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response == %{
        "data" => %{"deleteUser" => nil},
        "errors" => [%{
          "locations" => [%{"column" => 0, "line" => 2}],
          "message" => "User not found",
          "path" => ["deleteUser"]
        }]
      }
    end

    @tag :authenticated
    test "other users cannot delete a different user", %{conn: conn} do
      user = insert(:user)

      query = """
        mutation {
          deleteUser(id: #{user.id}) { id }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response == %{
        "data" => %{"deleteUser" => nil},
        "errors" => [%{
          "locations" => [%{"column" => 0, "line" => 2}],
          "message" => "unauthorized",
          "path" => ["deleteUser"]
        }]
      }
    end
  end
end
