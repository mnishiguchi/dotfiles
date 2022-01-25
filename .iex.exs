# iex.exs currently used
[:blue_background, :bright, :white, "Using config file: ", __ENV__.file]
|> IO.ANSI.format()
|> IO.puts()

# https://hexdocs.pm/iex/IEx.html#configure/1
IEx.configure(
  # https://hexdocs.pm/elixir/Inspect.Opts.html
  inspect: [
    limit: 1_000,
    charlists: :as_lists,
  ],
  history_size: 100,
  default_prompt:
    [:light_magenta, "%prefix>"]
    |> IO.ANSI.format()
    |> IO.chardata_to_string(),
  alive_prompt:
    [:light_magenta, "%prefix(%node)>"]
    |> IO.ANSI.format()
    |> IO.chardata_to_string()
)

import_if_available(Plug.Conn)
import_if_available(Phoenix.HTML)
import_if_available(Ecto.Query)
import_if_available(Ecto.Changeset)
