defmodule AshTpl.UserFactory do
  alias AshTpl.Accounts.User

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %User{
          email: sequence("some@email.com"),
          username: sequence("username"),
        }
      end
    end
  end
end
