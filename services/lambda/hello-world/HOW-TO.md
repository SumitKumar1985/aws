- Remember to replace placeholders designated by <angle brackets> in any configuration files checked in here

```
$ npm init
$ npm install -g grunt-cli
$ npm install grunt --save-dev
$ npm install grunt-aws-lambda --save-dev
```

- Create a Gruntfile (Gruntfile.js) with the Grunt tasks
- Create your lambda function (in index.js)
- Create your test event (in event.json)
- Create .npmignore, add "dist" to it

```
grunt lambda_invoke
grunt lambda_package
```

- Create the lambda function:

```
$ aws lambda create-function --function-name hello-world \
	--runtime nodejs \
	--role arn:aws:iam::<ACCOUNT_ID>:role/lambda_basic_execution \
	--handler index.handler \
	--zip-file fileb:///my/filesystem/path/to/dist/code.zip
$ grunt lambda_deploy # once you have setup options in Gruntfile for the deploy task
```
