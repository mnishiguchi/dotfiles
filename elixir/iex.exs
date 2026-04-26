# https://fly.io/phoenix-files/taking-control-of-map-sort-order-in-elixir/
# https://hexdocs.pm/iex/IEx.html#configure/1
# https://hexdocs.pm/elixir/Inspect.Opts.html

Application.put_env(:elixir, :dbg_callback, {Macro, :dbg, []})
Application.put_env(:elixir, :ansi_enabled, true)

# Show which IEx config was loaded.
[:blue_background, :bright, :white, " loading ", __ENV__.file, " "]
|> IO.ANSI.format()
|> IO.puts()

IEx.configure(
  default_prompt:
    [:light_magenta, "%prefix>"]
    |> IO.ANSI.format()
    |> IO.chardata_to_string(),
  alive_prompt:
    [:light_magenta, "%prefix(%node)>"]
    |> IO.ANSI.format()
    |> IO.chardata_to_string(),
  inspect: [
    # Uncomment when charlists are printed as text, for example ~c"abc".
    # charlists: :as_lists,

    # Uncomment when deeply nested values are collapsed as "...".
    # limit: :infinity,

    # Uncomment when long strings, binaries, or lists are truncated.
    # printable_limit: :infinity,

    # Keep map output stable and easier to compare while debugging.
    custom_options: [sort_maps: true],
    width: 80
  ],
  history_size: 50,
  width: 80
)

# Import common helpers only when the current project provides them.
import_if_available(Plug.Conn)
import_if_available(Phoenix.HTML)
import_if_available(Ecto.Query)
import_if_available(Ecto.Changeset)
