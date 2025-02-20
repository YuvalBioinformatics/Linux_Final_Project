#!/bin/bash

# Ensure tasks.csv exists
if [[ ! -f "tasks.csv" ]]; then
    echo "Error: tasks.csv not found!"
    exit 1
fi

# Read CSV and process each line
tail -n +2 tasks.csv | while IFS=',' read -r BUGID DESCRIPTION BRANCH DEV_NAME PRIORITY REPO_PATH GITHUBURL; do

    # Format commit message
    COMMIT_MSG="BugID:$BUGID:$(date '+%Y-%m-%d %H:%M:%S'):Branch:$BRANCH:Dev:$DEV_NAME:Priority:$PRIORITY:Excel Description:$DESCRIPTION"

    # Create branch if it doesn't exist
    git branch | grep -q "$BRANCH" || git checkout -b "$BRANCH"

    # Create dummy file for commit
    touch "bugfix_$BUGID.txt"
    echo "Fixing bug $BUGID - $DESCRIPTION" > "bugfix_$BUGID.txt"

    # Add, commit, and push
    git add "bugfix_$BUGID.txt"
    git commit -m "$COMMIT_MSG"

    # Handle push errors
    if ! git push origin "$BRANCH"; then
        echo "Error: Push failed for branch $BRANCH"
    fi
done

# Store commit history
git log --oneline --graph --all > txt.commits

echo "All commits completed and logged in txt.commits."
