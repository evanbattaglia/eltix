# Eltix

Elixir + LTI + Phoenix = Eltix

## Dev installation

  * Copy `config/dev.exs.template` to `config/dev.exs` and adjust LMS (Canvas)
    URLs as needed.
  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install` inside the `assets`
    directory (seems to be done automatically?)
  * Start Phoenix endpoint with `mix phx.server` or `iex -S mix phx.server` (if
    you want to use IEx.pry)
  * Add an LTI Developer Key into Canvas, copying the config from
    http://localhost:4000/, and using the `target_link_uri` (e.g.
    `http://localhost:4000/launch`) as the redirect URIs. Enable the LTI key
    and add an app using that Client ID.

Now you can launch the tool from within Canvas.

## Phoenix stuff

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
