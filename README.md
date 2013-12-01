connect-assets-cssprimer
=======================

An NPM module that forces compilation of your css [connect-assets](https://github.com/TrevorBurnham/connect-assets) without referencing them in a view.

### Problems This Helps With

- You are using [requireJS](http://requirejs.org) and don't want to reference all your css files in the view.
- You have a css file that is dynamically loaded on your page but not in the view.
- You want to use the connect-assets-cdn library

### Installation

`npm install connect-assets-cssprimer`

* There is a dependency on [CoffeeScript](http://coffeescript.org).  If you want a straight javascript version, you can compile it easily yourself.

### Usage

    assets = require 'connect-assets'
    cssPrimer = require 'connect-assets-cssprimer'
    
    # Snip ...
    
    app.use assets()
    cssPrimer.loadFiles assets

    # Optionally, you can pass in a log function to see progress
    # cssPrimer.loadFiles assets, console.log

### Contributors

Tim Costa
    
### Copyright

Created by Tim Costa.  MIT License; no attribution required.
