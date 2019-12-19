defmodule TimeMachinex.Compiler do
  @moduledoc false
  @test_env Mix.env() == :test
  @default_precision :microsecond

  @doc false
  @spec compile(Keyword.t()) :: :ok
  def compile(opts \\ []) do
    config =
      :time_machinex
      |> Application.get_env(TimeMachinex, [])
      |> Keyword.merge(opts)
      |> Keyword.put_new(:dynamic, @test_env)
      |> Keyword.put_new(:default_precision, @default_precision)

    Code.compiler_options(ignore_module_conflict: true)

    Code.compile_quoted(
      quote do
        defmodule TimeMachinex do
          @moduledoc ~S"""
          Define a generic clock api
          """

          unquote(now(config))
          unquote(utc_now(config))
          unquote(adapter(config))
          unquote(configure(config))
        end
      end
    )

    Code.compiler_options(ignore_module_conflict: false)

    :ok
  end

  @spec now(Keyword.t()) :: term
  defp now(config) do
    precision = config[:default_precision]

    fun =
      if config[:dynamic] do
        quote do
          @spec now(keyword) :: DateTime.t()
          def now(opts \\ []) do
            precision = Keyword.get(opts, :precision, unquote(precision))
            DateTime.truncate(adapter().now(), precision)
          end
        end
      else
        quote do
          @spec now(keyword) :: term
          defmacro now(opts \\ []) do
            precision = Keyword.get(opts, :precision, unquote(precision))

            if precision == :microsecond do
              adapter().quoted_now()
            else
              quote do
                DateTime.truncate(unquote(adapter().quoted_now()), unquote(precision))
              end
            end
          end
        end
      end

    quote do
      @doc """
      Return the current time from the configured adapter

      Options are:
        precision: :microsecond | :millisecond | :second, default: #{unquote(inspect(precision))}

      ## Examples

      ```elixir
      iex> TimeMachinex.now
      ~U[2019-12-16 00:35:07.571Z]
      ```
      """
      unquote(fun)
    end
  end

  @spec utc_now(Keyword.t()) :: term
  defp utc_now(config) do
    precision = config[:default_precision]

    fun =
      if config[:dynamic] do
        quote do
          @spec utc_now(keyword) :: DateTime.t()
          def utc_now(opts \\ []) do
            precision = Keyword.get(opts, :precision, unquote(precision))
            UTCDateTime.truncate(adapter().utc_now(), precision)
          end
        end
      else
        quote do
          @spec utc_now(keyword) :: term
          defmacro utc_now(opts \\ []) do
            precision = Keyword.get(opts, :precision, unquote(precision))

            if precision == :microsecond do
              adapter().quoted_utc_now()
            else
              quote do
                UTCDateTime.truncate(unquote(adapter().quoted_utc_now()), unquote(precision))
              end
            end
          end
        end
      end

    quote do
      @doc """
      Return the current time from the configured adapter

      Options are:
        precision: :microsecond | :millisecond | :second, default: #{unquote(inspect(precision))}

      ## Examples

      ```elixir
      iex> TimeMachinex.utc_now
      ~Z[2019-12-16 00:35:11.422092]
      ```
      """
      unquote(fun)
    end
  end

  @spec configure(Keyword.t()) :: term
  defp configure(config) do
    quote do
      @doc ~S"""
      [Re]Configure TimeMachinex.

      ## Examples

      ```elixir
      iex> TimeMachinex.configure(adapter: TimeMachinex.ManagedClock)
      :ok
      ```
      """
      @spec configure(Keyword.t()) :: :ok
      def configure(opts) do
        unquote(config)
        |> Keyword.merge(opts)
        |> unquote(__MODULE__).compile()
      end
    end
  end

  @spec adapter(Keyword.t()) :: term
  defp adapter(config) do
    quote do
      @spec adapter :: module
      defp adapter,
        do:
          :time_machinex
          |> Application.get_env(TimeMachinex, unquote(config))
          |> Keyword.get(:adapter, TimeMachinex.SystemClock)
    end
  end
end
