# Debug Page

## Bug Icon
Clicking the bug icon redirects to `/debug_bar/last/1` which serves the entire `@data` object for the last request as JSON. That is, everything scraped by the debug bar, and all its hooks and plugins. As expected, `/debug_bar/last/{n}` will serve the nth last request. Currently, the last five requests are stored. (They are stored in the Roda class variable `@@data_store`.)

#### WIP Notes
That five requests max are stored is currently hardcoded. It will be trivial to add a plugin option to configure how many requests are stored. It might be `plugin :debug_bar, store: 5` or `max_store: 5`.

## Catch URL
Rather than maneuver to the desired url, and then hit the bug icon, you can also "catch" the `@data` just the same way. Rather than going to `example.com/jobs/2` and then hitting the bug icon, you can equivalently go to `example.com/debug_bar/catch/jobs/2`.

There are also some shorthands: `example.com/debug_bar/c/jobs/2`, and simply `example.com/c/jobs/2`.

#### WIP Notes
The `/c/` shorthand isn't official because  might clutter the path namespace for some projects. Perhaps it'll be configurable. But for now, it's there.

## URLS

    /debug_bar/last/{n}         # path to retrieve @data for nth last request

    /debug_bar/catch/{path}     # full path to catch @data for /path
    /debug_bar/c/{path}         # shorter path to catch @data for /path
    /c/{path}                   # shortest path to catch @data for /path

## Image

![Debug Page](https://avifs-images.surge.sh/image.png)
