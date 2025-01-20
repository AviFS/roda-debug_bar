# Roda Debug Bar

The Roda debug bar is inspired by Laravel's debug bar. That project has 17k stars, so it's clearly something people appreciate. However, there isn't one for Roda.

I've made the design Ruby-themed as much as I can, down to using the official brand color `#cc342d`. It also plugs into Sequel and I plan to have it plug into Rodauth as well, once I'm more familiar with it.

While the debug bar is inspired by Laravel's, the code is based on adam12's enhanced logger for Roda, https://github.com/adam12/roda-enhanced_logger. It was an invaluable help in implementing the thread-safe code. It still has the `current.rb` and `instance.rb` files from the original project.

![Debug Bar Preview](/docs/roda-debug_bar.png)

## Demo

https://github.com/user-attachments/assets/2e4d9305-442e-4d5e-8c4d-bddc62a934c0

More info about each of the tabs can be found at [TABS.md](/docs/TABS.md). Info about the layout of the source code can be found in [DEVELOPMENT.md](/docs/DEVELOPMENT.md). And as for the data in the json shown at the end, more info on that page can be found at [DEBUG_PAGE.md](/docs/DEBUG_PAGE.md). But we'll come back to the data in the next section...

## Separation of concerns

While the code is a little messy and spread between several different namespaces -- `roda/plugins`, `sequel/extensions` and `sequel/plugins` -- it's actually quite cleanly encapsulated in that data object.

That data object is `@data` and it's a simple Roda instance variable, a hash, containing everything that debug bar collects after all its hooks. As an instance variable, it's available everywhere in your route block and in your views.

The tabs are displayed by this relevant piece of code:

```js
// lib/roda/debug_bar/views/debug_bar.erb:189
tabs: [
  { label: 'Request', content: `<%= relative_render('debug_bar/request') %>` },
  { label: 'Models', content: `<%= relative_render('debug_bar/models') %>` },
  { label: 'Queries', content: `<%= relative_render('debug_bar/queries') %>` },
  // ...
]
```

You can add and remove tabs from here, and the spacing will be taken care of by flexbox, and the functionality by AlpineJS. And within that view, `@data` will be accessible.

So adding a tab is as simple as making a new view in `lib/roda/debug_bar/views/debug_bar/` and adding a line in the spot shown above. You can add, or remove, or modify as many as you want and it'll still be rendered well and function.

The session tab has not been implemented yet. It just has a placeholder value. Laravel's debug bar also has a timeline, exceptions, mails and gate tab.

I'd like to add a JSON expandable/collapsible view for the Ruby hashes, however I wasn't able to find one that I liked after searching through, so I might have to make my own.

## Installation

Add this line to your application's Gemfile:

    gem "roda-debug_bar"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install roda-debug_bar

## Usage

For basic usage, simply enable through the `plugin` mechanism.


```ruby
class App < Roda
  plugin :debug_bar
end
```

## Naming

Just a quick note, as I found the naming convention weird the first time I saw it. The hyphen is used to denote that a gem belongs to, or extends another. For instance `rspec-rails` extends rspec with rails-specific features and `devise-jwt` adds jwt support to devise. The underscore is used to separate words when the name of the gem itself is more than one word as in `json_pure`.

In this case, the `-` in `roda-` signifies that it's a Roda plugin, whereas the `_` in `debug_bar` means that the name of the extension is "debug bar."

## Contributing

I'd love feedback! This project is young and still hasn't hit its first stable release (1.0.0 with SemVer). You can find me on the [Ruby Discord](https://discord.gg/gC83Q4Kq) as @AviFS.

## Versioning

This project uses [Semantic Versioning](https://semver.org) for version control.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
