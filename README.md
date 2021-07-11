[![marketplace](https://img.shields.io/badge/marketplace-deploy--to--packagecloud--io-blue?logo=github)](https://github.com/marketplace/actions/deploy-to-packagecloud-io)
[![CI](https://github.com/lpenz/ghaction-packagecloud/actions/workflows/ci.yml/badge.svg)](https://github.com/lpenz/ghaction-packagecloud/actions/workflows/ci.yml)
[![github](https://img.shields.io/github/v/release/lpenz/ghaction-packagecloud?include_prereleases&label=release&logo=github)](https://github.com/lpenz/ghaction-packagecloud/releases)
[![docker](https://img.shields.io/docker/v/lpenz/ghaction-packagecloud?label=release&logo=docker&sort=semver)](https://hub.docker.com/repository/docker/lpenz/ghaction-packagecloud)

# ghaction-packagecloud

**ghaction-packagecloud** is a simple github docker action that
deploys debian packages to [packagecloud.io](https://packagecloud.io).


## Usage

The action runs the following:

```sh
package_cloud push <user>/<repository> <files>
```

- `user` is the packagecloud.io user; it doesn't have to be specified
  is the user is equal to the github user.
- `repository` is the only required parameter; it will usually include
  the OS and version, example: `reponame/ubuntu/precise`. That's
  better documented in https://packagecloud.io/docs#push_pkg
- `files` has the files to upload. Also optional - if not defined, the
  action uses all `.deb` files under the current directory.

Besides these parameters, the `package_cloud` script also needs the
API Token to update the repository. You can get that from
https://packagecloud.io/api_token after logging in. To pass it to the
github action, configure it as a secret in github - you can do that
by going to the repository's page, then going
to *Settings*, *Secrets* - and then pass it using the
`PACKAGECLOUD_TOKEN` environment variable.

Example workflow file:

```yml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - <build debian package>
      - uses: docker://lpenz/ghaction-packagecloud:v0.2
        with:
          repository: lpenz/debian/stretch
        env:
          PACKAGECLOUD_TOKEN: ${{ secrets.PACKAGECLOUD_TOKEN }}
```

For a more complete example, here are some github repositories that use this action:
[execpermfix](https://github.com/lpenz/execpermfix),
[ogle](https://github.com/lpenz/ogle),
[ftpsmartsync](https://github.com/lpenz/ftpsmartsync).


## Inputs

### `user`

packagecloud.io username. Optional, the default is the github user.

### `repository`

packagecloud.io repository. Required.

### `directory`

Enter this directory before pushing. Optional.

Mostly useful when the debian package is created in a subdirectory of
the git repository.

### `files`

.deb files to push.

If not specified, use all .deb files under the current directory. If
none are found, search in all subdirectories.


## Using in other environments

This github action is actually a docker image that can be used locally
or even in [travis-ci](https://travis-ci.com). To do that, first
download the image from
[docker hub](https://hub.docker.com/r/lpenz/ghaction-packagecloud):

```sh
docker pull lpenz/ghaction-packagecloud:v0.2
```

Then, run a container in the project's directory, for instance:

```sh
docker run --rm -t -u "$UID" -w "$PWD" -v "${PWD}:${PWD}" \
  -e INPUT_REPOSITORY=lpenz/debian/stretch \
  -e PACKAGECLOUD_TOKEN \
  lpenz/ghaction-packagecloud:v0.2
```

It's worth pointing out that action parameters are passed as
upper case environment variables, prefixed with `INPUT_`.

The following `.travis.yml` runs the same thing in travis-ci:

```yml
---
language: generic
jobs:
  include:
    - install: docker pull lpenz/ghaction-packagecloud:v0.2
    - script: -<
        docker run --rm -t -u "$UID" -w "$PWD" -v "${PWD}:${PWD}"
          -e INPUT_REPOSITORY=raspbian/debian/stretch
          -e PACKAGECLOUD_TOKEN
          lpenz/ghaction-packagecloud:v0.2
```
