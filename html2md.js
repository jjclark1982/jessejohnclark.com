#!/usr/bin/env node

// usage: for F in contents/posterous-import/*.html; do ./html2md.js < $F > ${F}.md && rm $F; done
// find contents/posterous-import -name '*.html' |\
// sed 's/\(.*\)\.html/.\/html2md.js < \1.html > \1.md \&\& rm \1.html/' |\
// sh -x

var split = require('split');
var moment = require('moment');

var metadata = {
    collection: "posts",
    template: "post.jade"
};
var metadataMatchers = {
    'title': /<h3>(.*)<\/h3>/i,
    'author': /<span class='author'>&nbsp;by (.*)<\/span>/i,
    'date': /<span class='post_time'>(.*)<\/span>/i,
    'tag': /<h1>(.*)<\/h1>/i,
    // 'img': /<img src='.*?([^\/]*)'>/,
    'content': /(.*)/
}

var lines = process.stdin.pipe(split());
lines.on('data', function (line){
    for (var field in metadataMatchers) {
        var match = line.match(metadataMatchers[field]);
        if (match) {
            metadata[field] = (metadata[field] || '') + match[1] + "\n";
            break;
        }
    }
});
lines.on('end', function(){
    var content = metadata.content;
    delete metadata.content;

    var img = metadata.img;
    delete metadata.img;

    metadata.date = moment(metadata.date).toDate()

    process.stdout.write("---\n");
    for (var field in metadata) {
        process.stdout.write(field + ': ' + metadata[field].toString().trim() + "\n");
    }
    // process.stdout.write(JSON.stringify(metadata));
    process.stdout.write("---\n\n");
    if (img) {
        process.stdout.write("<img src='/posterous-import/"+img.trim()+"'>\n");
    }

    process.stdout.write(content);
});
