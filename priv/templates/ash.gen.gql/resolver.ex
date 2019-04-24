defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Controller do
  alias <%= inspect context.module %>.<%= inspect context.alias %>
  alias <%= inspect context.web_module %>.ErrorHelper

  def all(_args, _info) do
    {:ok, <%= inspect context.alias %>.list_<%= schema.plural %>()}
  end

  def find(%{id: id}, _info) do
    case <%= inspect context.alias %>.get_<%= inspect schema.singular%>(id) do
      nil -> {:error, "<%= inspect Module.concat(schema.web_namespace, schema.alias) %> id #{id} not found."}
      <%= inspect schema.singular%> -> {:ok, <%= inspect schema.singular%>}
    end
  end

  def create(args, _info) do
    case <%= inspect context.alias %>.create_<%= inspect schema.singular%>(args) do
      {:ok, <%= inspect schema.singular%>} -> {:ok, <%= inspect schema.singular%>}
      {:error, changeset} -> ErrorHelper.format_errors(changeset)
    end
  end

  def update(%{id: id, <%= inspect schema.singular%>: <%= inspect schema.singular%>_params}, _info) do
    <%= inspect context.alias %>.get_<%= inspect schema.singular%>!(id)
    |> <%= inspect context.alias %>.update_<%= inspect schema.singular%>(<%= inspect schema.singular%>_params)
  end

  def delete(%{id: id}, _info) do
    case <%= inspect context.alias %>.delete_<%= inspect schema.singular%>(id) do
      {:ok, <%= inspect schema.singular%>} -> {:ok, <%= inspect schema.singular%>}
      {:error, changeset} -> ErrorHelper.format_errors(changeset)
    end
  end
end
