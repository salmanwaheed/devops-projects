// vars/log.groovy

def info(String msg) {
  echo "[INFO] ${msg}"
}

def warn(String msg) {
  echo "[WARN] ${msg}"
}

def err(String msg) {
  error "[ERROR] ${msg}"
}
