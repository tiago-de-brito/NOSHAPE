const sql = require('mssql/msnodesqlv8');

const config = {
    connectionString: 'Driver={ODBC Driver 17 for SQL Server};Server=localhost;Database=noshape;Trusted_Connection=Yes;',
    driver: 'msnodesqlv8'
};

module.exports = { sql, config };
