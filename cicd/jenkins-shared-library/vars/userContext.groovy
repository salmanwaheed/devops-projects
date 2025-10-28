// vars/userContext.groovy
import jenkins.model.*
import hudson.model.*

class User {
  String id
  String name
  String email
}

private def getUserCause() {
  def causes = currentBuild.rawBuild?.getCauses()
  return causes?.find { it instanceof hudson.model.Cause.UserIdCause }
}

private def getGitCommitInfo(String format) {
  def script = """#!/bin/bash
  # set -e

  if [ ! -d .git ]; then
    echo "no-git-repo"
    exit 0
  fi

  # faster (uses log index)
  git --no-pager log -1 --pretty=format:'${format}'

  # slower (reads full commit object)
  # git --no-pager show -s --format='${format}' HEAD
  """

  def result = sh(script: script, returnStdout: true).trim()
  return result == "no-git-repo" ? null : result
}

def getTriggerUser() {
  def _id = getUserCause()?.userId ?: null
  def _name = getUserCause()?.userName ?: null
  def _email = _id ? Jenkins.instance.getUser(_id)
                              ?.getProperty(hudson.tasks.Mailer.UserProperty)
                              ?.getAddress() ?: null : null

  return new User(id: _id, name: _name, email: _email)
}

def getCommitAuthor() {
  def _id = "GITHUB"
  def _name = getGitCommitInfo("%an") ?: null
  def _email = getGitCommitInfo("%ae") ?: null

  return new User(id: _id, name: _name, email: _email)
}

def getSystemUser() {
  def _id = "SYSTEM"
  def _name = "Salman Waheed"
  def _email = JenkinsLocationConfiguration.get()?.adminAddress ?: null

  return new User(id: _id, name: _name, email: _email)
}

def call() {
  return [
    triggerUser: getTriggerUser(),
    commitAuthor: getCommitAuthor(),
    systemUser: getSystemUser()
  ]
}
