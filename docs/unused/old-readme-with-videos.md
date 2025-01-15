# Roda Debug Bar

The Roda debug bar is inspired by Laravel's debug bar. That project has 17k stars, so it's clearly something people appreciate. However, there isn't one for Roda.

I've made the design Ruby-themed as much as I can, down to It also plugs into Sequel and I pla

While the debug bar is inspired by Laravel's, the code is based on adam12's enhanced logger for Roda, https://github.com/adam12/roda-enhanced_logger. It was an invaluable help in implementing the thread-safe code. It still has the `current.rb` and `instance.rb` files from the original project.

![Debug Bar Preview](docs/roda-debug_bar.png)


## Demo

https://github.com/user-attachments/assets/969ca1fe-e197-4dc5-a7f9-e184828e5828

Here's a demonstration of the N+1 problem when lazy loading.

https://github.com/user-attachments/assets/7ff80cb2-3c5d-447c-a5a1-bb4221207daf

It also can be minimized or hidden.

https://github.com/user-attachments/assets/e9591891-e01c-496c-bafd-0d0ac1140cef

That state will be preserved as you click around the site, so the debug bar shouldn't be a bother, but is there when you need it.

You can also hit the little bug icon to get the full JSON of all the data stored in the request that debug bar has collected.

https://github.com/user-attachments/assets/74c65b9f-a030-47e2-8f30-1480ce35f712

I'll come back to that data in the next section...

## Separation of concerns

While the code is a little messy and spread between several different namespaces -- `roda/plugins`, `sequel/extensions` and `sequel/plugins` -- it's actually quite cleanly encapsulated in that data object.

That data object is `@data` and it's a simple Roda instance variable, a hash, containing everything that debug bar collects after all its hooks. As an instance variable, it's available everywhere in your route block and in your views.

The tabs are displayed by this relevant piece of code:

```js
// lib/roda/debug_bar/views/debug_bar.erb:161
tabs: [
  { label: 'Request', content: `<%= relative_render('debug_bar/request') %>` },
  { label: 'Models', content: `<%= relative_render('debug_bar/models') %>` },
  { label: 'Queries', content: `<%= relative_render('debug_bar/queries') %>` },
  // ...
]
```

You can add and remove tabs from here, and the spacing will be taken care of by flexbox, and the functionality by AlpineJS. And within that view, `@data` will be accessible.

So adding a tab is as simple as making a new view in `lib/roda/debug_bar/views/debug_bar/` and adding a line in the spot shown above. You can add, or remove, or modify as many as you want and it'll still be rendered well and function.

The messages and session tab have not been implemented yet. They just have placeholder Laravel's debug bar also has a timeline, exceptions, mails and gate tab.

I'd like to add a JSON expandable/collapsible view for the Ruby hashes, however I wasn't able to find one that I liked after searching through, so I might have to make my own.

## Features

I've made the design Ruby-themed as much as I can.


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

Just a quick note, as I found the naming convention weird the first time I saw it. The hyphen (`-`) separator is used to denote that a gem belongs to, or extends another. For instance, this is used in rspec-rails, which extends rspec with rails-specific featur
