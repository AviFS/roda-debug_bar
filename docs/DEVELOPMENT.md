# Development

- [`lib/`](#roda)
  * [`roda/`](#roda)
    - [`debug_bar/`](#rodadebug_bar)
      * [`views`](#rodadebug_barviews)
    - [`plugins/`](#roda)
  * [`sequel/`](#sequel)
    - [`plugins/`](#sequel)
    -  [`extensions/`](#sequel)

## `roda`

`plugins/debug_bar.rb`

Roda plugin. Borrowed from `roda-enhanced_logger`.

## `sequel`

`extensions/debug_bar.rb`

This plugs into Sequel itself for tracking queries. Borrowed from `roda-enhanced_logger`.

`plugins/debug_bar.rb`

This plugs into Sequel models for tracking models.

## `roda/debug_bar`

`current.rb`

Wrapper around `Thread.current` to keep track of per-request attributes, like queries run, models opened, routes handled, views rendered, etc. Keeping track of these things as instance variables doesn't work. Borrowed from `roda-enhanced_logger`.

`instance.rb`

Debug bar instance. All of adding to `@data` is handled here. Borrowed from `roda-enhanced_logger`.

## `roda/debug_bar/views`

`debug_bar.erb`

Layout for debug bar.

## `roda/debug_bar/views/debug_bar/*.erb`

One file for each tab, and one for the right hand side of the header that includes meta-information. (Currently `GET /path 4.3ms`.)
  - models.erb
  - queries.erb
  - request.erb
  - right_bar.erb
  - route.erb
  - views.erb


Attribution:
 - https://github.com/adam12

Todo note on TailwindCSS, AlpineJS, and getting it running for development locally.
