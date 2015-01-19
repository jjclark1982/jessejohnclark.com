---
title: Dynamically-generated Cakefile Tasks
date: 2015-01-19
template: post.jade
collection: posts
author: Jesse Clark
---

[Cake](http://coffeescript.org/documentation/docs/cake.html) is a task-runner for [CoffeeScript](http://coffeescript.org/).

It can be useful to invoke external scripts from `cake`, if they are written in another language or simply don't fit in the `Cakefile`. Suppose we have a `scripts` directory populated with various text-based executables, and we want to automatically define a `cake` task for each of those scripts, with an appropriate description, like so:

```
$ ls scripts
build.py
clean.sh

$ cake
cake build                    # build the project
cake clean                    # remove built files

$ cake build --help
build.py: usage info...
```

We can do this in the `Cakefile` by reading each script and extracting its  first comment, then defining a task with that comment as its description:

```CoffeeScript
# Define tasks for any scripts in the `scripts` directory
for basename in fs.readdirSync('./scripts') then do (basename)->
    return if basename[0] is '.'
    filename = "./scripts/#{basename}"
    contents = fs.readFileSync(filename, 'utf8')
    title = basename.replace(/\..*?$/, '')
    # use the first block comment in the file as its description
    description = ''
    for line, i in contents.split(/[\r\n]+/)
        if line.match(/^#!/) then continue
        if line.match(/-\*- mode/) then continue
        if line.match(/^\s*(#|\/\/|$)/)
            description += line.replace(/^\s*(#|\/\/)\s*/, ' ').trim()
            continue
        # stop reading when we encounter non-comment text
        break

    task(title, description, ->
        # pass command-line arguments directly in to the script
        index = process.argv.indexOf(title)
        args = process.argv.slice(index+1)
        child_process.spawn(filename, args, {
            stdio: 'inherit'
            env: env
        }).on('exit', (code, signal)->
            process.exit(code)
        )
        # prevent `cake` from invoking further tasks based on those arguments
        global.invoke = (->)
    )
```
