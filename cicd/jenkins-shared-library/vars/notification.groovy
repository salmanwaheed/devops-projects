// vars/notify.groovy

import org.yaml.snakeyaml.Yaml

private def getConfigLoader() {
  def yaml = new Yaml()

  return yaml.load(libraryResource("config.yml"))
}

private def getUserInfo() {
  def author = userContext.commitAuthor
  def trigger = userContext.triggerUser

  def name  = trigger?.name ?: author?.name
  def email = author?.email?.toLowerCase()

  // Replace GitHub/personal email with company email if matched
  def cfg = getConfigLoader()
  def emailMap = cfg?.emailMap

  if (emailMap) {
    def matched = emailMap.find { key, value -> email?.contains(key) }
    if (matched) {
      // println("Replacing '${email}' with '${matched.value}'")
      email = matched.value
    }
  }

  // Prefer trigger email (manual builds) over commit author (auto builds)
  email = trigger?.email ?: email

  return [name: name, email: email]
}

private def getBuildDetails() {
  def details = []
  params.each { key, value ->
    if (value != null && !value.isEmpty()) {
      if (key == "Secret_Key") {
        details.add([key: key, value: "${value.take(6)}****"])
      } else {
        details.add([key: key, value: value])
      }
    }
  }
  return details
}

private def formatMessage(status, format = "text") {
  def user = getUserInfo()
  def details = getBuildDetails()

  if (format == "html") {
    def html = ""
    html += "<b>Build No:</b> ${env.BUILD_NUMBER}<br/>"
    html += "<b>Status:</b> ${status}<br/>"
    html += "<b>User:</b> ${user.name}<br/>"
    details.each { html += "<b>${it.key}:</b> ${it.value}<br/>" }
    html += "<b>See full log:</b> <a href='${env.BUILD_URL}consoleText'>Click here</a><br/>"

    if (status == "FAILURE") {
      def logs = '${BUILD_LOG_REGEX, regex="(?i)(error during build|x build failed|error:|exception|failed to solve|exit code: 1|traceback|process .* exit code: [1-9])", maxMatches=50, linesBefore=4, linesAfter=4, escapeHtml=true}'

      html += "<hr>"
      html += "<h2 style='font-family:monospace;font-weight:700;font-size:22px;'>Error Summary:</h2>"
      html += "<pre style='color:#e74c3c;font-family:monospace;font-weight:700;font-size:15px;'>${logs}</pre>"
      html += "<hr>"
    }

    html += "<p><i>This is an automated notification from Jenkins.</i></p>"
    return html
  } else {
    def text = ""
    text += "*Build:* ${env.JOB_NAME} #${env.BUILD_NUMBER}\n"
    text += "*Status:* ${status}\n"
    text += "*User:* ${user.name}\n"
    details.each { text += "*${it.key}:* ${it.value}\n" }
    text += "*See full log:* <${env.BUILD_URL}consoleText|Click here>\n"
    return text
  }
}

private def sendEmailNotification(status) {
  def user = getUserInfo()
  def ccToAdmin = ""
  def adminEmail = userContext.systemUser?.email

  if (adminEmail != user.email) {
    ccToAdmin = ",cc:${userContext.systemUser?.name} <${adminEmail}>"
  }

  emailext(
    mimeType: "text/html",
    replyTo: adminEmail,
    from: env.EMAIL_FROM,
    subject: "Jenkins Build Notification (${env.JOB_NAME})",
    to: "${user.name} <${user.email}>${ccToAdmin}",
    body: formatMessage(status, "html")
  )
}

private def sendGoogleChatNotification(status) {
  googlechatnotification(
    url: env.GOOGLE_CHAT_URL,
    messageFormat: "simple",
    sameThreadNotification: false,
    message: formatMessage(status, "text")
  )
}

private def notifyBuildStatus(String status, boolean chat, boolean email) {
  println("Build ${status} - sending notifications")

  if (chat) sendGoogleChatNotification(status)
  if (email) sendEmailNotification(status)
}

def started(chat = true, email = true) { notifyBuildStatus("STARTED", chat, email) }
def success(chat = true, email = true) { notifyBuildStatus("SUCCESS", chat, email) }
def failure(chat = true, email = true) { notifyBuildStatus("FAILURE", chat, email) }
def aborted(chat = true, email = true) { notifyBuildStatus("ABORTED", chat, email) }
