# Base theme adopted from: https://www.adiiyengar.com/blog/20180709/my-iex-exs
# and https://alchemist.camp/episodes/iex-exs

# Will be using `ANSI`
Application.put_env(:elixir, :ansi_enabled, true)

# Letting people know what iex.exs they are using
IO.puts(
  IO.ANSI.magenta_background() <>
    IO.ANSI.bright() <>
    IO.ANSI.underline() <>
    "Using " <> __ENV__.file() <> IO.ANSI.reset()
)

# Configuring IEx
IEx.configure(
  inspect: [limit: 5_000],
  history_size: 100,
  colors: [
    eval_result: [:green, :bright],
    eval_error: [:red, :bright],
    eval_info: [:blue, :bright]
  ],
  default_prompt:
    [
      :light_magenta,
      "%prefix>",
      :reset
    ]
    |> IO.ANSI.format()
    |> IO.chardata_to_string()
)

# Phoenix Support
import_if_available(Plug.Conn)
import_if_available(Phoenix.HTML)

phoenix_app =
  :application.info()
  |> Keyword.get(:running)
  |> Enum.reject(fn {_x, y} -> y == :undefined end)
  |> Enum.find(fn {x, _y} -> x |> Atom.to_string() |> String.match?(~r{_web}) end)

# Check if phoenix app is found
case phoenix_app do
  _ ->
    nil

  {app, _pid} ->
    IO.puts("Phoenix app:\t#{app}")

    ecto_app =
      app
      |> Atom.to_string()
      |> (&Regex.split(~r{_web}, &1)).()
      |> Enum.at(0)
      |> String.to_atom()

    exists =
      :application.info()
      |> Keyword.get(:running)
      |> Enum.reject(fn {_x, y} -> y == :undefined end)
      |> Enum.map(fn {x, _y} -> x end)
      |> Enum.member?(ecto_app)

    # Check if Ecto app exists or running
    case exists do
      _ ->
        nil

      true ->
        IO.puts("Ecto app:\t#{ecto_app}")

        # Ecto Support
        import_if_available(Ecto.Query)
        import_if_available(Ecto.Changeset)

        # Alias Repo
        repo = ecto_app |> Application.get_env(:ecto_repos) |> Enum.at(0)

        quote do
          alias unquote(repo), as: Repo
        end
    end
end
