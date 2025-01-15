# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- See TABS.md for a sense of the current planned features.
- Move out.css to `lib/roda/debug_bar/styles` and extract syntax highlighting css from `debug_bar.erb` into `lib/roda/debug_bar/styles/syntax_highlight.css`

## [0.2.0] - 2025-01-14

### Added
- Added messages tab, for rendering logs with three levels: info, warn and error
- Routes tab now traces all Roda routing methods matched, and is a full-fledged view with two-columns and syntax highlighting
- Added Ruby-themed syntax highlighting for models tab
- Added documentation, including TABS.MD, DEBUG_PAGE.MD, DEVELOPMENT.MD, CHANGELOG.MD and improved README.MD

### Changed
- Queries tab now has a clock icon svg next to the time taken to execute
- Sessions tab now has a placeholder view, for demo
- Added tailwind generated CSS to .gitignore

## [0.1.1] - 2025-01-05

### Added
- Started README.md
- Added version number
- Added LICENSE
- Added gemspec
- Added front-end logic to be able to close or minimize the debug bar, and styling for when it's done
- Added session storage to keep track of open/closed/minimized state of debug bar, and to track the selected tab, so it can preserve the selected tab and open state across http requests
- Made full color palette for Ruby brand color
- Made custom Ruby-themed syntax highlighting theme for queries tab
- Added debug page which returns `@data` as json. More at DEBUG_PAGE.MD

### Changed
- Moved `roda/` and `sequel/` directories inside `lib/`

## [0.1.0] - 2025-01-01

### Added
- Initial release
