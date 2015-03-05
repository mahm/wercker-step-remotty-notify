#!/bin/bash

if [ ! -n "$WERCKER_REMOTTY_NOTIFY_TOKEN" ]; then
  error 'Please specify the token'
  exit 1
fi

if [ ! -n "$WERCKER_REMOTTY_NOTIFY_ROOM_ID" ]; then
  error 'Please specify your room id'
  exit 1
fi

if [ ! -n "$WERCKER_REMOTTY_NOTIFY_PARTICIPATION_ID" ]; then
  error 'Please specify your participation id'
  exit 1
fi

if [ ! -n "$WERCKER_REMOTTY_NOTIFY_FAILED_MESSAGE" ]; then
  if [ ! -n "$DEPLOY" ]; then
    export WERCKER_REMOTTY_NOTIFY_FAILED_MESSAGE="$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME: <$WERCKER_BUILD_URL|build> of $WERCKER_GIT_BRANCH by $WERCKER_STARTED_BY failed."
  else
    export WERCKER_REMOTTY_NOTIFY_FAILED_MESSAGE="$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME: <$WERCKER_DEPLOY_URL|deploy> of $WERCKER_GIT_BRANCH to $WERCKER_DEPLOYTARGET_NAME by $WERCKER_STARTED_BY failed."
  fi
fi

if [ ! -n "$WERCKER_REMOTTY_NOTIFY_PASSED_MESSAGE" ]; then
  if [ ! -n "$DEPLOY" ]; then
    export WERCKER_REMOTTY_NOTIFY_PASSED_MESSAGE="$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME: <$WERCKER_BUILD_URL|build> of $WERCKER_GIT_BRANCH by $WERCKER_STARTED_BY passed."
  else
    export WERCKER_REMOTTY_NOTIFY_PASSED_MESSAGE="$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME: <$WERCKER_DEPLOY_URL|deploy of $WERCKER_GIT_BRANCH> to $WERCKER_DEPLOYTARGET_NAME by $WERCKER_STARTED_BY passed."
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

RESULT=`curl -s -d "$payload" "https://www.remotty.net/rooms/$WERCKER_REMOTTY_NOTIFY_ROOM_ID/bot/message.json?key=$WERCKER_REMOTTY_NOTIFY_TOKEN&participation_id=$WERCKER_REMOTTY_NOTIFY_PARTICIPATION_ID" --output $WERCKER_STEP_TEMP/result.txt -w "%{http_code}"`

if [ "$RESULT" = "500" ]; then
  fatal <$WERCKER_STEP_TEMP/result.txt
fi

if [ "$RESULT" = "404" ]; then
  error "room_id or token not found."
  exit 1
fi
