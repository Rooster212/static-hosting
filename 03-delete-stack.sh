branchName=`git symbolic-ref --short HEAD`
echo "Deleting static hosting for branch" $branchName

echo "Deleting all items in the S3 bucket"
bucketName=`aws cloudformation describe-stacks --stack-name $branchName --query "Stacks[0].Outputs[?OutputKey=='BucketName'].OutputValue" --output text --region us-east-1`
aws s3 rm s3://$bucketName/doc --recursive --region us-east-1

echo "Deleting CloudFormation stack"
aws cloudformation delete-stack --stack-name $branchName --region us-east-1