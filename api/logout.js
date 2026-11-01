const { clearSessionCookie } = require('../lib/auth');
const { sendResponse } = require('../lib/helpers');

module.exports = async function handler(req, res) {
    clearSessionCookie(res);
    return sendResponse(req, res, {
        status: 200,
        redirect: '/login.html?logout=true',
        json: { success: true, message: 'Logged out successfully' }
    });
};
