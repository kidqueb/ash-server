defmodule Ash.AuthTokenFactory do
  alias Ash.Accounts.AuthToken

  defmacro __using__(_opts) do
    quote do
      def auth_token_factory do
        %AuthToken{
          user: insert(:user)
        }
      end
    end
  end
end
