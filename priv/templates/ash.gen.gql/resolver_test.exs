defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>ResolverTest do
  use <%= inspect context.web_module %>.ConnCase
  import <%= inspect schema.module %>Factory

  describe "<%= schema.singular %> resolver" do
    test "lists all <%= schema.plural %>", %{conn: conn} do
      <%= schema.plural %> = insert_list(3, :<%= schema.singular %>)

      query = """
        {
          <%= schema.plural %> {
            id
          }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response["data"]["<%= schema.plural %>"] == to_id_array(<%= schema.plural %>)
    end

    test "finds a <%= schema.singular %> by id", %{conn: conn} do
      <%= schema.singular %> = insert(:<%= schema.singular %>)

      query = """
        {
          <%= schema.singular %>(id: #{<%= schema.singular %>.id}) {
            id<%= for {k, v} <- schema.attrs do %>
            <%= k %><% end %>
          }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response["data"]["<%= schema.singular %>"] == %{
        "id" => to_string(<%= schema.singular %>.id),<%= for {k, v} <- schema.attrs do %>
        "<%= k %>" => <%= schema.singular %>.<%= k %>,<% end %>
      }
    end

    test "creates a new <%= schema.singular %>", %{conn: conn} do
      <%= schema.singular %>_params = params_for(:<%= schema.singular %>, %{<%= for {k, v} <- schema.attrs do %>
        <%= k %>: <%= schema.params.create[k] %>,<% end %>
      })

      query = """
        mutation {
          create<%= inspect schema.alias %>(<%= for {k, v} <- schema.attrs do %>
            <%= k %>: "#{<%= schema.singular %>_params.<%= k %>}",<% end %>
          ) {<%= for {k, v} <- schema.attrs do %>
            <%= k %><% end %>
          }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response["data"]["create<%= inspect schema.alias %>"] == %{<%= for {k, v} <- schema.attrs do %>
        "<%= k %>" => <%= schema.singular %>_params.<%= k %>,<% end %>
      }
    end

    test "updates a <%= schema.singular %>", %{conn: conn} do
      <%= schema.singular %> = insert(:<%= schema.singular %>)

      query = """
        mutation Update<%= inspect schema.alias %>($id: ID!, $user: Update<%= inspect schema.module %>Params!) {
          update<%= inspect schema.alias %>(id:$id, <%= schema.singular %>:$<%= schema.singular %>) {
            id<%= for {k, v} <- schema.attrs do %>
            <%= k %><% end %>
          }
        }
      """

      variables = %{
        id: <%= schema.singular %>.id,
        <%= schema.singular %>: %{<%= for {k, v} <- schema.attrs do %>
          <%= k %> => <%= inspect schema.params.update[k] %>,<% end %>
        }
      }

      response = post_gql(conn, %{query: query, variables: variables})

      assert response["data"]["update<%= inspect schema.alias %>"] == %{
        "id" => to_string(<%= schema.singular %>.id), <%= for {k, v} <- schema.attrs do %>
          "<%= k %>" => <%= inspect schema.params.update[k] %>,<% end %>
      }
    end
  end

  test "deletes a <%= schema.singular %>", %{conn: conn} do
    <%= schema.singular %> = insert(:<%= schema.singular %>)

    query = """
      mutation {
        delete<%= inspect schema.alias %>(id: #{user.id}) {
          id
        }
      }
    """

    response = post_gql(conn, %{query: query})

    assert response["data"]["delete<%= inspect schema.alias %>"] == %{
      "id" => to_string(<%= schema.singular %>.id)
    }
  end
end
