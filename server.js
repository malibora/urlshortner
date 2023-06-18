const express = require('express');
const mysql = require('mysql2');
const crypto = require('crypto');
//const bodyParser = require('body-parser');
const fs = require('fs');

const app = express();
const port = 80;

const config = {
  host     : 'rc1a-0clsncctrylxxhhs.mdb.yandexcloud.net',
  port     : 3306,
  user     : 'simpleapp-owner',
  password : process.env.DB_PASS,
  database : 'simpleapp',
  ssl: {
      rejectUnauthorized: false,
      ca: fs.readFileSync('/.mysql/root.crt').toString(),
  },
}
// Middleware to parse JSON bodies
//app.use(bodyParser.json());
app.get('/', async (req, res) => {
  try {
    fs.readFile('./index.html', (err, data)=>{
      res.status(200).write(data)
      res.end()
    }
    )
  } catch (error) {
    res.status(500).send(error);
  }
});
// GET method for shortening URLs
app.get('/shorten', (req, res) => {
  const url = req.query.url;

  // Generate a hash of the URL
  const hash = crypto.createHash('md5').update(url).digest('hex');


  const conn = mysql.createConnection(config)
  conn.connect(err => {if (err) throw err})


  const sql = 'INSERT INTO urls (hash, url) VALUES (?, ?)';
  const values = [hash, url];

  conn.query(sql, values, (error) => {

    if (error) {
      console.error('Error storing URL in database: ', error);
      res.status(500).send('Internal Server Error');
      return;
    }

    // Return the shortened URL
   // const shortenedUrl = `${hash}`;
    res.send(hash);
    conn.end()
  });
  });

// GET method for redirecting to the original URL
app.get('/:hash', (req, res) => {
  const hash = req.params.hash;

  const conn = mysql.createConnection(config)
  conn.connect(err => {if (err) throw err})


    const sql = 'SELECT url FROM urls WHERE hash = ?';
    const values = [hash];

    conn.query(sql, values, (error, results) => {
      

      if (error) {
        console.error('Error fetching URL from database: ', error);
        res.status(500).send('Internal Server Error');
        return;
      }

      if (results.length === 0) {
        res.status(404).send('Not Found');
        return;
      }

      const originalUrl = results[0].url;
      conn.end()
      res.redirect(originalUrl);
    });
  });

// Start the server
app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});