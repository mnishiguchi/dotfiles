# https://qihttps://fly.io/phoenix-files/taking-control-of-map-sort-order-in-elixir/
# https://fly.io/phoenix-files/taking-control-of-map-sort-order-in-elixir/

Application.put_env(:elixir, :dbg_callback, {Macro, :dbg, []})
Application.put_env(:elixir, :ansi_enabled, true)

# print iex.exs currently used
[:blue_background, :bright, :white, "loading ", __ENV__.file]
|> IO.ANSI.format()
|> IO.puts()

# https://hexdocs.pm/iex/IEx.html#configure/1
IEx.configure(
  default_prompt:
    [:light_magenta, "%prefix>"]
    |> IO.ANSI.format()
    |> IO.chardata_to_string(),
  alive_prompt:
    [:light_magenta, "%prefix(%node)>"]
    |> IO.ANSI.format()
    |> IO.chardata_to_string(),
  # https://hexdocs.pm/elixir/Inspect.Opts.html#t:t/0
  inspect: [
    # charlists: :as_lists,
    custom_options: [sort_maps: true],
    # limit: :infinity,
    pretty: true,
    # printable_limit: :infinity
    width: 80
  ],
  history_size: 50,
  width: 80
)

import_if_available(Plug.Conn)
import_if_available(Phoenix.HTML)
import_if_available(Ecto.Query)
import_if_available(Ecto.Changeset)
