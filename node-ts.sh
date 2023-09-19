#! /usr/bin/bash

# Step 1: Pick project name from $1 or prompt the user to enter it
if [ -z "$1" ]; then
  read -p "Enter project name: " projectName
else
  projectName="$1"
fi

# Step 2: Create project directory
mkdir "$projectName"
cd "$projectName"

# Step 3: Initialize the project and install dependencies
npm init -y
npm i express dotenv
npm i -D ts-node typescript @types/express @types/node nodemon

# Step 4: Create src directory and index.ts file
mkdir src
cat << EOF > src/index.ts
import { config } from "dotenv";
config();
const PORT = process.env?.PORT ?? 8080;

import express from "express";
const app = express();

app.get('/', (req, res) => {
    res.send('Server is live 🍵');
});

app.listen(PORT, () => {
    console.log(\`listening on http://localhost:\${PORT}\`);
});
EOF

# Step 5: Create tsconfig.json file
cat << EOF > tsconfig.json
{
    "compilerOptions": {
        "target": "es2016",
        "module": "commonjs",
        "lib": ["es2016"],
        "typeRoots": ["./node_modules/@types"],
        "outDir": "dist",
        "rootDir": "src",
        "sourceMap": true,
        "strict": true,
        "strictNullChecks": true,
        "strictFunctionTypes": true,
        "strictBindCallApply": true,
        "strictPropertyInitialization": true,
        "alwaysStrict": true,
        "skipLibCheck": true,
        "noImplicitAny": true,
        "esModuleInterop": true,
        "resolveJsonModule": true,
        "forceConsistentCasingInFileNames": true
    },
    "include": ["src/**/*"]
}
EOF

# Step 6: Update package.json
node -e "const pkg = require('./package.json'); delete pkg.description; delete pkg.keywords; delete pkg.author; pkg.main = 'src/index.ts'; pkg.license = 'MIT'; pkg.scripts = { 'start': 'tsc && node dist/index.js', 'dev': 'nodemon src/index.ts', 'build': 'tsc' }; require('fs').writeFileSync('./package.json', JSON.stringify(pkg, null, 4));"

echo "Setup completed successfully!"
