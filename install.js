#!/usr/bin/env node

const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');

// Define the server folder path
const serverPath = path.join(__dirname, 'server');

// Check if server folder exists
if (!fs.existsSync(serverPath)) {
    console.error('❌ Error: "server" folder not found in the current directory');
    process.exit(1);
}

// Check if package.json exists in server folder
const packageJsonPath = path.join(serverPath, 'package.json');
if (!fs.existsSync(packageJsonPath)) {
    console.error('❌ Error: package.json not found in the server folder');
    process.exit(1);
}

console.log('📦 Installing dependencies in server folder...');
console.log(`📁 server path: ${serverPath}`);

// Run npm install in the server directory
const npmInstall = spawn('npm', ['install'], {
    cwd: serverPath,
    stdio: 'inherit', // This will show the npm install output in real-time
    shell: true
});

npmInstall.on('close', (code) => {
    if (code === 0) {
        console.log('✅ Dependencies installed successfully!');
    } else {
        console.error(`❌ Installation failed with exit code ${code}`);
        process.exit(1);
    }
});

npmInstall.on('error', (error) => {
    console.error('❌ Error running npm install:', error.message);
    process.exit(1);
});