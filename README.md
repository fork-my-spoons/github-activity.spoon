# GitHub Menu Bar App

<p align="center">
   <a href="https://github.com/fork-my-spoons/github-activity.spoon/issues">
    <img alt="GitHub issues" src="https://img.shields.io/github/issues/fork-my-spoons/github-activity.spoon">
  </a>
  <a href="https://github.com/fork-my-spoons/github-activity.spoon/releases">
    <img alt="GitHub all releases" src="https://img.shields.io/github/downloads/fork-my-spoons/github-activity.spoon/total">
  </a>
  <a href="https://github.com/fork-my-spoons/github-activity.spoon/releases">
   <img alt="GitHub release (latest by date)" src="https://img.shields.io/github/v/release/fork-my-spoons/github-activity.spoon">
  </a>
</p>

Menu bar app for macOS which shows 10 latest events for a github profile, similar to the event feed on github's landing page:

<p align="center">
  <img src="https://github.com/fork-my-spoons/github-activity.spoon/raw/master/screenshots/screenshot.png"/>
</p>

# Installation

- install [Hammerspoon](http://www.hammerspoon.org/) - a powerful automation tool for OS X
   - Manually:

      Download the [latest release](https://github.com/Hammerspoon/hammerspoon/releases/latest), and drag Hammerspoon.app from your Downloads folder to Applications.
   - Homebrew:

      ```brew install hammerspoon --cask```
 - download [github-activity.spoon](https://github.com/fork-my-spoons/github-activity.spoon/releases/latest/download/github-activity.spoon.zip), unzip and double click on a .spoon file. It will be installed under ~/.hammerspoon/Spoons folder.
 - open ~/.hammerspoon/init.lua and add the following snippet:

```lua
-- GitHub
hs.loadSpoon('github-activity')
spoon['github-activity']:setup({
    username = 'streetturtle'
})
spoon['github-activity']:start()
```

This app uses icons, to properly display them, install a [feather-font](https://github.com/AT-UI/feather-font) by [downloading](https://github.com/AT-UI/feather-font/raw/master/src/fonts/feather.ttf) this .ttf font and installing it.
