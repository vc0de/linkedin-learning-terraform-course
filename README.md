This is a practical exercise created in frame of Learning Terraform course from LinkedIn.

# Setup
1) Create AWS environment if it's not available for you yet.
2) Instal AWS CLI
3) Install Terraform CLI
4) Create a user in AWS IAM, provide the user with permissions (for example AdministratorAccess) and save access key in a secured place.
5) Edit ~/.aws/credentials by adding the following lines:
  ```
    [tf_test_course]
    aws_access_key_id=<key_id>
    aws_secret_access_key=<key>
  ```

# Execute
1) Run ```terraform init```
2) Run ```terraform apply```

# Cleanup
1) Run ```terraform destroy```
2) Remove [tf_test_course] section from ~/.aws/credentials
3) Remove the created used from AWS IAM
