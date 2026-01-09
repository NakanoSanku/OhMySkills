# Design System Analyzer

A Claude Code skill that extracts design systems from any website using Chrome DevTools MCP.

## Features

- **Deep CSS Extraction**: Extracts keyframes, transitions, CSS variables, and interaction states directly from stylesheets
- **Context-Optimized**: Built-in limits prevent context overflow (max 50 tokens, 10 keyframes, 15 transitions, etc.)
- **Anti-Bot Handling**: Detects Cloudflare/CAPTCHA challenges and guides users through manual verification
- **Template-Driven Output**: Generates structured System Prompts using a consistent design system template

## Directory Structure

```
design-system-analyzer/
├── SKILL.md                 # Main skill definition and workflow
├── README.md                # This file
└── references/
    ├── design-system-template.md   # Output template structure
    ├── analysis-guide.md           # CSS extraction scripts
    └── setup-guide.md              # Chrome remote debugging setup
```

## Usage

Trigger phrases:
- "analyze this site"
- "extract UI style from [URL]"
- "create design system from [URL]"
- "learn visual style"

## Workflow

1. **Navigate** - Opens target URL in Chrome DevTools
2. **Anti-Bot Check** - Detects and handles bot protection
3. **Deep Extraction** - Runs 6 extraction scripts with data limits
4. **Synthesize** - Generates System Prompt using template

**Note**: Screenshots are intentionally disabled to prevent context overflow.

## Data Limits (Context Optimization)

| Extraction Type | Max Items |
|-----------------|-----------|
| CSS Variables | 50 |
| Keyframes | 10 |
| Transitions | 15 |
| Interaction States | 15 |
| Typography Elements | 7 |
| Layout Values | 5 each |

## Requirements

- Chrome DevTools MCP server
- Chrome running with `--remote-debugging-port=9222` (recommended)
