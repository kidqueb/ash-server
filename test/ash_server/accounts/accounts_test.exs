defmodule AshServer.AccountsTest do
  use AshServer.DataCase
  import AshServer.Factory

  alias AshServer.Accounts

  describe "users" do
    alias AshServer.Accounts.User

    @invalid_attrs %{email: nil, username: nil}

    test "create_user/1 with valid data creates a user" do
      user_params =
        params_for(:user, %{
          password: "some_password",
          confirm_password: "some_password"
        })

      assert {:ok, %User{} = user} = Accounts.create_user(user_params)
      assert user.email == user_params.email
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "get_user!/1 returns the user with given id" do
      user = insert(:user)
      assert Accounts.get_user!(user.id) == user
    end

    test "get_user_by_email!/1 returns the user with given email" do
      user = insert(:user)
      assert Accounts.get_user_by_email!(user.email) == user
    end

    test "list_users/1 returns all users" do
      users = insert_list(3, :user)
      assert Accounts.list_users() == users
    end

    test "update_user/2 with valid data updates the user" do
      user = insert(:user)

      user_params = %{
        password: "some_password",
        confirm_password: "some_password",
        current_password: "test_password"
      }

      assert {:ok, %User{} = user} = Accounts.update_user(user, user_params)
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = insert(:user)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = insert(:user)
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = insert(:user)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
