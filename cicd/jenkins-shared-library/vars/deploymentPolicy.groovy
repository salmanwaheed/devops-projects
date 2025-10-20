// vars/deploymentPolicy.groovy
import java.util.TimeZone
import groovy.json.JsonSlurper
import groovy.transform.Field

@Field START_TIME = env.DEPLOY_RESTRICTION_START as int // 10:45
@Field END_TIME = env.DEPLOY_RESTRICTION_END as int // 12:00

def isUserAllowed() {
  def user = userContext.triggerUser.id
  def deployers = new JsonSlurper().parseText(env.AUTHORIZED_DEPLOYERS) // '[u1, u2, u3]'
  return deployers.any { user?.contains(it) && params.Secret_Key == env.AUTHORIZED_DEPLOYER_TOKEN }
}

def isDeploymentAllowed() {
  def tz = TimeZone.getTimeZone("Asia/Dubai")
  def time = new Date().format("HHmm", tz) as int
  return time < START_TIME || time > END_TIME
}

def abortDeployment(reason) {
  currentBuild.result = "ABORTED"
  error(reason)
}

def intToTimeString(int timeInt) {
  int hours = timeInt / 100
  int minutes = timeInt % 100
  return String.format("%02d:%02d", hours, minutes)
}

def call() {
  if (!isUserAllowed()) {
    if (!isDeploymentAllowed()) {
      abortDeployment("Deployment aborted: not allowed between ${intToTimeString(START_TIME)} AM and ${intToTimeString(END_TIME)} PM UAE time.")
    } else {
      println "Deployment allowed outside restricted window."
    }
  } else {
    println "User is allowed, skipping deployment restriction!"
  }
}
