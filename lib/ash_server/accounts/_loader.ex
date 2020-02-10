defmodule AshServer.Accounts.Loader do
  def data do
    Dataloader.Ecto.new(AshServer.Repo, query: &build_query/2)
  end

  defp build_query(query, _params) do
    query
  end
end
