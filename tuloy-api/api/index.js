// Vercel serverless function: every request is rewritten here (see vercel.json); `nest build` makes dist/.
module.exports = require('../dist/serverless').handler;
