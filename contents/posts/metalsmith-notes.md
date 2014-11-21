---
title: Metalsmith Notes
date: 2014-11-18
template: post.jade
collection: posts
author: Jesse Clark
---

[Metalsmith](http://www.metalsmith.io/) is a popular static site generator.

The `metalsmith` command-line interface allows a build process to be defined by a single JSON file. If you want to vary the build process in different situations, you need to write a script that duplicates much of the logic of the CLI. It's possible to avoid duplication by calling `require('metalsmith/bin/metalsmith')`. This gives us an opportunity to modify the config with conditional or non-serializable data:

```JavaScript
var config = require('./metalsmith.json');
if (process.env.AUTO_RELOAD) {
    // modify the config in memory to include auto-reloading
    config.plugins['metalsmith-watch'] = { livereload: 35729 };
    config.metadata.customHTML = '<script src="http://localhost:35729/livereload.js?snipver=1"></script>');
}

// run the standard CLI
require('metalsmith/bin/metalsmith');
```

Which lets us use the same general config for both batch processing and live-reloading, which would otherwise be incompatible.

```Bash
node build.js                  # terminates after building
AUTO_RELOAD=1 node build.js    # keeps running until killed
```
