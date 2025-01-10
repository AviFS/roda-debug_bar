lib/

roda/debug_bar/current.rb

Wrapper around `Thread.current` to keep track of per-request attributes, like queries run, models opened, routes handled, views rendered, etc. Keeping track of these things as instance variables doesn't work. Borrowed from `roda-enhanced_logger`.

roda/debug_bar/instance.rb

Debug bar instance. All of adding to `@data` is handled here. Borrowed from `roda-enhanced_logger`.

roda/plugins/debug_bar.rb

Roda plugin. Borrowed from `roda-enhanced_logger`.

sequel/extensions/debug_bar.rb

This plugs into Sequel itself. Borrowed from `roda-enhanced_logger`.

sequel/plugins/debug_bar.rb

This plugs into Sequel models.

Attribution:
 - https://github.com/adam12

Todo note on TailwindCSS, AlpineJS, and getting it running for development locally.
