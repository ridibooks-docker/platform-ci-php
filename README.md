# Base Docker Image for CI

[![](https://images.microbadger.com/badges/version/ridibooks/platform-php-ci.svg)](http://microbadger.com/images/ridibooks/platform-php-ci "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/ridibooks/platform-php-ci.svg)](http://microbadger.com/images/ridibooks/platform-php-ci "Get your own version badge on microbadger.com")

## Using on Local Machine with GitLab Runner
1. Build the image:
```bash
PHP_VERSION=[php_version] ./bin/build.sh
```
2. Write `.gitlab-ci.yml` using `ridibooks/platform-php-ci:[php_version]` as a base image in your project.
3. To run CI task on local machine, install [GitLab Runner](https://docs.gitlab.com/runner/install).
4. Run gitlab-runner in the project dir. e.g.:
```bash
gitlab-runner exec docker [task_name] \
  --docker-pull-policy=never \
  --docker-volumes=/var/run/docker.sock:/var/run/docker.sock \
  --env AWS_ACCESS_KEY_ID=aws_access_key_id \
  --env AWS_SECRET_ACCESS_KEY=aws_secret_access_key \
  --env SSH_PRIVATE_KEY="$(cat ~/.ssh/id_rsa)" \
  --env DOCKER_IMAGE=docker_image
```
**Options for `gitlab-runner exec docker`:**
- `--docker-pull-policy=never`: Use local image instead of pulling from remote.
- `--docker-volumes=/var/run/docker.sock:/var/run/docker.sock`: Bind socket to build Docker images within CI container. For more options, see [GitLab's documentation](https://docs.gitlab.com/ee/ci/docker/using_docker_build.html).
- `--env [value] ...`: Pass env variables to CI container.
