branchName = `git symbolic-ref --short HEAD`
echo "Waiting for static hosting to be created for branch" $branchName
aws cloudformation stack-create-complete --stack-name $branchName

echo "Getting bucketName from CloudFormation stack..."
bucketName=`aws cloudformation describe-stacks --stack-name $branchName --query "Stacks[0].Outputs[?OutputKey=='BucketName'].OutputValue" --output text`
echo "Syncing content to" $bucketName
aws s3 sync ./dist s3://$bucketName
echo "Getting Website URL from CloudFormation stack..."
url=`aws cloudformation describe-stacks --stack-name $branchName --query "Stacks[0].Outputs[?OutputKey=='WebsiteCloudfront'].OutputValue" --output text`
echo "Website accessible at" $url