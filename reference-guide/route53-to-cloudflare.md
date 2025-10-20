# Route 53 to Cloudflare DNS Migration Guide

This guide explains how to export your DNS records from AWS Route 53 and import them into Cloudflare using the `cli53` tool.

---

## Step 1: Install `cli53`

Install `cli53` (a CLI tool for working with Route 53):

```sh
wget -O /usr/local/bin/cli53 https://github.com/barnybug/cli53/releases/download/0.8.19/cli53-linux-amd64
sudo chmod +x /usr/local/bin/cli53
cli53 --version
```
> Source: [https://github.com/barnybug/cli53](https://github.com/barnybug/cli53)

---

## Step 2: Export Zone Records from Route 53

Run the following command to export your DNS records in BIND format:

```sh
cli53 export --full <your-domain.com> > bind-zone.txt
```

## Step 3: Why Skip These?
- Cloudflare automatically generates SOA and NS records for your zone.
- Importing these may lead to errors or redundancy.

```sh
# Remove SOA and NS records
grep -vE '\sIN\s(SOA|NS)\s' bind-zone.txt > bind-zone-clean.txt

# Replace AWS ALIAS with CNAME (Tab-safe version)
sed -i 's|AWS[[:space:]]\+ALIAS[[:space:]]\+A|IN\tCNAME|g' bind-zone-clean.txt

# Remove "dualstack." prefix from hostnames
sed -i 's|dualstack\.||g' bind-zone-clean.txt

# Remove Hosted Zone IDs and trailing "true"
sed -i -E 's/ Z[A-Z0-9]+ true$//' bind-zone-clean.txt
```

---

## Step 3: Import Records into Cloudflare

1. Log in to your Cloudflare dashboard.
2. Go to your domain → **DNS** → **Records**.
3. Click **Import and Export**.
4. Upload the `bind-zone-clean.txt` file.

---

## Notes

- Cloudflare supports CNAME flattening at the root domain (e.g., `example.com`) - this replaces the need for AWS ALIAS records when pointing to an ALB.
- After importing, review DNS records to ensure accuracy.
- After confirming the import, update your domain's nameservers at your registrar to use Cloudflare's nameservers.

---

## Done
You're now using Cloudflare as your authoritative DNS provider with records imported from Route 53.
