[![wercker status](https://app.wercker.com/status/edb93a3e94114514c178d39a2be1d067/m "wercker status")](https://app.wercker.com/project/bykey/edb93a3e94114514c178d39a2be1d067)

# remotty-notify

Send a message to a [Remotty](https://www.remotty.net/).

### required

* `webhook_url` - Your Remotty Webhook URL

### optional

* `passed_message` - The message which will be shown on a passed build or deploy.
* `failed_message` - The message which will be shown on a failed build or deploy.

Example
--------

Add `WERCKER_REMOTTY_WEBHOOK_URL` as deploy target or application environment variable.


    build:
        after-steps:
            - mahlab/remotty-notify:
                webhook_url: $WERCKER_REMOTTY_WEBHOOK_URL

