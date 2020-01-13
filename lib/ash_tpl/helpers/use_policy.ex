defmodule AshTpl.Helpers.UsePolicy do
  defmacro __using__(_opts) do
    quote do
      defdelegate authorize(action, user, params), to: __MODULE__.Policy
      def permit(func, user \\ nil, params \\ []), do: Bodyguard.permit(__MODULE__, func, user, params)
    end
  end
end
