# OhMySkills

A curated collection of Claude Code skills for enhanced development workflows.

## Overview

OhMySkills provides powerful, production-ready skills for Claude Code that extend its capabilities across various development tasks. Each skill is carefully crafted to integrate seamlessly with your development workflow.

## Available Skills

### 🎨 Design Style Skill

Automatically retrieves design system prompts to create visually distinctive, production-grade frontend code with 30+ specific design styles.

> **Note**: Design system prompts are sourced from [designprompts.dev](https://designprompts.dev) - a curated collection of high-quality design system templates.

### 🔍 Design System Analyzer Skill

Analyze any website's UI style using ChromeDevTools to extract precise CSS tokens, animations, and interaction states. Generates comprehensive Design System Prompts from live websites.

**Key Features:**

- Deep CSS extraction (keyframes, transitions, tokens)
- Interaction state analysis (:hover, :focus, etc.)
- Design token extraction (CSS variables, colors, spacing)
- Tech stack fingerprinting (React, Vue, Tailwind detection)
- Anti-bot/Cloudflare handling with user guidance
- Generates complete Design System Prompts

**Example Usage:**

```
"Analyze this site: https://example.com"
"Extract UI style from https://dribbble.com"
"Create design system from this URL"
"Learn visual style from https://stripe.com"
```

**Requirements:**

- Chrome DevTools MCP server
- Recommended: Run Chrome with `--remote-debugging-port=9222` for best experience

[View Full Documentation →](./design-system-analyzer/SKILL.md)

**Design Systems Include:**

- **Modern**: Modern Dark, SaaS, Material, Claymorphism, Neumorphism
- **Minimal**: Swiss, Bauhaus, Flat Design, Monochrome, Minimal Dark
- **Creative**: Neo-brutalism, Bold Typography, Maximalism, Sketch, Playful Geometric
- **Professional**: Enterprise, Professional
- **Elegant**: Luxury, Art Deco, Academia
- **Tech**: Terminal CLI, Web3, Cyberpunk
- **Organic**: Botanical, Organic
- **Nostalgic**: Retro, Vaporwave
- **Editorial**: Newsprint
- **Dynamic**: Kinetic
- **Raw**: Industrial

**Key Features:**

- 30+ production-ready design systems
- Automatic style detection from user intent
- Framework-agnostic (React, Vue, Next.js, etc.)
- Detailed design tokens (colors, typography, spacing)
- Component patterns and implementation examples
- Anti-pattern guidelines to maintain authenticity

**Example Usage:**

```
"Create a landing page with neo-brutalist design"
"Build a SaaS dashboard with modern dark theme"
"Add a contact form with cyberpunk aesthetic"
"Design a portfolio with Swiss minimalism"
```

[View Full Documentation →](./design-style/SKILL.md)

## Installation

### From Marketplace (Recommended)

1. In Claude Code, run the command:

   ```
   /plugin
   ```

2. Navigate to **Marketplaces**
3. Click **Add Marketplace**
4. Enter the repository URL:

   ```
   git@github.com:NakanoSanku/OhMySkills.git
   ```

   Or use Github:

   ```
   NakanoSanku/OhMySkills
   ```

   Or more...

5. Browse and select the skills you want to install
6. Install selected skills - they will be immediately available in your Claude Code sessions

### Manual Installation

If you prefer to install manually:

1. Clone this repository:

```bash
git clone https://github.com/NakanoSanku/OhMySkills.git
cd OhMySkills
```

2. Link the plugin directory to Claude Code:

```bash
cc --plugin-dir /path/to/OhMySkills/.claude-plugin
```

### Using Specific Skills in Settings

To configure skills in your `.claude/settings.json`:

```json
{
  "plugins": ["/path/to/OhMySkills/.claude-plugin"]
}
```

## Usage

Once installed, skills are automatically available in your Claude Code sessions. Simply describe what you want to build, and Claude will invoke the appropriate skill:

**Frontend Development:**

```
User: "Build a landing page with modern dark aesthetic"
Claude: [Automatically invokes design-style skill with ModernDark design system]
```

**Component Creation:**

```
User: "Create a contact form with neo-brutalist style"
Claude: [Applies Neo-brutalism design patterns and tokens]
```

## Project Structure

```
OhMySkills/
├── .claude-plugin/
│   └── marketplace.json     # Marketplace configuration
├── design-style/            # Design Style Skill
│   ├── SKILL.md            # Skill definition
│   ├── prompts/            # 30+ design system prompts (from designprompts.dev)
│   ├── styles-mapping.json # Style metadata
│   ├── reference.md        # Design reference
│   └── scripts/            # Utility scripts
├── design-system-analyzer/  # Design System Analyzer Skill
│   ├── SKILL.md            # Skill definition
│   └── references/         # Analysis guides and templates
│       ├── analysis-guide.md
│       ├── design-system-template.md
│       └── setup-guide.md
└── README.md               # This file
```

## Contributing

We welcome contributions! To add a new skill or improve existing ones:

1. Fork this repository
2. Create a feature branch (`git checkout -b feature/new-skill`)
3. Follow the Claude Code skill development standards
4. Submit a pull request

### Skill Development Guidelines

- Follow the official [Claude Code plugin development guide](https://github.com/anthropics/claude-code/tree/main/plugins/plugin-dev)
- Use YAML frontmatter in `SKILL.md` files
- Include clear trigger phrases in skill descriptions
- Provide comprehensive documentation
- Test skills in clean environments

## License

MIT License - See [LICENSE](./LICENSE) file for details.

## Links

- **Repository**: https://github.com/NakanoSanku/OhMySkills
- **Issues**: https://github.com/NakanoSanku/OhMySkills/issues
- **Claude Code**: https://claude.com/claude-code

## Acknowledgments

- Built with [Claude Code](https://claude.com/claude-code) - Anthropic's official CLI for Claude
- Design system prompts powered by [designprompts.dev](https://designprompts.dev) - Production-ready design system templates

---

**Made with ❤️ by OhMySkills**
