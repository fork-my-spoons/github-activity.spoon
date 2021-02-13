# GitHub Menu Bar App

![screenshot](./screenshots/screenshot.png)

Shows 10 latests events for your github profile, similar to the event feed on github's landing page.

# Installation

 - download and install [Hammerspoon](https://github.com/Hammerspoon/hammerspoon/releases/latest)
 - download and install [github-activity.spoon](https://github.com/fork-my-spoons/github-activity.spoon/raw/master/github-activity.spoon.zip)
 - open ~/.hammerspoon/init.lua and add following snippet:

```lua
-- GitHub
hs.loadSpoon('github-activity')
spoon['github-activity']:setup({
    username = 'streetturtle'
})
spoon['github-activity']:start()
```

This app uses icons, to properly display them, install a [feather-font](https://github.com/AT-UI/feather-font) by [downloading](https://github.com/AT-UI/feather-font/raw/master/src/fonts/feather.ttf) this .ttf font and installing it.
