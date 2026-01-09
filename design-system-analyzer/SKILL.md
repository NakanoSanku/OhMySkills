---
name: design-system-analyzer
description: Analyze any website's UI style using ChromeDevTools to extract precise CSS tokens, animations, and interaction states. Handles complex sites and anti-bot measures by guiding the user. Triggers on "analyze this site", "extract UI style", "create design system from [URL]", or "learn visual style".
---
# Design System Analyzer

Analyze websites via ChromeDevTools to extract deep CSS logic (keyframes, transitions, tokens) and generate comprehensive Design System System Prompts.

## Best Practice: Use Your Own Chrome

For the best experience (no CAPTCHAs, shared login cookies), advise the user to run Chrome with:
`chrome.exe --remote-debugging-port=9222`
(See **[references/setup-guide.md](references/setup-guide.md)** for details)

## Workflow

1. **Navigate & Verify** → Handle Cloudflare/Anti-bot checks
2. **Deep Extraction** → Extract CSSOM data (Animations, Interactions, Tokens)
3. **Visual Capture** → Screenshots for verification only
4. **Synthesize** → Generate System Prompt from raw CSS data

## Step 1: Navigate & Anti-Bot Check

```
mcp__chrome-devtools__navigate_page (url: "<target-url>")
```

**CRITICAL**: After navigation, immediately check for bot challenges.

```javascript
() => {
  const text = document.body.innerText.toLowerCase();
  const title = document.title.toLowerCase();
  if (text.includes('cloudflare') || text.includes('verify you are human') || title.includes('just a moment')) {
    return 'CHALLENGE_DETECTED';
  }
  return 'OK';
}
```

**IF CHALLENGE_DETECTED**:

1. **PAUSE**.
2. Tell the user: "Cloudflare/Bot protection detected. For a smoother experience, please try running your own Chrome with remote debugging enabled (see setup-guide.md)."
3. Ask user to manually solve the CAPTCHA in the currently open browser window.
4. Only proceed after user confirmation.

## Step 2: Deep CSS Extraction

Use scripts from `references/analysis-guide.md` to extract the "Source of Truth".

**1. Extract Animations & Keyframes**
(See "Deep Animation & Transition Extractor" in analysis-guide.md)

**2. Extract Interaction States (:hover/:focus)**
(See "Interaction State Extractor" in analysis-guide.md)

**3. Extract Design Tokens (Variables)**
(See "Variable & Token Extractor" in analysis-guide.md)

## Step 3: Visual Context & Tech Stack

**Fingerprint the Stack**:

```javascript
() => {
  return {
    isTailwind: !!document.querySelector('.text-center'),
    isReact: !!Object.keys(window).find(k => k.startsWith('__react')),
    isVue: !!document.querySelector('[data-v-app]')
  };
}
```

**Take Screenshots**:

```
mcp__chrome-devtools__take_screenshot (_: true)
mcp__chrome-devtools__take_screenshot (_: true, fullPage: true)
```

## Step 4: Analysis & Synthesis

Synthesize the extracted data into the Design System Template.

| Data Source                     | Template Section                                 |
| ------------------------------- | ------------------------------------------------ |
| **CSS Variables**         | `Design Token System` (Colors/Spacing)         |
| **Keyframes/Transitions** | `Animation & Motion` (Exact curves/durations)  |
| **:hover/:focus Rules**   | `Interactive Elements` & `Component Styling` |
| **Computed Styles**       | `Typography` & `Layout Principles`           |
| **Visual Observations**   | `Vibe`, `Signature Elements`                 |

## Resources

- **[references/design-system-template.md](references/design-system-template.md)**: The output template
- **[references/analysis-guide.md](references/analysis-guide.md)**: Deep extraction scripts
- **[references/setup-guide.md](references/setup-guide.md)**: Guide for reusing user's Chrome
