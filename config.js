const fs = require('fs');
const path = require('path');


function generateBaseUrl() {
    return 'http://ec2-3-107-113-31.ap-southeast-2.compute.amazonaws.com:3432/api';
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
        const baseUrl = generateBaseUrl();

        // Generate the Dart configuration file
        generateDartConfig(baseUrl);
    } catch (error) {
        console.error('Error generating base URL configuration:', error);
    }
}

// Run the script
main();