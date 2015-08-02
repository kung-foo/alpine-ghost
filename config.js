// # Ghost Configuration
// Setup your Ghost install for various environments
// Documentation can be found at http://support.ghost.org/config/

var path = require('path'),
    url = require('url'),
    config;

var get_db = function() {
    if (process.env.GHOST_STORE === undefined || process.env.GHOST_STORE == 'sqlite3') {
        return {
            client: 'sqlite3',
            connection: {
                filename: path.join(__dirname, '/user-content/data/ghost.db')
            },
            debug: false
        };
    }

    if (process.env.GHOST_STORE == 'postgres') {
        // TODO: DB_PORT comes from docker-compose
        var uri = url.parse(process.env.DB_PORT);
        return {
            client: 'postgres',
            connection: {
                host: uri.hostname,
                port: uri.port,
                user: process.env.POSTGRES_USER,
                password: process.env.POSTGRES_PASSWORD,
                database: process.env.POSTGRES_DB,
            },
            debug: false
        };
    }
};

config = {
    production: {
        url: 'http://' + (process.env.SITE_HOST_NAME || 'localhost'),
        mail: {},
        database: get_db(),
        server: {
            // Host to be passed to node's `net.Server#listen()`
            host: '0.0.0.0',
            port: '2368'
        }
    }
};

// Export config
module.exports = config;
