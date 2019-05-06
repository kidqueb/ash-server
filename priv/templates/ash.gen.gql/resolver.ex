defmodule <%= inspect context.web_module %>.Schema.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Resolver do
  alias <%= inspect context.module %>
  alias <%= inspect context.web_module %>.ErrorHelper

  def all(_args, _info) do
    {:ok, <%= inspect context.alias %>.list_<%= schema.plural %>()}
  end

  def find(%{id: id}, _info) do
    try do
      <%= schema.singular%> = <%= inspect context.alias %>.get_<%= schema.singular%>!(id)
      {:ok, <%= schema.singular%>}
    rescue
      e -> {:error, Exception.message(e)}
    end
  end

  def create(args, _info) do
    case <%= inspect context.alias %>.create_<%= schema.singular%>(args) do
      {:ok, <%= schema.singular%>} -> {:ok, <%= schema.singular%>}
      {:error, changeset} -> ErrorHelper.format_errors(changeset)
    end
  end

  def update(%{id: id, <%= schema.singular%>: <%= schema.singular%>_params}, _info) do
    try do
      <%= inspect context.alias %>.get_<%= schema.singular%>!(id)
      |> <%= inspect context.alias %>.update_<%= schema.singular%>(<%= schema.singular%>_params)
    rescue
      e -> {:error, Exception.message(e)}
    end
  end

  def delete(%{id: id}, _info) do
    try do
      <%= inspect context.alias %>.get_<%= schema.singular%>!(id)
      |> <%= inspect context.module %>.delete_<%= schema.singular%>
    rescue
      e -> {:error, Exception.message(e)}
    end
  end
end
