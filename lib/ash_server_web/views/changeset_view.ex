defmodule AshServerWeb.ChangesetView do
  use AshServerWeb, :view

  @doc """
  Traverses and translates changeset errors.

  See `Ecto.Changeset.traverse_errors/2` and
  `AshServerWeb.ErrorHelpers.translate_error/1` for more details.
  """
  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} ->
      %{message: msg}
    end)
  end


  def render("error.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{
      status: 500,
      message: "Couldn't register",
      errors: translate_errors(changeset)
    }
  end
end
