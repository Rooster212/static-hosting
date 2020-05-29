#!/bin/sh

AWS_REGION=us-east-1 AWS_PAGER='' aws acm request-certificate \
    --domain-name $1 \
    --validation-method DNS \
    --idempotency-token 987654 \
    --options CertificateTransparencyLoggingPreference=ENABLED