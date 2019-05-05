defmodule Mix.Tasks.Ash.Gen.Gql do
  @shortdoc "Generates controller, views, and context for a JSON resource"

  @moduledoc """
  Generates a resolver and types for a Absinthe Graphql resource.

      mix ash.gen.gql Accounts User users name:string age:integer

  The first argument is the context module followed by the schema module
  and its plural name (used as the schema table name).

  The context is an Elixir module that serves as an API boundary for
  the given resource. A context often holds many related resources.
  Therefore, if the context already exists, it will be augmented with
  functions for the given resource.

  > Note: A resource may also be split
  > over distinct contexts (such as `Accounts.User` and `Payments.User`).

  The schema is responsible for mapping the database fields into an
  Elixir struct.

  Overall, this generator will add the following files to `lib/`:

    * a context module in `lib/app/accounts/accounts.ex` for the accounts API
    * a schema in `lib/app/accounts/user.ex`, with an `users` table
    * a resolver in `lib/app_web/schema/user/resolver.ex`
    * type definitions in `lib/app_web/schema/user/types.ex`

  A migration file for the repository and test files for the context and
  controller features will also be generated.

  The location of the web files (controllers, views, templates, etc) in an
  umbrella application will vary based on the `:context_app` config located
  in your applications `:generators` configuration. When set, the Phoenix
  generators will generate web files directly in your lib and test folders
  since the application is assumed to be isolated to web specific functionality.
  If `:context_app` is not set, the generators will place web related lib
  and test files in a `web/` directory since the application is assumed
  to be handling both web and domain specific functionality.
  Example configuration:

      config :my_app_web, :generators, context_app: :my_app

  Alternatively, the `--context-app` option may be supplied to the generator:

      mix ash.gen.gql Sales User users --context-app warehouse

  ## Web namespace

  By default, the controller and view will be namespaced by the schema name.
  You can customize the web module namespace by passing the `--web` flag with a
  module name, for example:

      mix ash.gen.gql Sales User users --web Sales

  Which would generate a `lib/app_web/schema/sales/user/resolver.ex` and
  `lib/app_web/schema/sales/user/types.ex`.

  ## Generating without a schema or context file

  In some cases, you may wish to bootstrap JSON views, controllers, and
  controller tests, but leave internal implementation of the context or schema
  to yourself. You can use the `--no-context` and `--no-schema` flags for
  file generation control.

  ## table

  By default, the table name for the migration and schema will be
  the plural name provided for the resource. To customize this value,
  a `--table` option may be provided. For example:

      mix ash.gen.gql Accounts User users --table cms_users

  ## binary_id

  Generated migration can use `binary_id` for schema's primary key
  and its references with option `--binary-id`.

  ## Default options

  This generator uses default options provided in the `:generators`
  configuration of your application. These are the defaults:

      config :your_app, :generators,
        migration: true,
        binary_id: false,
        sample_binary_id: "11111111-1111-1111-1111-111111111111"

  You can override those options per invocation by providing corresponding
  switches, e.g. `--no-binary-id` to use normal ids despite the default
  configuration or `--migration` to force generation of the migration.
  """

  use Mix.Task

  alias Mix.Phoenix.Context
  alias Mix.Tasks.Ash.Gen

  @doc false
  def run(args) do
    if Mix.Project.umbrella? do
      Mix.raise "mix ash.gen.gql can only be run inside an application directory"
    end

    {context, schema} = Gen.Context.build(args)
    Gen.Context.prompt_for_code_injection(context)

    binding = [context: context, schema: schema]
    paths = Mix.Phoenix.generator_paths()

    prompt_for_conflicts(context)

    context
    |> copy_new_files(paths, binding)
    |> print_shell_instructions()
  end

  defp prompt_for_conflicts(context) do
    context
    |> files_to_be_generated()
    |> Kernel.++(context_files(context))
    |> Mix.Phoenix.prompt_for_conflicts()
  end
  defp context_files(%Context{generate?: true} = context) do
    Gen.Context.files_to_be_generated(context)
  end
  defp context_files(%Context{generate?: false}) do
    []
  end

  @doc false
  def files_to_be_generated(%Context{schema: schema, context_app: context_app}) do
    web_prefix = Mix.Phoenix.web_path(context_app)
    test_prefix = Mix.Phoenix.web_test_path(context_app)
    web_path = to_string(schema.web_path)

    [
      {:eex,  "resolver.ex",        Path.join([web_prefix, "schema", web_path, "#{schema.singular}/#{schema.singular}_resolver.ex"])},
      {:eex,  "types.ex",           Path.join([web_prefix, "schema", web_path, "#{schema.singular}/#{schema.singular}_types.ex"])},
      {:eex,  "factory.ex",         Path.join(["test/support/factories", "#{schema.singular}_factory.ex"])},
      {:eex,  "resolver_test.exs",  Path.join([test_prefix, "schema", web_path, "#{schema.singular}_resolver_test.exs"])}
    ]
  end

  @doc false
  def copy_new_files(%Context{} = context, paths, binding) do
    files = files_to_be_generated(context)
    Mix.Phoenix.copy_from paths, "priv/templates/ash.gen.gql", binding, files
    if context.generate?, do: Gen.Context.copy_new_files(context, paths, binding)
    inject_factory_access(paths, binding)

    context
  end

  defp write_file(content, file) do
    File.write!(file, content)
  end

  defp inject_factory_access(paths, binding) do
    content_to_inject = Mix.Phoenix.eval_from(paths, "priv/templates/ash.gen.gql/factory_access.ex", binding)
    file_path = "test/support/factory.ex"
    file = File.read!(file_path)

    if String.contains?(file, content_to_inject) do
      :ok
    else
      Mix.shell.info([:green, "* injecting ", :reset, Path.relative_to_cwd(file_path)])

      file
      |> String.trim_trailing()
      |> String.trim_trailing("end")
      |> EEx.eval_string(binding)
      |> Kernel.<>(content_to_inject)
      |> Kernel.<>("end\n")
      |> write_file(file_path)
    end
  end

  @doc false
  def print_shell_instructions(%Context{schema: schema, context_app: ctx_app} = context) do
    # Add the #{schema.singular} factory to test/support/factory.ex:
    # use #{inspect context.base_module}.#{inspect schema.alias}Factory

    Mix.shell.info """

      Import the #{schema.singular} types and fields into #{Mix.Phoenix.web_path(ctx_app)}/schema.ex:

        import_types(#{inspect Module.concat(context.web_module, schema.web_namespace)}.Schema.#{inspect schema.alias}Types)

        query do
          import_fields(:#{schema.singular}_queries)
        end

        mutation do
          import_fields(:#{schema.singular}_mutations)
        end
      """
    if context.generate?, do: Gen.Context.print_shell_instructions(context)
  end
end
