"use strict"
const fs = require('fs');
const mysql = require('mysql2');

const config = {
    host     : 'rc1a-0clsncctrylxxhhs.mdb.yandexcloud.net',
    port     : 3306,
    user     : 'simpleapp-owner',
    password : 'asdf1234',
    database : 'simpleapp',
    ssl: {
        rejectUnauthorized: false,
        ca: fs.readFileSync('/.mysql/root.crt').toString(),
    },
}

const conn = mysql.createConnection(config)
conn.connect(err => {if (err) throw err})
conn.query('SELECT version()', (err, result, fields) => {
    if (err) throw err
    console.log(result[0])
    conn.end()
})