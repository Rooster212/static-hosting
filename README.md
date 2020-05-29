# Static website hosting via CloudFront with automated custom DNS through Route53

# Prerequisites

In my case I've added `aws.jamieroos.dev` as a subdomain hosted zone to Route53.

`jamieroos.dev` is on CloudFlare and has the NS records that Route53 specified for the hosted zone `aws.jamieroos.dev`. This allows Route53 to add subdomains of `aws.jamieroos.dev` but keeps the root domain DNS with CloudFlare.

I also added the root certificate of `aws.jamieroos.dev` to the AWS certificate store to allow for creation of the wildcard subdomain certificate that we'll want to use later on.

```bash
AWS_REGION=us-east-1 AWS_PAGER='' aws acm request-certificate \
    --domain-name aws.rooster212.com --validation-method DNS \
    --idempotency-token 1234 \
    --options CertificateTransparencyLoggingPreference=DISABLED
```

Once that certificate has been created you have to go to the AWS Certificate Store to add the verification record. As the subdomain is on Route53, I can click the button and it'll add the record and verify it:

![cert store image](awscertstore-createrecord.png?raw=true)

I think this step is manual for security reasons. But by verifying the domain with Route53 via Certificate Manager, I was able to create subdomain certificates without having to do the validation again (there is still a propagation/verification time though which is worth bearing in mind, it only took 2-3 minutes in my case)

# Deploy

First you need to create a certificate - this doesn't seem to be possible through CloudFormation yet (or it uses Lambda and custom CloudFormation scripts). In my case I'm using `*.aws.jamieroos.dev`:

```bash
./00-create-certificate.sh *.aws.jamieroos.dev
```

Then existing infra can be created using the `.sh` files, there has been a change though as you'll need to pass through the base domain, cert ARN and hosted zone ID (this can likely be condensed or stored in CI):

```bash
./01-create-stack.sh aws.jamieroos.dev <hostedzoneid> <certarn>
./02-upload-site.sh
```

### Helpful sources

https://github.com/dflook/cloudformation-dns-certificate

https://github.com/awslabs/route53-dynamic-dns-with-lambda/blob/master/route53-ddns.yml

https://github.com/tongueroo/cloudformation-examples/blob/master/templates/instance-and-route53.yml