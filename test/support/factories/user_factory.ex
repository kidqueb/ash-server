defmodule App.UserFactory do
  alias App.Accounts.User

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %User{
          email: "tombrady@nfl.com",
          first_name: "Tom",
          last_name: "Brady"
        }
      end
    end
  end
end
