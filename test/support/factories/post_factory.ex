defmodule AshServer.PostFactory do
  alias AshServer.Blog.Post

  defmacro __using__(_opts) do
    quote do
      def post_factory do
        %Post{
          title: "some title",
          body: "some body",
          is_public: "some is_public",
        }
      end
    end
  end
end
