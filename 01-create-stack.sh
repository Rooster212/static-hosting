branchName=`git symbolic-ref --short HEAD`
echo "Creating static hosting for branch" $branchName

aws cloudformation deploy \
    --region us-east-1 \
    --stack-name $branchName \
    --template-file infrastructure.yaml --no-fail-on-empty-changeset \
    --parameter-overrides Route53ZoneName=$1 BranchName=$branchName Route53HostedZoneId=$2 CertificateArn=$3