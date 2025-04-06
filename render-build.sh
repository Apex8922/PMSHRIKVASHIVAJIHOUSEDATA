#!/usr/bin/env bash
# exit on error
set -o errexit

echo "============================================="
echo "Starting Render build process..."
echo "============================================="

# Print Node.js and npm versions
echo "Node.js version: $(node -v)"
echo "npm version: $(npm -v)"

# Install dependencies
echo "Installing dependencies..."
npm ci || npm install

# Build the application
echo "Building application..."
npm run build

# Check if build was successful by looking for dist/index.js
if [ -f "dist/index.js" ]; then
  echo "✓ Build successful - dist/index.js exists"
  echo "First few lines of dist/index.js:"
  head -n 5 dist/index.js
else
  echo "✗ Build FAILED - dist/index.js not found"
  echo "Contents of dist directory:"
  ls -la dist/
  exit 1
fi

# Run the database setup script with NODE_OPTIONS for ESM compatibility
echo "Setting up database..."
NODE_OPTIONS="--experimental-modules --no-warnings" node scripts/setup-db.js || {
  echo "Database setup failed, but continuing build..."
}

echo "============================================="
echo "Build process completed successfully!"
echo "Start server with: node start.cjs"
echo "============================================="