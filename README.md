# remotty-notify

Send a message to a [Remotty](https://www.remotty.net/).

### required

* `token` - Your Remotty Key
* `room_id` - Your Room ID
* `participation_id` - Your Participation ID

### optional

* `passed_message` - The message which will be shown on a passed build or deploy.
* `failed_message` - The message which will be shown on a failed build or deploy.

Example
--------

Add `REMOTTY_TOKEN` as deploy target or application environment variable.


    build:
        after-steps:
            - mahm/remotty-notify:
                token: $REMOTTY_TOKEN
                room_id: 1
                participation_id: 10

