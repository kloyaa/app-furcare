#!/bin/bash

# === CONFIGURATION ===
SOURCE_DIR="app"
TEMP_DIR="/tmp/repo2-push"
TARGET_BRANCH="main"  # Change if needed
TARGET_REMOTE="https://github.com/kloyaa/furcare-dev.git"  # <-- update this!

# === GENERATE COMMIT MESSAGE ===
CURRENT_DATE=$(date +"%m-%d-%Y")
COMMIT_MESSAGE="Release: DEV $CURRENT_DATE"

# === CLEANUP OLD TEMP ===
echo "🧹 Cleaning old temp dir..."
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"

# === COPY CONTENT ===
echo "📂 Copying files from $SOURCE_DIR to temp dir..."
cp -r "$SOURCE_DIR"/. "$TEMP_DIR"

# === INIT & COMMIT ===
cd "$TEMP_DIR" || { echo "❌ Failed to access $TEMP_DIR"; exit 1; }

echo "🔧 Initializing Git repo..."
git init

echo "🔗 Adding remote origin: $TARGET_REMOTE"
git remote add origin "$TARGET_REMOTE"

echo "🌿 Creating branch: $TARGET_BRANCH"
git checkout -b "$TARGET_BRANCH"

echo "➕ Adding files..."
git add .

echo "📝 Committing changes with message: $COMMIT_MESSAGE"
git commit -m "$COMMIT_MESSAGE"

echo "🚀 Pushing to $TARGET_REMOTE"
git push --force origin "$TARGET_BRANCH"

echo "✅ Done! Pushed contents of $SOURCE_DIR to $TARGET_REMOTE:$TARGET_BRANCH"
echo "📋 Commit message used: $COMMIT_MESSAGE"