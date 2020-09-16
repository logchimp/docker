#!/bin/bash

set -e

# Run backend in background
sh ./server/backend.sh & 

# Run frontend in foreground
sh ./frontend/frontend.sh
