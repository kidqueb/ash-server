defmodule AshServer.AccountsPolicyTest do
  use AshServerWeb.ConnCase
  import AshServer.Factory
  alias AshServer.Accounts

  setup_all do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(AshServer.Repo)

    other_user = insert(:user)
    %{other_user: other_user}
  end

  test "anyone can create a user" do
    assert :ok == Accounts.permit(:create_user)
  end

  @tag :authenticated
  test "only a user can view their account", %{current_user: current_user, other_user: other_user} do
    assert :ok == Accounts.permit(:get_user, current_user, current_user)
    assert {:error, :unauthorized} == Accounts.permit(:get_user, other_user, current_user)

    assert :ok == Accounts.permit(:get_user_by_email!, current_user, current_user)
    assert {:error, :unauthorized} == Accounts.permit(:get_user_by_email!, other_user, current_user)
  end

  @tag :authenticated
  test "only a user can update their account", %{current_user: current_user, other_user: other_user} do
    assert :ok == Accounts.permit(:update_user, current_user, current_user)
    assert {:error, :unauthorized} == Accounts.permit(:update_user, other_user, current_user)
  end

  @tag :authenticated
  test "only a user can delete their account", %{current_user: current_user, other_user: other_user} do
    assert :ok == Accounts.permit(:delete_user, current_user, current_user)
    assert {:error, :unauthorized} == Accounts.permit(:delete_user, other_user, current_user)
  end

  @tag :authenticated
  test "only a user can access their changeset", %{current_user: current_user, other_user: other_user} do
    assert :ok == Accounts.permit(:change_user, current_user, current_user)
    assert {:error, :unauthorized} == Accounts.permit(:change_user, other_user, current_user)
  end
end
