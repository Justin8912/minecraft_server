read -p "Enter your IAM User's access key id: " AWS_ACCESS_KEY_ID
read -p "Enter your IAM User's secret access key id: " AWS_SECRET_ACCESS_KEY

export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}

export stuff=$(aws sts get-session-token --duration-seconds 3600 --output json)
echo ${stuff}
echo "$stuff" | jq -r ".AccessKeyId"