const { exec } = require('child_process');
const path = require('path');

const serverDir = path.join(__dirname, 'server');

console.log('Running format in server...');

exec('npm run format', { cwd: serverDir }, (error, stdout, stderr) => {
    if (error) {
        console.error(`format failed: ${error.message}`);
        console.error(stderr);
        process.exit(1);
    } else {
        console.log(stdout);
        console.log('format completed successfully.');
    }
});
