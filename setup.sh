# Initialize a new Node.js project
npm init

# Install TypeScript as a development dependency
npm install --save-dev typescript

# Initialize TypeScript configuration
npx tsc --init

# Install Express and its TypeScript types
npm install express
npm install --save-dev @types/express

# Create src directory and server.ts file
mkdir src && touch src/server.ts

# Create a .env file and add environment variables
touch .env
echo "MONGO_CONNECTION=mongodb+srv://Bonolo:5TUY33rwFVLgFcDQ@cluster0.m4txywz.mongodb.net/?retryWrites=true&w=majority
PORT=5000" >> .env

# Install necessary npm packages
npm i dotenv
npm i mongoose
npm i envalid

# Create directories and files
mkdir src/util && touch src/util/validateEnv.ts
echo 'import { cleanEnv, port, str } from "envalid";

// Validate and clean environment variables using envalid
export default cleanEnv(process.env, {
    MONGO_CONNECTION: str(),
    PORT: port(),
});' >> src/util/validateEnv.ts

# Create an Express app file
touch src/app.ts
echo '
import "dotenv/config";
import express from "express";

const app = express();

// Define a simple route
app.get("/", (req, res) => {
    res.send("Hello, World!");
});

export default app;' >> src/app.ts

# Create a server file with MongoDB connection and app start logic
echo '
import mongoose from "mongoose";
import app from "./app";
import env from "./util/validateEnv";

const port = env.PORT;

// Connect to MongoDB and start the server
mongoose.connect(env.MONGO_CONNECTION).then(
    () => {
        console.log("Mongoose connected");
        app.listen(port, () => {
            console.log("Server running on port: " + port);
        });
    }).catch(console.error);' >> src/server.ts

# Create a directory for models
mkdir src/models

# Create dist directory
mkdir dist

# Update tsconfig.json to set the output directory to dist
sed -i 's#//\?\s*"outDir":\s*"\./",#"outDir": "./dist",#' tsconfig.json

# Install nodemon and ts-node as development dependencies
npm install --save-dev nodemon
npm install --save-dev ts-node

# Update package.json to add a start script using nodemon
cat package.json | \
  sed 's#\("scripts": {\)#\1\n    "start": "nodemon src/server.ts",#' > tmpfile && \
  mv tmpfile package.json

# Update package.json to point to the compiled TypeScript file
cat package.json | \
  sed 's/\("main": \)".*"/\1"dist\/server.js"/' > tmpfile && \
  mv tmpfile package.json

# Install ESLint and initialize ESLint configuration
npm i -D eslint
npx eslint --init

# Run ESLint on TypeScript files
npx eslint . --ext .ts

# Add "lint" script to package.json
cat package.json | \
  sed '/"scripts": {/a\ \ \ \ "lint": "eslint --ext .ts .",' > tmpfile && \
  mv tmpfile package.json

# Create .gitignore file
touch .gitignore
echo "# Logs
logs
.log
npm-debug.log
yarn-debug.log*
yarn-error.log*
lerna-debug.log*
.pnpm-debug.log*
# Diagnostic reports (https://nodejs.org/api/report.html)
report.[0-9].[0-9].[0-9].[0-9].json
# Runtime data
pids
*.pid
*.seed
*.pid.lock
# Directory for instrumented libs generated by jscoverage/JSCover
lib-cov
# Coverage directory used by tools like istanbul
coverage
*.lcov
# nyc test coverage
.nyc_output
# Grunt intermediate storage (https://gruntjs.com/creating-plugins#storing-task-files)
.grunt
# Bower dependency directory (https://bower.io/)
bower_components
# node-waf configuration
.lock-wscript
# Compiled binary addons (https://nodejs.org/api/addons.html)
build/Release
# Dependency directories
node_modules/
jspm_packages/
# Snowpack dependency directory (https://snowpack.dev/)
web_modules/
# TypeScript cache
*.tsbuildinfo
# Optional npm cache directory
.npm
# Optional eslint cache
.eslintcache
# Optional stylelint cache
.stylelintcache
# Microbundle cache
.rpt2_cache/
.rts2_cache_cjs/
.rts2_cache_es/
.rts2_cache_umd/
# Optional REPL history
.node_repl_history
# Output of 'npm pack'
.tgz
# Yarn Integrity file
.yarn-integrity
# dotenv environment variable files
.env
.env.development.local
.env.test.local
.env.production.local
.env.local
# parcel-bundler cache (https://parceljs.org/)
.cache
.parcel-cache
# Next.js build output
.next
out
# Nuxt.js build / generate output
.nuxt
dist
# Gatsby files
.cache/
# Comment in the public line in if your project uses Gatsby and not Next.js
# https://nextjs.org/blog/next-9-1#public-directory-support
# public
# vuepress build output
.vuepress/dist
# vuepress v2.x temp and cache directory
.temp
.cache
# Docusaurus cache and generated files
.docusaurus
# Serverless directories
.serverless/
# FuseBox cache
.fusebox/
# DynamoDB Local files
.dynamodb/
# TernJS port file
.tern-port
# Stores VSCode versions used for testing VSCode extensions
.vscode-test
# yarn v2
.yarn/cache
.yarn/unplugged
.yarn/build-state.yml
.yarn/install-state.gz
.pnp.
" > .gitignore

# Start the application
npm start
