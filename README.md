# Introduction

This repo is an example of a setup that deploys a Lambda function when the code changes. It uses `nodemon` under the hood, in combination with a few scripts, so no rocket science.

# Prerequisites

- A lambda function already created. (You can use the console or aws sdk, but I've also included a terraform module in this repo)

# Quickstart

1. Clone/Fork this repo.

2. (Mac) Make sure you have [terminal notifier](https://github.com/julienXX/terminal-notifier)

```
brew install terminal-notifier
```

3. Start

```bash
export PROFILE = your_aws_profile
export FN_NAME = lambda_fn_name

npm start

```

# How it works

We keep a distinct `build` folder so we can prune the node_modules folder before packing the lambda code. Be aware you'll be uploading dependencies that were installed from your local environment. If you need to install them in a similar environment as we have in AWS, you might want to use a [docker image](https://github.com/lambci/docker-lambda) for that step.
