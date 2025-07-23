# Jenkins as Code - Dockerized Setup

This repository provides a fully automated Jenkins setup using:

- Jenkins Configuration as Code (JCasC).
- You can extend this list by editing `plugins.txt`.
- Dockerfile-based image.
- Dark theme + custom branding.
- Optional SSH agent nodes & credentials via YAML.
- Extendable with Job DSL (seed jobs not included yet).

---

## Features

| Feature | Description |
|--------|-------------|
| Security Realm | Local user `salman` with password `123` |
| Authorization  | Logged-in users only |
| Views          | Default + Regex-based views for `prod-*` and `stg-*` jobs |
| Node Monitors  | Disk space, temp space with thresholds |
| Theme          | Dark system theme with custom header |
| Toolchains     | Git + OpenJDK 8 available |
| Labels         | `built-in` label defined |
| Emails         | Admin email set to `salman@example.com` |
| Agent Mode     | Master-only (no agents), agent port disabled (-1) |

---

## Folder Structure

```text
jenkins/
├── Dockerfile        # Jenkins container with preinstalled plugins
├── jenkins.yml       # Configuration-as-Code file (JCasC)
├── plugins.txt       # Plugin list for jenkins-plugin-cli
```

---

## How to Run

```sh
######## without docker-compose
docker build -f Dockerfile -t jenkins-cicd:release $PWD

docker run --name jenkins-app -itd -p 8080:8080 \
  -v jenkins-data:/var/jenkins_home \
  -v ./jenkins.yml:/var/jenkins_home/jenkins.yml \
  jenkins-app:release

docker logs -f jenkins-cicd

######## with docker-compose
docker-compose up -d
docker-compose down -v
docker-compose logs -f jenkins-cicd
```

> This setup disables the setup wizard (`runSetupWizard=false`) and automatically provisions Jenkins from YAML.

---

## Optional: SSH Agent Node Support

Add credentials definition in `jenkins.yml`:

```yaml
credentials:
  system:
    domainCredentials:
      - credentials:
        - basicSSHUserPrivateKey:
            scope: GLOBAL
            id: <node-creds-id>
            description: <node-creds-id> # optional
            username: <node-user>
            usernameSecret: true
            passphrase: null
            privateKeySource:
              directEntry:
                privateKey: ${file:/usr/share/jenkins/secrets.d/<filename>.pem}
```

And agent node definition:

```yaml
jenkins:
  # ....
  nodes:
    - permanent:
        name: <node-name>
        labelString: <node-name>
        nodeDescription: <node-desc>
        remoteFS: /home/<node-user>/jenkins
        retentionStrategy: always
        numExecutors: 1
        launcher:
          ssh:
            host: <node-ip-address>
            port: 22
            credentialsId: <node-creds-id>
            sshHostKeyVerificationStrategy: nonVerifyingKeyVerificationStrategy
            javaPath: /usr/lib/jvm/java-17-openjdk/bin/java
            jvmOptions: -Djava.io.tmpdir=/var/jenkins_home/tmp
```

---

## To Do / Optional Add-ons

- [ ] Add seed job with Job DSL to auto-create pipeline jobs.
- [ ] Mount Job DSL scripts under `jobs/` and run via seed job.
- [ ] Add shared library or webhook-based triggering.
- [ ] Persist secrets securely (e.g., `secrets.d` + Docker volumes).

---

## References

- [Jenkins Configuration as Code Plugin](https://github.com/jenkinsci/configuration-as-code-plugin)
- [Job DSL Plugin](https://github.com/jenkinsci/job-dsl-plugin)
- [jenkinsci/docker](https://github.com/jenkinsci/docker)
