defmodule AppWeb.GraphqlContext do
  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  # https://hexdocs.pm/absinthe/context-and-authentication.html#content
  defp build_context(conn), do: %{current_user: Pow.Plug.current_user(conn)}
end
