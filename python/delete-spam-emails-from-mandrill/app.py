import requests

API_KEY = ""
BASE_URL = "https://mandrillapp.com/api/1.0/rejects"
REASON = ["spam", "unsub"]

data = {
  "key": API_KEY
}

resp = requests.get(f"{BASE_URL}/list.json", json=data)
emails = resp.json()

for x in emails:
  if x.get("reason") in REASON:
    email = x['email']
    print(f"Removing spam email: {email}")
    data.update({"email": email})
    requests.post(f"{BASE_URL}/delete.json", json=data)
