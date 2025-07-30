// build.js
const { exec } = require('child_process');
const path = require('path');

const serverDir = path.join(__dirname, 'server');

console.log('Running build in server...');

exec('npm run build', { cwd: serverDir }, (error, stdout, stderr) => {
    if (error) {
        console.error(`Build failed: ${error.message}`);
        console.error(stderr);
        process.exit(1);
    } else {
        console.log(stdout);
        console.log('Build completed successfully.');
    }
});
