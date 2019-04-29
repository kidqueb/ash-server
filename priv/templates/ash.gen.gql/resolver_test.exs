defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>ResolverTest do
  use <%= inspect context.web_module %>.ConnCase
  import <%= inspect context.module %>.<%= inspect schema.module %>Factory

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
            id
            email
            firstName
            lastName
          }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response["data"]["<%= schema.singular %>"] == %{
        "id" => to_string(<%= schema.singular %>.id),
        "email" => user.email,
        "firstName" => user.first_name,
        "lastName" => user.last_name
      }
    end

    test "creates a new <%= schema.singular %>", %{conn: conn} do
      <%= schema.singular %>_params = params_for(:<%= schema.singular %>, %{
        email: "tim@tebow.com",
        first_name: "Tim",
        last_name: "Tebow"
      })

      query = """
        mutation {
          create<%= inspect schema.module %>(
            email: "#{<%= schema.singular %>_params.email}",
            firstName: "#{<%= schema.singular %>_params.first_name}",
            lastName: "#{<%= schema.singular %>_params.last_name}"
          ) {
            email
            firstName
            lastName
          }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response["data"]["create<%= inspect schema.module %>"] == %{
        "email" => <%= schema.singular %>_params.email,
        "firstName" => <%= schema.singular %>_params.first_name,
        "lastName" => <%= schema.singular %>_params.last_name
      }
    end

    test "updates a <%= schema.singular %>", %{conn: conn} do
      <%= schema.singular %> = insert(:<%= schema.singular %>)

      query = """
        mutation Update<%= inspect schema.module %>($id: ID!, $user: Update<%= inspect schema.module %>Params!) {
          update<%= inspect schema.module %>(id:$id, <%= schema.singular %>:$<%= schema.singular %>) {
            id
            email
            firstName
            lastName
          }
        }
      """

      variables = %{
        id: <%= schema.singular %>.id,
        user: %{
          email: "tim@tebow.com",
          firstName: "Tim",
          lastName: "Tebow"
        }
      }

      response = post_gql(conn, %{query: query, variables: variables})

      assert response["data"]["update<%= inspect schema.module %>"] == %{
        "id" => to_string(<%= schema.singular %>.id),
        "email" => "tim@tebow.com",
        "firstName" => "Tim",
        "lastName" => "Tebow"
      }
    end
  end

  test "deletes a <%= schema.singular %>", %{conn: conn} do
    <%= schema.singular %> = insert(:<%= schema.singular %>)

    query = """
      mutation {
        delete<%= inspect schema.module %>(id: #{user.id}) {
          id
        }
      }
    """

    response = post_gql(conn, %{query: query})

    assert response["data"]["delete<%= inspect schema.module %>"] == %{
      "id" => to_string(<%= schema.singular %>.id)
    }
  end
end
