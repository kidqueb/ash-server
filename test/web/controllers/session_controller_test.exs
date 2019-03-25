# defmodule AppWeb.SessionControllerTest do
#   use AppWeb.ConnCase
#   import App.Factory

#   setup %{conn: conn} do
#     {:ok, conn: put_req_header(conn, "accept", "application/json")}
#   end

#   describe "create" do
#     test "returns success when current users email is used", %{conn: conn} do
#       user = insert(:user)
#       conn = post(conn, "/graphql", %{"email" => user.email})
#       assert json_response(conn, 200) == %{"success" => true}
#     end

#     test "returns success when a non-real email is used", %{conn: conn} do
#       conn = post(conn, Routes.login_path(conn, :create), %{"email" => "not-email"})
#       assert json_response(conn, 200) == %{"success" => true}
#     end
#   end
# end
