defmodule <%= inspect context.module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Factory do
  alias Ash.Accounts.User

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %User{
          email: sequence("tombrady@nfl.com"),
          first_name: "Tom",
          last_name: "Brady"
        }
      end
    end
  end
end
