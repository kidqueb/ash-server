defmodule AshServerWeb.Plug.GraphqlContext do
  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  # https://hexdocs.pm/absinthe/context-and-authentication.html#content
  defp build_context(conn) do
    with %{current_user: current_user} <- conn.assigns do
      %{current_user: current_user}
    else
      _ -> %{current_user: nil}
    end
  end
end
