---
title: Webpack CLI Configuration Patterns
date: 2015-01-20
layout: post.jade
collection: posts
author: Jesse Clark
publish: draft
---

[Webpack](http://webpack.github.io/) is a versatile web module bundler.

The CLI tools `webpack` and `webpack-dev-server` look for a default configuration file `webpack.config.js`. Some example projects include separate configuration files for running in different situations, which requires longer invocation commands, such as:

    webpack --config webpack-production.config.js
    webpack-dev-server --config webpack-dev.config.js

This is fine for triggering those commands from some script, but it would be nice to make the simple commands pick the right defaults without needing arguments. We can do so by examining the environment from within the default `webpack.config.js` file.

Suppose we want to enable development features such as hot module reloading iff we are running `webpack-dev-server`. We would like to support running the dev server from the CLI as well as programattically, so it would not be enough to check the process name. One approach that works for both of these cases is to examining the `require()` cache for presence of the module:


```javascript
var config = {};
module.exports = config;

config.src = ...;
config.plugins = [...];

if (require.resolve(...)) {
    config.plugins.push(...);
}
```

This approach is not perfect. It would get a false positive if the `webpack-dev-server` module had been loaded by some other depedency. But it works well for the most common cases.
