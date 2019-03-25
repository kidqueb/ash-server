defmodule App.TestUtils do
  @doc """
  Takes a list of items and returns a list of just their IDs.
  Useful when testing creation/listing of multiple items.
  """
  def to_id_array(arr) do
    Enum.map(arr, fn i -> %{"id" => to_string(i.id)} end)
  end
end
