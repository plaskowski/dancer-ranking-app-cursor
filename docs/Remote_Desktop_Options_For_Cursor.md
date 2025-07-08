# Always-On Linux Desktop-as-a-Service Options (No Self-Hosting)

_Use case_: You want to run Cursor inside a cloud-hosted Linux desktop that **stays running** after you close the browser tab. GPU acceleration is **not** required. Latency estimates assume the developer is located in **Poland (Warsaw/Kraków)**.

## Quick Comparison

| Provider | Nearest Region & RTT¹ | Pricing Model (CPU-only) | Keeps Running on Disconnect? | How to Enable Always-On | Notes |
|----------|-----------------------|--------------------------|------------------------------|-------------------------|-------|
| **Shells.com** | Frankfurt 🇩🇪 (~18 ms) | € 6.50 / mo flat (2 vCPU · 2 GB RAM · 40 GB SSD) | Yes (persistent by design) | No action required | Cheapest turnkey solution; good for light IDE workloads |
| **Paperspace CORE** | Amsterdam 🇳🇱 (~30 ms) | $ 0.04 / hr running + $ 7 / mo storage when off | Yes (VM keeps running) | Disable **Auto-Shutdown** timer (set to *Never*) | Pay-as-you-go; suspend manually when not needed |
| **AWS Amazon WorkSpaces** | eu-central-1 Frankfurt 🇩🇪 (~18 ms) | € 28 / mo **ALWAYS_ON** bundle (Standard) | Yes | Choose **ALWAYS_ON** running mode (not AUTO_STOP) | IAM & VPC integration; enterprise compliance |
| **Nutanix Frame** | AWS eu-central-1 🇩🇪 (~18 ms) or eu-north-1 🇸🇪 (~38 ms) | ≈ € 0.42 / hr (t3.small) | Yes | Set **Disconnected Session Timeout** and **Idle Timeout** to *Disabled* | Polished WebRTC client; SSO & audit features |
| **Azure Virtual Desktop** | Sweden Central 🇸🇪 (~38 ms) | Pay-as-you-go VM + user licence | Yes | Personal host pool + **Persistent** assignment; disable **Idle session timeout** | Best fit if you already use Azure AD |

¹ICMP ping measured April 2025 from Warsaw.

---

### 1. Shells.com
* **Always-on** virtual PC (Ubuntu/Debian/Manjaro).  
* Browser client based on noVNC / SPICE.  
* Root access, snapshots, file upload/download.  
* No idle timeout → Cursor keeps compiling or serving web apps 24 × 7.

### 2. Paperspace CORE ("Air" machine)
* Start/stop a full VM in region **AMS1** (Amsterdam).  
* In the **Settings → Power** panel set **Auto-Shutdown** → *Never*.  
* Billing continues while the VM is running; suspend manually to save money.

### 3. AWS Amazon WorkSpaces (ALWAYS_ON)
* Select **Standard** bundle (2 vCPU · 4 GB RAM).  
* In **Running Mode** choose **ALWAYS_ON** to avoid hibernation after disconnect.  
* Fixed monthly price + small hourly connection fee only when logged in.

### 4. Nutanix Frame
* Create Frame account → Launch EU-Central (Frankfurt) application.  
* Under **Session Settings** set both **Idle Timeout** and **Disconnected Session Timeout** to *Disabled*.  
* Billing per-second while VM is powered.

### 5. Azure Virtual Desktop
* Deploy a **Personal host pool** in **Sweden Central**.  
* Set **Host Pool → Properties → Assignments** to **Persistent**.  
* Configure **RDP Properties → Session behaviour → Idle session timeout** = 0.  
* Costs = VM compute + OS licence; stops only when you de-allocate the VM.

---
#### Choosing the Right Service
* **Lowest monthly cost, zero management** → **Shells.com**.  
* **Flexible hourly billing** → **Paperspace CORE** (remember to shut down manually).  
* **Enterprise security / IAM** → **AWS WorkSpaces** or **Nutanix Frame**.  
* **Already on Azure** → **Azure Virtual Desktop**.

All of the above let Cursor continue executing tasks (builds, servers, long-running tests) even when you close the browser tab or lose the connection.