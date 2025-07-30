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

console.log('🚀 Starting development server...');
console.log(`📁 __server__ path: ${serverPath}`);

// Run npm run start:dev in the server directory
const npmRun = spawn('npm', ['run', 'start:dev'], {
    cwd: serverPath,
    stdio: 'inherit', // This will show the server output in real-time
    shell: true
});

npmRun.on('close', (code) => {
    if (code === 0) {
        console.log('👋 Development server stopped');
    } else {
        console.error(`❌ server stopped with exit code ${code}`);
        process.exit(1);
    }
});

npmRun.on('error', (error) => {
    console.error('❌ Error running development server:', error.message);
    console.log('💡 Make sure you have installed dependencies first (run: node install)');
    process.exit(1);
});