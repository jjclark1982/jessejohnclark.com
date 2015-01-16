var moment = require("moment");

module.exports = function(options) {
    return function(files, metalsmith, done) {
        metalsmith.metadata().moment = moment;
        metalsmith.metadata().formatDate = function(date, format) {
            return moment(date).format(format || "LL");
        }
        for (var file in files) {
            if (files[file].date) {
                files[file].date = new Date(files[file].date);
            }
        }
        done();
    }
}
