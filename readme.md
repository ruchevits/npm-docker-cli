# NPM Docker CLI

## Usage

#### Building docker image

The following command should be executed from the derectory, which contains `package.json` and `Dockerfile`.

```bash
npm-docker-cli build
```

#### Deploying docker image to EC2 container service

Docker image should be built beforehand.

The following command should be executed from the derectory, which contains `package.json` and `deployment.json`.

```bash
npm-docker-cli deploy
```
