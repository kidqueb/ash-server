defmodule AshWeb.Context do
  @behaviour Plug
  import Plug.Conn
  alias Ash.Guardian

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, resource, _claims} <- Guardian.resource_from_token(token) do
      %{current_user: resource}
    else
      _ -> %{}
    end
  end
end
