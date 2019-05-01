defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Resolver do
  alias <%= inspect Module.concat(schema.web_namespace, schema.alias) %>
  alias <%= inspect context.web_module %>.ErrorHelper

  def all(_args, _info) do
    {:ok, <%= inspect context.alias %>.list_<%= schema.plural %>()}
  end

  def find(%{id: id}, _info) do
    try do
      <%= schema.singular%> = <%= inspect Module.concat(schema.web_namespace, schema.alias) %>.get_<%= schema.singular%>!(id)
      {:ok, <%= schema.singular%>}
    rescue
      e -> {:error, Exception.message(e)}
    end
  end

  def find(%{id: id}, _info) do
    case <%= inspect context.alias %>.get_<%= schema.singular%>(id) do
      nil -> {:error, "<%= inspect Module.concat(schema.web_namespace, schema.alias) %> id #{id} not found."}
      <%= schema.singular%> -> {:ok, <%= schema.singular%>}
    end
  end

  def create(args, _info) do
    case <%= inspect context.alias %>.create_<%= schema.singular%>(args) do
      {:ok, <%= schema.singular%>} -> {:ok, <%= schema.singular%>}
      {:error, changeset} -> ErrorHelper.format_errors(changeset)
    end
  end

  def update(%{id: id, <%= schema.singular%>: <%= schema.singular%>_params}, _info) do
    <%= inspect context.alias %>.get_<%= schema.singular%>!(id)
    |> <%= inspect context.alias %>.update_<%= schema.singular%>(<%= schema.singular%>_params)
  end

  def delete(%{id: id}, _info) do
    case <%= inspect context.alias %>.delete_<%= schema.singular%>(id) do
      {:ok, <%= schema.singular%>} -> {:ok, <%= schema.singular%>}
      {:error, changeset} -> ErrorHelper.format_errors(changeset)
    end
  end
end
