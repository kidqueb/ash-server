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
            username
          }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response["data"]["user"] == %{
        "id" => to_string(user.id),
        "email" => user.email,
        "username" => user.username
      }
    end

    test "errors when looking for a nonexistent user by id", %{conn: conn} do
      query = """
        {
          user(id: "doesnt_exist") { id }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response["data"]["user"] == nil
      assert response["errors"]
    end

    test "creates a new user", %{conn: conn} do
      user_params = params_for(:user, %{
        email: "tim@tebow.com",
        username: "teboned",
        password: "somepassword",
        confirm_password: "somepassword",
      })

      query = """
        mutation {
          createUser(
            email: "#{user_params.email}",
            username: "#{user_params.username}",
            password: "#{user_params.password}",
            confirmPassword: "#{user_params.confirm_password}"
          ) {
            email
            username
          }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response["data"]["createUser"] == %{
        "email" => user_params.email,
        "username" => user_params.username
      }
    end

    test "updates a user", %{conn: conn} do
      user_params = params_for(:user, %{
        password: "password",
        confirm_password: "password"
      })

      {:ok, user} = AshServer.Accounts.create_user(user_params)

      query = """
        mutation UpdateUser($id: ID!, $user: UpdateUserParams!) {
          updateUser(id: $id, user: $user) {
            id
            email
            username
          }
        }
      """

      variables = %{
        id: user.id,
        user: %{
          email: "new@email.com",
          username: "new_username",
          current_password: "password",
        }
      }

      conn = Pow.Plug.assign_current_user(conn, user, otp_app: :ash_server)
      response = post_gql(conn, %{query: query, variables: variables})

      assert response["data"]["updateUser"] == %{
        "id" => to_string(user.id),
        "email" => "new@email.com",
        "username" => "new_username"
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

    @tag :authenticated
    test "other users cannot delete a different user", %{conn: conn} do
      user = insert(:user)

      query = """
        mutation {
          deleteUser(id: #{user.id}) { id }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response["data"]["deleteUser"] == nil
      assert response["errors"]
    end
  end
end
