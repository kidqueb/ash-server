defmodule Ash.AccountsTest do
  use Ash.DataCase
  import Ash.Factory

  alias Ash.Accounts
  alias AshWeb.Endpoint

  @token_max_age 30 * 60 # from Accounts context

  describe "users" do
    alias Ash.Accounts.{User, AuthToken}

    @invalid_attrs %{email: nil, first_name: nil, last_name: nil}

    test "list_users/0 returns all users" do
      user = insert(:user)
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = insert(:user)
      assert Accounts.get_user!(user.id) == user
    end

    test "get_user_by_email!/1 returns the user with given email" do
      user = insert(:user)
      assert Accounts.get_user_by_email!(user.email) == user
    end

    test "create_user/1 with valid data creates a user" do
      user_params = params_for(:user)
      assert {:ok, %User{} = user} = Accounts.create_user(user_params)
      assert user.email == user_params.email
      assert user.first_name == user_params.first_name
      assert user.last_name == user_params.last_name
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = insert(:user)

      user_params =
        params_for(:user, %{
          first_name: "Tom",
          last_name: "Brady",
          email: "tombrady@nfl.com"
        })

      assert {:ok, %User{} = user} = Accounts.update_user(user, user_params)

      assert user.email == user_params.email
      assert user.first_name == user_params.first_name
      assert user.last_name == user_params.last_name
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

    test "create_auth_token/1 creates a token that verifies the user_id" do
      user = insert(:user)
      assert {:ok, %AuthToken{} = auth_token} = Accounts.create_auth_token(user)

      {:ok, user_id} = Phoenix.Token.verify(Endpoint, "user", auth_token.value, max_age: @token_max_age)

      assert auth_token.user_id == user_id
    end
  end
end
