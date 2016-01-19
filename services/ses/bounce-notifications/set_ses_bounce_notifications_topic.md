
Responding to bounces when sending email through SES
---

- For a sender identity in SES, setup bounce notifications to be sent to an SNS topic
- Subscribe the SNS topic to a queue in SQS to receive the notifications and act upon the same

- Identity, topic, and queue information

```
IDENTITY="test-outbound-01@example.com"
BOUNCE_NOTIFICATIONS_TOPIC_NAME="bounces_test-outbound-01_notifications"
RECEIVE_BOUNCE_NOTIFICATIONS_QUEUE="queue-receive-ses-bounce-notifications"
```

- Create the topic, set it as the identity notification topic for bounce

```
TOPIC_ARN=$(aws sns create-topic --name ${BOUNCE_NOTIFICATIONS_TOPIC_NAME})
aws ses set-identity-notification-topic \
  --identity ${IDENTITY} \
  --notification-type Bounce \
  --sns-topic ${TOPIC_ARN}
```

- Create the queue

```
QUEUE_URL=$(aws sqs create-queue --queue-name ${RECEIVE_BOUNCE_NOTIFICATIONS_QUEUE} | awk '{print $NF}')
QUEUE_ARN=$(aws sqs get-queue-attributes --queue-url ${QUEUE_URL} --attribute-names QueueArn | awk '{print $NF}')
```

- [Subscribe the SQS queue to the SNS topic](http://docs.aws.amazon.com/sns/latest/dg/SendMessageToSQS.html)

- [Use the SES sandbox simulator email addresses](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/mailbox-simulator.html) to simulate a bounce: bounce@simulator.amazonses.com

- Transcript of [SMTP sending session](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/send-email-smtp-client-command-line.html) follows:

```
$ openssl s_client -crlf -quiet -connect email-smtp.us-west-2.amazonaws.com:465
depth=1 /C=US/O=Symantec Corporation/OU=Symantec Trust Network/CN=Symantec Class 3 Secure Server CA - G4
verify error:num=20:unable to get local issuer certificate
verify return:0
220 email-smtp.amazonaws.com ESMTP SimpleEmailService-1207632523 y2Oa45vvJsvVLIhnE1VO
EHLO krishnan-laptop.krishnanm.com
250-email-smtp.amazonaws.com
250-8BITMIME
250-SIZE 10485760
250-AUTH PLAIN LOGIN
250 Ok
AUTH LOGIN
334 VXNlcm5hbWU6
[Use Base64-encoded SMTP Username HERE]
334 UGFzc3dvcmQ6
[Use Base64-encoded SMTP Password HERE]
235 Authentication successful.
MAIL FROM:test-outbound-01@krishnanm.com
250 Ok
RCPT TO:bounce@simulator.amazonses.com
250 Ok
DATA
354 End data with <CR><LF>.<CR><LF>
Subject: Simulating bounce with SES

This is testing using the SES sandbox
.
250 Ok 000001525bc9993c-d9fafe39-c492-4750-bc4b-e402083c0503-000000
QUIT
221 Bye
```

- See "example_bounce_notification_message.txt" checked in for the message received on the SQS queue after the above sending attempt