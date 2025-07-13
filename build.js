// build.js
const { exec } = require('child_process');
const path = require('path');

const serverDir = path.join(__dirname, '__server__');

console.log('Running build in __server__...');

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
