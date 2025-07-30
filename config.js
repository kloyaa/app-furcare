const os = require('os');
const fs = require('fs');
const path = require('path');

function getLocalIPAddress() {
    // Get all network interfaces
    const networkInterfaces = os.networkInterfaces();

    // Iterate through interfaces to find a suitable IP
    for (const interfaceName in networkInterfaces) {
        const interfaces = networkInterfaces[interfaceName];

        for (const face of interfaces) {
            // Skip loopback and non-IPv4 addresses
            if (!face.internal && face.family === 'IPv4') {
                return face.address;
            }
        }
    }

    // Fallback to localhost
    return '127.0.0.1';
}

function parseCommandLineArgs() {
    const args = process.argv.slice(2);
    const config = {};

    args.forEach(arg => {
        if (arg.startsWith('--env=')) {
            config.env = arg.split('=')[1];
        }
    });

    return config;
}

function generateBaseUrl(ip, env) {
    if (env === 'dev') {
        return 'http://ec2-3-107-113-31.ap-southeast-2.compute.amazonaws.com:3432';
    }
    return `http://${ip}:3432/api`;
}

function generateDartConfig(baseUrl) {
    const dartConfig = `
    // AUTO-GENERATED FILE - DO NOT EDIT MANUALLY
    class AppConfig {
        static const String generatedBaseUrl = '${baseUrl}';
        static const String accessKeyValue = 'v7pb6wylg4m0xf0kx5zzoved';
        static const String secretKeyValue = 'glrvdwi46mq00fg1oqtdx3rg';
    }
`;

    // Ensure the directory exists
    const configDir = path.resolve(__dirname, '__app__/lib/core/constants/');
    fs.mkdirSync(configDir, { recursive: true });

    // Write the Dart configuration file
    const configPath = path.resolve(configDir, '___generated.dart');
    fs.writeFileSync(configPath, dartConfig);

    console.log(`Generated base URL: ${baseUrl}`);
    console.log(`Configuration saved to: ${configPath}`);
}

function main() {
    try {
        // Parse command line arguments
        const args = parseCommandLineArgs();

        // Get the local IP address
        const localIp = getLocalIPAddress();

        // Generate the base URL based on environment
        const baseUrl = generateBaseUrl(localIp, args.env);

        // Generate the Dart configuration file
        generateDartConfig(baseUrl);
    } catch (error) {
        console.error('Error generating base URL configuration:', error);
    }
}

// Run the script
main();