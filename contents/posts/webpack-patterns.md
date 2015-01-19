---
title: Webpack CLI Configuration Patterns
date: 2015-01-20
template: post.jade
collection: posts
author: Jesse Clark
publish: draft
---

[Webpack](http://webpack.github.io/) is a versatile web module bundler.

The CLI tools `webpack` and `webpack-dev-server` look for a default configuration file `webpack.config.js`. Some example projects 

```JavaScript
var config = {};
module.exports = config;

config.src = ...;
config.plugins = [...];

if (require.resolve(...)) {
    config.plugins.push(...);
}
```
