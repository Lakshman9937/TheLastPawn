const querystring = require('querystring');

async function parseBody(req) {
    if (req.body && typeof req.body === 'object') {
        return req.body;
    }

    if (typeof req.body === 'string') {
        try {
            return JSON.parse(req.body);
        } catch {
            return querystring.parse(req.body);
        }
    }

    return new Promise((resolve) => {
        let body = '';
        req.on('data', chunk => { body += chunk; });
        req.on('end', () => {
            if (!body) return resolve({});
            const contentType = (req.headers['content-type'] || '').toLowerCase();
            if (contentType.includes('application/json')) {
                try {
                    resolve(JSON.parse(body));
                } catch {
                    resolve({});
                }
            } else {
                resolve(querystring.parse(body));
            }
        });
    });
}

function sendResponse(req, res, { status = 200, json = null, redirect = null }) {
    if (redirect) {
        // If client requested JSON via fetch (Accept: application/json or x-requested-with)
        const wantsJson = (req.headers['accept'] || '').includes('application/json') ||
                          req.headers['x-requested-with'] === 'XMLHttpRequest';
        if (wantsJson && json) {
            res.statusCode = status;
            res.setHeader('Content-Type', 'application/json; charset=utf-8');
            res.end(JSON.stringify(json));
            return;
        }
        res.statusCode = 302;
        res.setHeader('Location', redirect);
        res.end();
        return;
    }

    res.statusCode = status;
    res.setHeader('Content-Type', 'application/json; charset=utf-8');
    res.end(JSON.stringify(json || {}));
}

module.exports = {
    parseBody,
    sendResponse
};
