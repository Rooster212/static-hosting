branchName=`git symbolic-ref --short HEAD`
echo "Creating static hosting for branch" $branchName

aws cloudformation create-stack \
 --region us-east-1 \
 --stack-name $branchName \
 --template-body file://infrastructure.yaml \
 --parameters ParameterKey=BranchName,ParameterValue=$branchName
