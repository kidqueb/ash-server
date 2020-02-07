defmodule AshServerWeb.Plug.GraphqlContext do
  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  # https://hexdocs.pm/absinthe/context-and-authentication.html#content
  defp build_context(%{ assigns: %{current_user: _} = assigns }), do: assigns
  defp build_context(_conn), do: %{current_user: nil}
end
