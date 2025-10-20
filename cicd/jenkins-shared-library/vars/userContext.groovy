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
  return sh(script: "git --no-pager show -s --format='${format}' HEAD", returnStdout: true).trim()
}

def getTriggerUser() {
  private def _id = getUserCause()?.userId ?: null
  private def _name = getUserCause()?.userName ?: null
  private def _email = _id ? Jenkins.instance.getUser(_id)
                              ?.getProperty(hudson.tasks.Mailer.UserProperty)
                              ?.getAddress() ?: null : null

  return new User(id: _id, name: _name, email: _email)
}

def getCommitAuthor() {
  private def _name = getGitCommitInfo("%an") ?: null
  private def _email = getGitCommitInfo("%ae") ?: null

  return new User(id: "GITHUB", name: _name, email: _email)
}

def getSystemUser() {
  private def _email = JenkinsLocationConfiguration.get()?.adminAddress ?: null

  return new User(id: "SYSTEM", name: "SYSTEM", email: _email)
}

def call() {
  return [
    triggerUser: getTriggerUser(),
    commitAuthor: getCommitAuthor(),
    systemUser: getSystemUser()
  ]
}
