- The example_custom_resource is the same as the one published at
- The adapted_custom_resource is clone from the above, then changed for the Lambda function and output
- The stack was created using something like:

$ aws --profile foo cloudformation create-stack --stack-name get-epoch-time --template-body file://`pwd`/adapted_custom_resource.json --capabilities CAPABILITY_IAM
