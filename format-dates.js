var moment = require("moment");

module.exports = function(options) {
    return function(files, metalsmith, done) {
        metalsmith._metadata.moment = moment;
        metalsmith._metadata.formatDate = function(date, format) {
            return moment(date).format(format || "LL");
        }
        done();
    }
}
