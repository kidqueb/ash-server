defmodule Ash.UserFactory do
  alias Ash.Accounts.User

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %User{
          email: sequence("tombrady@nfl.com"),
          username: sequence("tb12"),
          first_name: "Tom",
          last_name: "Brady",
          password_hash: ""
        }
      end
    end
  end
end
