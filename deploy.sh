#!/bin/bash
# Deployment script for HelloWorld application

APP_DIR="/opt/hello-world-java"
APP_NAME="hello-world"

echo "Stopping existing application..."
pkill -f "java.*$APP_NAME" || true

echo "Extracting new version..."
tar -xzf /tmp/hello-world.tar.gz -C $APP_DIR
rm -f /tmp/hello-world.tar.gz

echo "Setting permissions..."
chmod +x $APP_DIR/run.sh

echo "Starting application..."
cd $APP_DIR
nohup ./run.sh > app.log 2>&1 &

echo "Waiting for application to start..."
sleep 3

if pgrep -f "java.*$APP_NAME" > /dev/null; then
    echo "Application deployed successfully!"
    echo "Current status:"
    ps aux | grep -v grep | grep java
    echo "Last few lines of log:"
    tail -n 5 app.log
else
    echo "Application failed to start!"
    echo "Checking logs:"
    cat app.log
    exit 1
fi
