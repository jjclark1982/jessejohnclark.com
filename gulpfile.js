var gulp = require("gulp");

gulp.task("default", ["build"]);
gulp.task("develop", ["server", "watch"]);

gulp.task("clean", function(done){
    var del = require("del");
    del(__dirname+'/build', done);
});

gulp.task("build", function(){
    // run the standard metalsmith CLI
    require('metalsmith/bin/metalsmith');
});

gulp.task("watch", function(done){
    // modify the config in memory to include cleaning and auto-reloading
    var config = require('./metalsmith.json');
    config.clean = true;
    config.plugins['metalsmith-watch'] = {
        livereload: true
    };
    config.plugins['metalsmith-publish'].draft = true;
    config.plugins['metalsmith-publish'].future = true;
    delete config.plugins['metalsmith-pdf'];

    // run the standard metalsmith CLI with modified config
    require('metalsmith/bin/metalsmith');
    // done();
});

gulp.task("server", function(ready){
    // run a static web server
    var express = require('express');
    var morgan = require('morgan');
    var injectLR = require('connect-livereload');
    var app = express().use([
        morgan('dev'),
        injectLR({port: 35729}),
        express.static(__dirname+'/build')
    ]);
    var server = app.listen(process.env.PORT || 3000, function(){
        console.log("HTTP server started on port", this.address().port);
        // ready();
    });
});

function runScript(name, args) {
    return function(done){
        var child_process = require("child_process");
        var script = child_process.spawn(name, args || [], {
            stdio: 'inherit'
        });
        script.on("exit", done);
    }
}

gulp.task("publish", runScript("./publish.sh"));
