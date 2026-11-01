const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require('url');

const PORT = process.env.PORT || 5500;
const ROOT = __dirname;

const MIME_TYPES = {
    '.html': 'text/html; charset=utf-8',
    '.css':  'text/css; charset=utf-8',
    '.js':   'application/javascript; charset=utf-8',
    '.json': 'application/json; charset=utf-8',
    '.png':  'image/png',
    '.jpg':  'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.gif':  'image/gif',
    '.svg':  'image/svg+xml',
    '.ico':  'image/x-icon',
    '.pdf':  'application/pdf',
    '.woff2':'font/woff2',
    '.woff': 'font/woff'
};

// Route mapping for APIs and Servlets
const API_ROUTES = {
    '/api/login': './api/login.js',
    '/loginservlet': './api/login.js',
    '/api/logout': './api/logout.js',
    '/logoutservlet': './api/logout.js',
    '/api/register': './api/register.js',
    '/registerservlet': './api/register.js',
    '/api/contact': './api/contact.js',
    '/contactservlet': './api/contact.js',
    '/api/challenge': './api/challenge.js',
    '/challengeservlet': './api/challenge.js',
    '/api/courses': './api/courses.js',
    '/admin/courseservlet': './api/courses.js',
    '/api/puzzles': './api/puzzles.js',
    '/admin/puzzleservlet': './api/puzzles.js',
    '/api/leaderboard': './api/leaderboard.js',
    '/api/admin': './api/admin.js'
};

const server = http.createServer(async (req, res) => {
    const parsedUrl = new URL(req.url, `http://${req.headers.host || 'localhost:5500'}`);
    let pathname = decodeURIComponent(parsedUrl.pathname);

    // Normalize lowercase path for routing lookup
    const lowerPath = pathname.toLowerCase().replace(/\/+$/, '');

    // 1. Check API Route
    if (API_ROUTES[lowerPath]) {
        try {
            const modPath = path.resolve(__dirname, API_ROUTES[lowerPath]);
            delete require.cache[modPath];
            const handler = require(modPath);
            return await handler(req, res);
        } catch (err) {
            console.error(`Error in API route ${pathname}:`, err);
            res.statusCode = 500;
            res.setHeader('Content-Type', 'application/json');
            res.end(JSON.stringify({ success: false, error: 'Internal Server Error' }));
            return;
        }
    }

    // 2. Protect Admin Static Pages
    if (lowerPath.startsWith('/admin') && !lowerPath.includes('/css') && !lowerPath.includes('/images')) {
        const { getSessionUser } = require('./lib/auth');
        const user = getSessionUser(req);
        if (!user || !user.isAdmin) {
            res.statusCode = 302;
            res.setHeader('Location', '/login.html?error=Admin+access+required');
            res.end();
            return;
        }
    }

    // 3. Check Static Files
    if (pathname === '/') {
        pathname = '/index.html';
    }

    let filePath = path.join(ROOT, pathname.replace(/^\/+/, ''));

    // Check if clean URL without extension maps to an .html file
    if (!path.extname(filePath) && fs.existsSync(filePath + '.html')) {
        filePath = filePath + '.html';
    }

    // Check if directory index exists
    if (fs.existsSync(filePath) && fs.statSync(filePath).isDirectory()) {
        const indexFile = path.join(filePath, 'index.html');
        if (fs.existsSync(indexFile)) {
            filePath = indexFile;
        }
    }

    fs.stat(filePath, (err, stats) => {
        if (err || !stats.isFile()) {
            res.statusCode = 404;
            res.setHeader('Content-Type', 'text/html; charset=utf-8');
            res.end('<h1>404 Not Found</h1><p>The requested URL was not found on this server.</p>');
            return;
        }

        const ext = path.extname(filePath).toLowerCase();
        const contentType = MIME_TYPES[ext] || 'application/octet-stream';

        res.statusCode = 200;
        res.setHeader('Content-Type', contentType);
        res.setHeader('Cache-Control', 'no-cache');

        const stream = fs.createReadStream(filePath);
        stream.pipe(res);
    });
});

server.listen(PORT, () => {
    console.log(`The Last Pawn server active on http://localhost:${PORT}`);
});
