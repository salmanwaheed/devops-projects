// pipelineJob('node-app') {
//   definition {
//     cpsScm {
//       scm {
//         git {
//           remote {
//             url('https://github.com/salmanwaheed/node-app.git')
//           }
//           branches('*/release')
//         }
//       }
//       scriptPath('Jenkinsfile')
//     }
//   }
// }

// import jenkins.model.*
// import javaposse.jobdsl.plugin.*
// import javaposse.jobdsl.plugin.actions.*

// println "[Groovy Init] Creating pipeline job..."

// def jobDslScript = '''
// pipelineJob("my-auto-pipeline") {
//   definition {
//     cps {
//       script("""
//         pipeline {
//           agent any
//           stages {
//             stage("Hello") {
//               steps {
//                 echo "Hello from Job DSL Pipeline!"
//               }
//             }
//           }
//         }
//       """.stripIndent())
//       sandbox()
//     }
//   }
// }
// '''

// def jobDslSeed = new ExecuteDslScripts()
// jobDslSeed.setScriptText(jobDslScript)
// jobDslSeed.setUseScriptText(true)
// jobDslSeed.setRemovedJobAction(RemovedJobAction.IGNORE)
// jobDslSeed.run()

// println "[Groovy Init] Pipeline job created successfully."
