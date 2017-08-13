module.exports = {
    test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/, 
    loader: "url-loader?limit=10000&mimetype=application/font-woff"
};