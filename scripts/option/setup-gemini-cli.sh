#!/bin/bash

set -eux

echo "Installing gemini-cli..."

npm install -g @google/gemini-cli

# authentication
gemini
