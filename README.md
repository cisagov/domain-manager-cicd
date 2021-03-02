# domain-manager-cicd

## Description

CICD repo for domain-manager. Contains terraform for deployments and github actions jobs for building.

## Deployment Process

There are two different repositories for the docker images - [domain-manager-api](https://github.com/cisagov/domain-manager-api) and [domain-manager-ui](https://github.com/cisagov/domain-manager-ui).

The process that occurs for the deployment is on push to one of the repositories for the docker images, it triggers the pipeline to run in this repository. This pipeline will then build/tag/push the docker images to AWS ECR and then run the terraform to deploy the new images to containers in AWS ECS.

This is easiest having everything in a single repository for building and deploying due to Github Actions not supporting multi-repository pipelines very well. If there is multiple repositories that span this deployment process, AWS credentials and various other variables have to be duplicated accross the other repositories. Even with a single CICD repository, this process is still not great because there's not a way to queue up the workflows, so only one workflow is only run at a time, regardless of the amount of triggers that hit it. There is some support for [multi-environment deployments](https://docs.github.com/en/actions/reference/environments), but even these are difficult to setup and there are multiple issues with it.

A better option would be to have a pipeline repository that builds out the deployment pipeline with terraform using something like [AWS CodePipeline](https://docs.aws.amazon.com/codepipeline/latest/userguide/welcome.html) and [AWS CodeBuild](https://docs.aws.amazon.com/codebuild/latest/userguide/welcome.html). AWS CodePipeline has all the features for having an automated CICD Pipeline and could then more easily standardize with CISA skeletons. The issue with this, is now access to the AWS Console would need to be established for approving deployments to environments.

## Contributing

We welcome contributions! Please see [here](CONTRIBUTING.md) for
details.

## License

This project is in the worldwide [public domain](LICENSE).

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain
dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.
