defmodule App.UserFactory do
  alias App.Accounts.User

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %User{
          email: sequence("tombrady@nfl.com"),
          password: "test",
          confirm_password: "test",
        }
      end
    end
  end
end
