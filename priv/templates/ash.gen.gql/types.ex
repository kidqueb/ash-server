defmodule <%= inspect context.web_module %>.Schema.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: <%= inspect schema.repo %>


  object :<%= schema.singular %> do
    field :id, :id
    <%= for {k, v} <- schema.attrs do %>field <%= inspect k %>, <%= inspect v %>
    <% end %><%= for {_, i, _, _s} <- schema.assocs do %>field <%= inspect(i) %>, <%= inspect(i) %>, resolve: assoc(<%= inspect(i) %>)
    <% end %>
  end

  input_object :update_<%= schema.singular %>_params do
    <%= for {k, v} <- schema.attrs do %>field <%= inspect k %>, <%= inspect v %>
    <% end %>
  end

  object :<%= schema.singular %>_queries do
    field :<%= schema.singular %>, non_null(:<%= schema.singular %>) do
      arg :id, non_null(:id)
      resolve &<%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Resolver.find/2
    end

    field :<%= schema.plural %>, list_of(:<%= schema.singular %>) do
      resolve &<%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Resolver.all/2
    end
  end

  object :<%= schema.singular %>_mutations do
    field :create_<%= schema.singular %>, :<%= schema.singular %> do
      <%= for {k, v} <- schema.attrs do %>arg <%= inspect k %>, <%= inspect v %>
      <% end %>
      resolve &<%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Resolver.create/2
    end

    field :update_<%= schema.singular %>, :<%= schema.singular %> do
      arg :id, non_null(:id)
      arg :<%= schema.singular %>, :update_<%= schema.singular %>_params

      resolve &<%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Resolver.update/2
    end

    field :delete_<%= schema.singular %>, :<%= schema.singular %> do
      arg :id, non_null(:id)

      resolve &<%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Resolver.delete/2
    end
  end
end
