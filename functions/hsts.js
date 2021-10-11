function handler(event) {
    //Get contents of response
    const response = event.request;
    const headers = response.headers;

    // Set HTTP security headers
    // Since JavaScript doesn't allow for hyphens in variable names, we use the dict["key"] notation 
    headers['strict-transport-security'] = {
        value: 'max-age=63072000; includeSubdomains; preload'
    };
    headers['content-security-policy'] = {
        value: "default-src 'none'; img-src 'self'; script-src 'self'; style-src 'self'; object-src 'none'"
    };
    headers['x-content-type-options'] = {
        value: 'nosniff'
    };
    headers['x-frame-options'] = {
        value: 'DENY'
    };
    headers['x-xss-protection'] = {
        value: '1; mode=block'
    };

    //Return modified response
    if (event.request.uri.endsWith('.gz')) {
        headers['content-encoding'] = [{
            key: 'Content-Encoding',
            value: 'gzip'
        }];
    }
    return response;
};