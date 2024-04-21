#!/bin/bash

# Define Variables
NAMESPACE="your_namespace"
DEPLOYMENT_NAME="swype-app"
MAX_RESTARTS=3

# Start an infinite loop
while true; do
    # Get the current number of restarts for the pod
    CURRENT_RESTARTS=$(kubectl get pods -n $NAMESPACE -l component=$DEPLOYMENT_NAME -o jsonpath='{.items[*].status.containerStatuses[*].restartCount}')

    # Display the restart count
    echo "Current restart count: $CURRENT_RESTARTS"

    # Check if the restart count exceeds the maximum allowed restarts
    if [[ $CURRENT_RESTARTS -gt $MAX_RESTARTS ]]; then
        echo "Restart limit exceeded, scaling down the deployment..."
        # Scale down the deployment
        kubectl scale deployment/$DEPLOYMENT_NAME --replicas=0 -n $NAMESPACE
        # Break the loop
        break
    fi

    # Pause for 60 seconds
    sleep 60
done

echo "Deployment has been scaled down due to multiple restart attempts"
