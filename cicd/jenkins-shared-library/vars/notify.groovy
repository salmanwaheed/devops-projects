// vars/notify.groovy

private def getUserName() {
  return userContext.triggerUser.name ?: userContext.commitAuthor.name
}

private def getUserEmail() {
  return userContext.triggerUser.email ?: userContext.commitAuthor.email
}

private def buildMessageBody(status) {
  def output = ""
  def details = []

  output += "*Build:* ${env.JOB_NAME} #${env.BUILD_NUMBER}\n"
  output += "*Status:* ${status}\n"
  output += "*User:* ${userName}\n"

  params.each { key, value ->
    if (value != null && !value.isEmpty()) {
      if (key == "Secret_Key") {
        details.add("*${key}:* ${value.take(6)}****\n")
      } else {
        details.add("*${key}:* ${value}\n")
      }
    }
  }

  output += details.join("")
  output += "*Console Output:* <${env.BUILD_URL}console|Click here>\n"

  return output
}

private def buildHtmlMessageBody(status) {
  def output = ""
  def details = []

  output += "<h3>Jenkins Build Notification</h3>"
  output += "<b>Build:</b> ${env.JOB_NAME} #${env.BUILD_NUMBER}<br/>"
  output += "<b>Status:</b> ${status}<br/>"
  output += "<b>User:</b> ${userName}<br/>"

  params.each { key, value ->
    if (value != null && !value.isEmpty()) {
      if (key == "Secret_Key") {
        details.add("<b>${key}:</b> ${value.take(6)}****<br/>")
      } else {
        details.add("<b>${key}:</b> ${value}<br/>")
      }
    }
  }

  output += details.join("")
  output += "<b>Console Output:</b> <a href='${env.BUILD_URL}consoleText'>Click here</a><br/>"
  output += "<p><i>This is an automated notification from Jenkins.</i></p>"

  return output
}

private def sendEmailNotification(status) {
  def buildIcon = [
    "STARTED": "🔵",
    "SUCCESS": "🟢",
    "FAILURE": "🔴",
    "ABORTED": "⚪",
  ][status] ?: "⚙️"

  def body = buildHtmlMessageBody(status)
  def subject = "${buildIcon} Jenkins Build #${env.BUILD_NUMBER} – ${status} (${env.JOB_NAME})"

  emailext(
    mimeType: "text/html",
    replyTo: userContext.systemUser.email,
    from: env.EMAIL_FROM,
    subject: subject,
    to: "${userName} <${userEmail}>",
    body: body
  )
}

private def sendGoogleChatNotification(status) {
  def message = buildMessageBody(status)

  googlechatnotification(
    url: env.GOOGLE_CHAT_URL,
    messageFormat: "simple",
    sameThreadNotification: false,
    message: message
  )
}

private def notifyBuildStatus(status) {
  println("Build ${status} - sending notification")

  // sendGoogleChatNotification(status)
  sendEmailNotification(status)
}

def call(Map args = [:]) {
  if (args.size() != 1) {
    error("Only one notification type allowed at a time. Example: notify start: true")
  }

  def key = args.keySet().first()
  def allowedKeys = ["start", "success", "fail", "abort"]

  if (!allowedKeys.contains(key)) {
    error("Invalid notify option '${key}'. Allowed: ${allowedKeys.join(', ')}")
  }

  def statusMap = [
    start:   "STARTED",
    success: "SUCCESS",
    fail:    "FAILURE",
    abort:   "ABORTED"
  ]

  def status = statusMap[key]
  if (!status) {
    error("Unknown notify status for key '${key}'")
  }

  notifyBuildStatus(status)
}
