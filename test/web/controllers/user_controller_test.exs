# defmodule AppWeb.UserControllerTest do
#   use AppWeb.ConnCase
#   import App.Factory

#   alias App.Accounts.User
#   alias AppWeb.UserView

#   @invalid_attrs %{email: nil, first_name: nil, last_name: nil}

#   setup %{conn: conn} do
#     {:ok, conn: put_req_header(conn, "accept", "application/json")}
#   end

#   describe "index" do
#     test "lists all users", %{conn: conn} do
#       users = insert_list(3, :user)
#       conn = get(conn, Routes.user_path(conn, :index))
#       assert json_response(conn, 200) == render_json("index.json", users: users)
#     end
#   end

#   describe "create/show user" do
#     test "renders user when data is valid", %{conn: conn} do
#       user_params = params_for(:user)
#       conn = post(conn, Routes.user_path(conn, :create), user: user_params)
#       assert %{"id" => id} = json_response(conn, 201)["data"]

#       conn = get(conn, Routes.user_path(conn, :show, id))
#       user = Map.merge(%{id: id}, user_params)
#       assert json_response(conn, 200) == render_json("show.json", user: user)
#     end

#     test "renders errors when data is invalid", %{conn: conn} do
#       conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
#       assert json_response(conn, 422)["errors"] != %{}
#     end
#   end

#   describe "update user" do
#     setup [:create_user]

#     test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
#       user_params = params_for(:user)
#       conn = put(conn, Routes.user_path(conn, :update, user), user: user_params)
#       assert %{"id" => ^id} = json_response(conn, 200)["data"]

#       conn = get(conn, Routes.user_path(conn, :show, id))
#       user = Map.merge(%{id: id}, user_params)
#       assert json_response(conn, 200) == render_json("show.json", user: user)
#     end

#     test "renders errors when data is invalid", %{conn: conn, user: user} do
#       conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
#       assert json_response(conn, 422)["errors"] != %{}
#     end
#   end

#   describe "delete user" do
#     setup [:create_user]

#     test "deletes chosen user", %{conn: conn, user: user} do
#       conn = delete(conn, Routes.user_path(conn, :delete, user))
#       assert response(conn, 204)

#       assert_error_sent 404, fn ->
#         get(conn, Routes.user_path(conn, :show, user))
#       end
#     end
#   end

#   defp create_user(_) do
#     user = insert(:user)
#     {:ok, user: user}
#   end

#   defp render_json(template, assigns) do
#     assigns = Map.new(assigns)

#     UserView.render(template, assigns)
#     |> Jason.encode!
#     |> Jason.decode!
#   end
# end
