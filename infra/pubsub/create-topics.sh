#!/bin/sh
set -e
BASE="http://${PUBSUB_HOST}/v1/projects/${PUBSUB_PROJECT_ID}"

until curl -s "http://${PUBSUB_HOST}" > /dev/null; do
  echo "Waiting for Pub/Sub emulator..."
  sleep 2
done

for topic in sensor-readings anomalies; do
  curl -s -X PUT "${BASE}/topics/${topic}" > /dev/null
done

curl -s -X PUT "${BASE}/subscriptions/analysis-sensor-readings" \
  -H "Content-Type: application/json" \
  -d "{\"topic\":\"projects/${PUBSUB_PROJECT_ID}/topics/sensor-readings\"}" > /dev/null

curl -s -X PUT "${BASE}/subscriptions/alarm-anomalies" \
  -H "Content-Type: application/json" \
  -d "{\"topic\":\"projects/${PUBSUB_PROJECT_ID}/topics/anomalies\"}" > /dev/null

echo "Pub/Sub topics and subscriptions created."
