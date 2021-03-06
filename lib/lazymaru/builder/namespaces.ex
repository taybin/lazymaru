defmodule Lazymaru.Builder.Namespaces do
  alias Lazymaru.Router.Resource

  @namespaces [:namespace, :group, :resource, :resources, :segment]

  Module.eval_quoted __MODULE__, (for namespace <- @namespaces do
    quote do
      defmacro unquote(namespace)([do: block]), do: block
      defmacro unquote(namespace)(path, [do: block]) do
        quote do
          %Resource{path: path} = resource = @resource
          @resource %{resource | path: path ++ [unquote(to_string path)]}
          unquote(block)
          @resource resource
        end
      end
    end
  end)

  defmacro route_param(param, [do: block]) do
    quote do
      %Resource{path: path, param_context: param_context} = resource = @resource
      @resource %{ resource |
                   path: path ++ [unquote(param)],
                   param_context: param_context ++ @param_context
                 }
      @param_context []
      unquote(block)
      @resource resource
    end
  end

end
