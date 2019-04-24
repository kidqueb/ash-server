defmodule AshWeb.ErrorHelper do
  @doc """
  Format's the given changeset and returns an :error tuple
  that is formatted in a way that Absinthe can handle.
  """
  def format_errors(changeset) do
    errors =
      changeset.errors
      |> Enum.map(fn {key, {value, context}} ->
        details =
          context
          |> Enum.map(fn {a, b} ->
            %{"#{a}": b}
          end)

        [message: "#{key} #{value}", details: details]
      end)

    {:error, errors}
  end
end
