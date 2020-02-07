defmodule AshServer.UserFactory do
  alias AshServer.Accounts.User

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %User{
          email: sequence("test@email.com"),
          password_hash: Argon2.hash_pwd_salt("test_password"),
        }
      end
    end
  end
end
