# How to Rails on AWS Lambda

Instead of cloning this repository, this instruction explains step by step how you can configure and deploy Ruby on Rails on AWS Lambda from scratch.

1. Copy and put these files in empty directory (first commit)

   - [.dockerignore](https://github.com/umihico/serverless-rails-demo/blob/master/.dockerignore)
   - [Dockerfile](https://github.com/umihico/serverless-rails-demo/blob/master/Dockerfile)
   - [init.sh](https://github.com/umihico/serverless-rails-demo/blob/master/init.sh)
   - [serverless.yml](https://github.com/umihico/serverless-rails-demo/blob/master/serverless.yml)

2. execute init.sh (2nd commit). `rails new .` get executed inside and defalut Rails files are created.

3. [Download this file](https://raw.githubusercontent.com/aws-samples/serverless-sinatra-sample/71c8e849a619a8fea169e328b93a7434054e86fa/lambda.rb) as handler from official aws-samples (3rd commit)

4. Modify files to adapt Lambda environment. (4th commit)

   - Modify config.ru file location
   - Modify to adapt HTTP API event (original example uses REST API)
   - Use STDOUT for logging, because writing files is not allowed. (except /tmp)
   - Gitignore directory that Serverless Framework generates
   - Record events on cloudwatch. (optional)

5. (Optional) Use welcome page on production. (5th commit)

6. Deploy and visit generated URL! execute `SECRET_KEY_BASE=$(cat tmp/development_secret.txt) sls deploy` (reusing dev secret in this way is lazy and not recommended)
