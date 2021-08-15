from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route("/")
def hello():
  return jsonify(message="flask application is running!")

@app.errorhandler(404)
def handle_404_exception(err):
  return jsonify(message=str(err),error=f"{request.path} not found"), 404

@app.errorhandler(500)
def handle_500_exception(err):
  return jsonify(message=str(err),error="Internal Server Error"), 500

if __name__ == "__main__":
  app.run(host="0.0.0.0", port=5000)
