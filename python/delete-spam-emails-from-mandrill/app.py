import requests

# https://mailchimp.com/developer/transactional/api/rejects
# curl -X GET "https://mandrillapp.com/api/1.0/rejects/list" -H "content-type: application/json" -d '{"key": ""}'

API_KEY = ""
BASE_URL = "https://mandrillapp.com/api/1.0/rejects"
REASON = ["spam", "unsub"]

timeout = 30
data = {"key": API_KEY}
headers = {"content-type": "application/json"}

resp = requests.get(f"{BASE_URL}/list", json=data, headers=headers, timeout=timeout)
emails = resp.json()

for x in emails:
  if x.get("reason") in REASON:
    email = x['email']
    print(f"Removing spam email: {email}")
    data.update({"email": email})
    requests.post(f"{BASE_URL}/delete", json=data, headers=headers, timeout=timeout)
