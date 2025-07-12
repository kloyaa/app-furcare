# Project Setup Guide

## Prerequisites

- Node.js (v16 or higher)
- npm (comes with Node.js)

## Project Structure

```
project-root/
├── __server__/
│   ├── src/
│   │   └── index.ts
│   ├── package.json
│   └── ...
├── install.js
├── run.js
└── README.md
```

## Getting Started

### Running the Server

1. **Install dependencies**
   ```bash
   node install
   ```
   This will install all required dependencies in the server folder.

2. **Start the development server**
   ```bash
   node run
   ```
   This will start the server in development mode with nodemon and ts-node for automatic reloading.

### Development Notes

- The server runs with nodemon, so it will automatically restart when you make changes to your TypeScript files
- Press `Ctrl+C` to stop the development server
- Make sure to run `node install` first before running `node run`

## Scripts

- `install.js` - Installs npm dependencies in the server folder
- `run.js` - Runs the development server with hot reloading

## Troubleshooting

- If you get "command not found" errors, make sure you're in the project root directory
- If the server fails to start, ensure all dependencies are installed by running `node install`
- Check that your `server/package.json` has the correct `start:dev` script configuration