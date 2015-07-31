#!/bin/bash

if [ ! -n "$WERCKER_REMOTTY_WEBHOOK_URL" ]; then
  error 'Please specify the webhook_url'
  exit 1
fi

if [ ! -n "$WERCKER_REMOTTY_NOTIFY_FAILED_MESSAGE" ]; then
  if [ ! -n "$DEPLOY" ]; then
    export WERCKER_REMOTTY_NOTIFY_FAILED_MESSAGE="[label:danger:Failed] **$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME**: [build of $WERCKER_GIT_BRANCH by $WERCKER_STARTED_BY]($WERCKER_BUILD_URL)"
  else
    export WERCKER_REMOTTY_NOTIFY_FAILED_MESSAGE="[label:danger:Failed] **$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME**: [deploy of $WERCKER_GIT_BRANCH by $WERCKER_STARTED_BY]($WERCKER_DEPLOY_URL)"
  fi
fi

if [ ! -n "$WERCKER_REMOTTY_NOTIFY_PASSED_MESSAGE" ]; then
  if [ ! -n "$DEPLOY" ]; then
    export WERCKER_REMOTTY_NOTIFY_PASSED_MESSAGE="[label:success:Passed] **$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME**: [build of $WERCKER_GIT_BRANCH to $WERCKER_DEPLOYTARGET_NAME by $WERCKER_STARTED_BY]($WERCKER_BUILD_URL)"
  else
    export WERCKER_REMOTTY_NOTIFY_PASSED_MESSAGE="[label:success:Deployed] **$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME**: [deploy of $WERCKER_GIT_BRANCH to $WERCKER_DEPLOYTARGET_NAME by $WERCKER_STARTED_BY]($WERCKER_DEPLOY_URL)"
  fi
fi

if [ "$WERCKER_RESULT" = "passed" ]; then
  export WERCKER_REMOTTY_NOTIFY_MESSAGE="$WERCKER_REMOTTY_NOTIFY_PASSED_MESSAGE"
else
  export WERCKER_REMOTTY_NOTIFY_MESSAGE="$WERCKER_REMOTTY_NOTIFY_FAILED_MESSAGE"
fi

if [ "$WERCKER_REMOTTY_NOTIFY_ON" = "failed" ]; then
  if [ "$WERCKER_RESULT" = "passed" ]; then
    echo "Skipping.."
    return 0
  fi
fi

payload="message=$WERCKER_REMOTTY_NOTIFY_MESSAGE"

RESULT=`curl -s -d "$payload" "$WERCKER_REMOTTY_WEBHOOK_URL" --output $WERCKER_STEP_TEMP/result.txt -w "%{http_code}"`

if [ "$RESULT" = "500" ]; then
  fatal <$WERCKER_STEP_TEMP/result.txt
fi

if [ "$RESULT" = "404" ]; then
  error "room_id or token not found."
  exit 1
fi
