defmodule <%= inspect context.module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Factory do
  alias <%= inspect schema.module %>

  defmacro __using__(_opts) do
    quote do
      def <%= inspect schema.singular %>_factory do
        %<%= inspect schema.alias %>{
          <%= for {k, v} <- schema.attrs do %><%= inspect String.to_atom(k) %>: <%= inspect schema.params.create[k] %>
        <% end %>}
      end
    end
  end
end
