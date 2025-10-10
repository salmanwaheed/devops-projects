from collections import Counter

emails = [
  "one@example.com",
  "two@example.com",
  "three@example.com",
  "one@example.com",
  "five@example.com",
  "five@example.com",
  "ten@example.com",
  "two@example.com",
  "two@example.com",
  "two@example.com",
]

# --- Find duplicates ---
counter = Counter(emails)
find_dup = {email: count for email, count in counter.items() if count > 1 }

# --- Drop duplicates (keep one copy, preserve order) ---
drop_dup = list(dict.fromkeys(emails))

print("Duplicates: ", find_dup)
print("Unique: ", drop_dup)
