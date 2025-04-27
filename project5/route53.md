🧠 What is Route 53?
Amazon Route 53 is AWS's DNS service.

DNS = Domain Name System.

DNS is like the internet’s phone book.

It matches names (like google.com) to numbers (IP addresses like 142.250.190.14).

Without DNS, you would have to type IP addresses everywhere instead of domain names.

Route 53 helps you create and manage DNS records for your domains.

🛠️ How Route 53 Works (Simplified)

# Setting Up a Domain with Route 53

| Step | What Happens                                                                                    | Example                                                                                        |
| :--: | :---------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------- |
|  1   | You get a domain.                                                                               | `yourcoolsite.com`                                                                             |
|  2   | You create a Hosted Zone in Route 53.                                                           | Think of this like a "folder" where you manage all DNS records for that domain.                |
|  3   | You add DNS records inside the Hosted Zone.                                                     | Like saying "when people go to `app.yourcoolsite.com`, send them to `12.34.56.78` (your EC2)." |
|  4   | When someone types your domain in a browser, DNS looks up the IP and connects them to your EC2. | User types `app.yourcoolsite.com` → Browser finds your EC2 server.                             |

🔥 Key Route 53 Things You Need to Know for Your Project

# DNS Terms Cheat Sheet

## Term | What it Means | Example
--- | --- | ---
**Hosted Zone** | Where all your DNS records live for a domain. | `yourcoolsite.com` zone.
**Record Set (DNS Record)** | A rule inside a zone that maps a name to something (like an IP address). | A Record: `app.yourcoolsite.com → 12.34.56.78`.
**A Record** | DNS record that points a domain to an IP address (IPv4). | Directs traffic to your EC2 public IP.
**TTL (Time to Live)** | How long browsers should "cache" the DNS lookup. | Usually 300 seconds (5 minutes).

---

## 🔥 Why It's Useful

- ✅ You can use pretty domain names instead of ugly IP addresses.
- ✅ If you change servers, you can just update the IP in Route 53 — no need to tell users.
- ✅ You can connect EC2 instances, Load Balancers, S3 buckets, CloudFront, etc.


🌎 Visual Example

User's Browser → DNS Resolver → Route 53 Hosted Zone → Gets EC2 Public IP → Connects to Your Server

🛠️ How This Relates to Your Terraform Project
Terraform creates an EC2 (your server).

Terraform finds your Hosted Zone (your domain's "home" in Route 53).

Terraform adds an A record that says "this domain points to that EC2's IP."

Done! Now people typing app.yourcooldomain.com will go to your EC2.
