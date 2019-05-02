defmodule Ash.PostFactory do
  alias Ash.Forum.Post

  defmacro __using__(_opts) do
    quote do
      def post_factory do
        %Post{
          body: "some body",
          is_active: true,
        }
      end
    end
  end
end
