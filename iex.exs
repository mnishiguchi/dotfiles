# iex.exs currently used
[:blue_background, :bright, :white, "loading ", __ENV__.file]
|> IO.ANSI.format()
|> IO.puts()

# https://hexdocs.pm/iex/IEx.html#configure/1
IEx.configure(
  # https://hexdocs.pm/elixir/Inspect.Opts.html#t:t/0
  inspect: [
    charlists: :as_lists,
    limit: :infinity,
    printable_limit: :infinity
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

# https://qiita.com/mnishiguchi/items/f125f3c59e955aa152fc
Application.put_env(:elixir, :dbg_callback, {Macro, :dbg, []})

import_if_available(Plug.Conn)
import_if_available(Phoenix.HTML)
import_if_available(Ecto.Query)
import_if_available(Ecto.Changeset)
