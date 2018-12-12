const express = require('express')
const app = express()

app.get('/', (req, res) => {

  // Spawn child process
  const path = require('path');
  const finer_cmd = path.resolve(__dirname, 'finer/finnish-nertag');
  const spawn = require('child_process').spawn;
  const proc = spawn(finer_cmd, {
    cwd: 'finer',
    stdio: [
      'pipe', // Use parent's stdin for child
      'pipe', // Pipe child's stdout to parent
      'pipe'
    ]
  })

  // Read text from query params
  const text = req.query.text

  // Write query text to child input
  proc.stdin.setEncoding('utf-8');
  proc.stdin.write(text);
  proc.stdin.end();

  // Initialize result
  var result = '';

  // Append data to result
  proc.stdout.on('data', (data) => {
    result = `${data}`;
  });

  // Output result
  proc.on('close', (code) => {
    console.log(`child process exited with code ${code}`);
	res.setHeader('Content-Type', 'text/plain');
    res.send(result);
  });
})

app.listen(3000, () => console.log('FiNER web service listening on port 3000'))
