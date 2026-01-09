# Setup Guide: Reusing Your Own Chrome

To avoid Cloudflare/Bot checks and share your login sessions (cookies), you should configure the Chrome DevTools MCP server to connect to your existing Chrome instance instead of launching a new one.

## 1. Close All Chrome Instances

**IMPORTANT**: You must completely exit Chrome first. Ensure no background processes are running.

## 2. Launch Chrome in Debug Mode

Run the following command in your terminal (PowerShell/Terminal) to start Chrome with a remote debugging port:

### Windows

```powershell
& "C:\Program Files\Google\Chrome\Application\chrome.exe" --remote-debugging-port=9222
```

*(Verify your Chrome path if different)*

### macOS

```bash
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222
```

### Linux

```bash
google-chrome --remote-debugging-port=9222
```

## 3. Verify Connection

Open `http://localhost:9222/json` in your browser. If you see a JSON response, Chrome is ready.

## 4. MCP Server Behavior

Most Chrome DevTools MCP servers are configured to try connecting to `localhost:9222` first.

- If they find an existing Chrome on port 9222, they **attach** to it.
- If they don't, they **launch** a new headless instance.

By keeping your specific Chrome window open (started with the command above), the skill will automatically "see" what you see and use your credentials.

## Why do this?

- **No CAPTCHAs**: You are already verified as a human.
- **Logged In**: Access pages behind login walls without handling auth scripts.
- **Extensions**: Use your existing color pickers or dev tools alongside the AI.
