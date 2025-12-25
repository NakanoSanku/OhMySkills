# Design Style Skill - Reference Guide

## Implementation Workflow

### 1. Initial Assessment Phase

When a user requests frontend work, gather this information:

**Tech Stack Questions:**
- "What framework are you using?" (React, Vue, Next.js, Svelte, etc.)
- "Are you using Tailwind CSS, or another CSS framework?"
- "Do you have an existing component library?" (shadcn/ui, MUI, etc.)

**Design Preference Questions:**
- "Do you have a specific design style in mind?"
- "What's the vibe you're going for?" (professional, creative, minimal, bold, etc.)
- "Who is the target audience?" (developers, consumers, enterprises, etc.)

**Scope Questions:**
- "Is this a single component, a page, or a full application?"
- "Do you want to refactor existing code, or build something new?"

### 2. Style Selection Logic

Use this decision tree to select the appropriate design system:

```
IF user mentions specific style:
  → Map to exact prompt (case-insensitive)
  → neo-brutalism/brutalist → Neo-brutalism.md
  → modern/contemporary → ModernDark.md
  → minimal/minimalist → Swiss.md or FlatDesign.md
  → etc.

ELSE IF user describes vibe:
  → "professional" → Professional.md or Enterprise.md
  → "creative/artistic" → Neo-brutalism.md or BoldTypography.md
  → "tech/developer tool" → ModernDark.md or TerminalCLI.md
  → "luxury/premium" → Luxury.md or ArtDeco.md
  → "fun/playful" → PlayfulGeometric.md or Claymorphism.md
  → "corporate" → Enterprise.md
  → "crypto/web3" → Web3.md or Cyberpunk.md

ELSE IF user provides no preference:
  → Default to ModernDark.md (safe, versatile choice)
  → OR ask user: "I have 30+ design styles available. Would you like
     something modern and sophisticated, bold and creative, or minimal
     and clean? Or I can show you some options."
```

### 3. Prompt Loading Strategy

Once style is selected:

```javascript
// Pseudo-code for skill execution
const styleName = mapUserInputToStyle(userRequest);
const promptPath = `prompts/${styleName}.md`;

// Load the full design system
const designSystem = await Read(promptPath);

// Parse key sections
const designPhilosophy = extractSection(designSystem, 'Design Philosophy');
const colorTokens = extractSection(designSystem, 'Color Strategy');
const typography = extractSection(designSystem, 'Typography');
const components = extractSection(designSystem, 'Component Styling');
const boldFactors = extractSection(designSystem, 'Bold Factor');
const antiPatterns = extractSection(designSystem, 'Anti-Patterns');

// Internalize these before coding
```

### 4. Code Generation Guidelines

**For Tailwind CSS Projects:**

Extract design tokens and map to Tailwind config:

```javascript
// tailwind.config.js extension example
module.exports = {
  theme: {
    extend: {
      colors: {
        // Extract from prompt's color table
        'background-deep': '#020203',
        'background-base': '#050506',
        'accent': '#5E6AD2',
        // etc.
      },
      fontFamily: {
        // Extract from typography section
        sans: ['Inter', 'Geist Sans', 'system-ui', 'sans-serif'],
      },
      boxShadow: {
        // Extract from shadow system
        'multi-layer': '0 0 0 1px rgba(255,255,255,0.06), 0 2px 20px rgba(0,0,0,0.4)',
      }
    }
  }
}
```

**For React/Next.js Projects:**

Create reusable component library:

```jsx
// components/ui/Button.jsx
// Built from prompt's button specifications

export function Button({ variant = 'primary', children, ...props }) {
  const variants = {
    primary: 'bg-[#5E6AD2] text-white shadow-[0_0_0_1px_rgba(94,106,210,0.5)]',
    secondary: 'bg-white/[0.05] text-[#EDEDEF]',
    // etc.
  };

  return (
    <button
      className={`
        ${variants[variant]}
        rounded-lg px-6 py-3 font-bold
        transition-all duration-200
        hover:scale-[1.02]
        active:scale-[0.98]
      `}
      {...props}
    >
      {children}
    </button>
  );
}
```

**For Plain CSS Projects:**

Create CSS custom properties:

```css
/* styles/design-tokens.css */
:root {
  /* Colors from prompt */
  --background-deep: #020203;
  --background-base: #050506;
  --foreground: #EDEDEF;
  --accent: #5E6AD2;

  /* Typography from prompt */
  --font-sans: "Inter", "Geist Sans", system-ui, sans-serif;
  --font-size-display: clamp(4rem, 8vw, 8rem);

  /* Spacing from prompt */
  --section-padding: clamp(6rem, 12vw, 12rem);
}
```

### 5. Quality Checklist

Before delivering code, verify:

- [ ] **Signature elements implemented** - Check "Bold Factor" section of prompt
- [ ] **Anti-patterns avoided** - Verify against "Anti-Patterns" section
- [ ] **Responsive design** - Mobile, tablet, desktop breakpoints
- [ ] **Accessibility** - Contrast ratios, focus states, keyboard navigation
- [ ] **Design tokens centralized** - Not hardcoded everywhere
- [ ] **Code matches user's patterns** - Consistent with their existing codebase
- [ ] **Animations included** - If specified in the design system
- [ ] **Interactive states defined** - Hover, focus, active states

## Style Mapping Reference

Quick reference for common user requests → prompt files:

| User Says | Load Prompt |
|-----------|-------------|
| "modern", "contemporary", "sleek" | ModernDark.md |
| "brutalist", "raw", "bold borders" | Neo-brutalism.md |
| "minimal", "clean", "simple" | Swiss.md or FlatDesign.md |
| "dark mode", "dark theme" | ModernDark.md or MinimalDrak.md |
| "professional", "business" | Professional.md |
| "enterprise", "corporate", "scalable" | Enterprise.md |
| "luxury", "premium", "elegant" | Luxury.md |
| "creative", "artistic", "unique" | BoldTypography.md or Maximalism.md |
| "geometric", "shapes" | PlayfulGeometric.md or Bauhaus.md |
| "nature", "organic", "plants" | Botanical.md or Organic.md |
| "futuristic", "neon", "cyber" | Cyberpunk.md |
| "retro", "vintage", "nostalgic" | Retro.md or Vaporwave.md |
| "crypto", "web3", "blockchain" | Web3.md |
| "material design", "google" | Material.md |
| "soft", "clay", "3d" | Claymorphism.md or Neumorphism.md |
| "newspaper", "editorial" | Newsprint.md |
| "command line", "terminal", "CLI" | TerminalCLI.md |
| "academic", "scholarly" | Academia.md |
| "art deco", "1920s" | ArtDeco.md |
| "industrial", "mechanical" | Industrial.md |
| "black and white", "monochrome" | Monochrome.md |
| "SaaS", "startup" | Saas.md or ModernDark.md |
| "animated", "motion", "kinetic" | Kinetic.md |
| "hand-drawn", "sketch" | Sketch.md |

## Common Patterns

### Pattern 1: Full Landing Page

```
User: "Build a landing page for my AI SaaS product"

Steps:
1. Ask: "What design style? I recommend Modern Dark (sophisticated)
   or Neo-brutalism (bold and memorable)"
2. User picks: "Modern Dark"
3. Load: prompts/ModernDark.md
4. Ask: "React/Next.js or Vue?"
5. User: "Next.js with Tailwind"
6. Build:
   - Hero section with animated gradient blobs
   - Features bento grid (asymmetric)
   - Pricing cards with glass effect
   - CTA with accent glow
   - All following ModernDark design tokens
```

### Pattern 2: Single Component

```
User: "Create a pricing card component for my app"

Steps:
1. Check existing codebase for design clues
2. If no clear style, ask: "What aesthetic? Modern, minimal, or bold?"
3. User: "Modern"
4. Load: prompts/ModernDark.md
5. Extract: Card component section
6. Build reusable PricingCard component
7. Use design tokens from prompt
```

### Pattern 3: Refactor Existing Code

```
User: "Refactor this component to use Neo-brutalism style"

Steps:
1. Load: prompts/Neo-brutalism.md
2. Read: User's existing component
3. Identify: Current patterns (file structure, naming, etc.)
4. Transform:
   - Replace soft shadows with hard shadows (8px 8px 0px 0px #000)
   - Add thick borders (border-4 border-black)
   - Update colors to Neo-brutalism palette
   - Add sticker rotation effects
   - Implement push/lift interactions
5. Preserve: Existing functionality and props
```

## Advanced Usage

### Combining Prompts (Experimental)

If user wants a blend of styles:

```
User: "I want a dark theme with brutalist borders"

Approach:
1. Load primary prompt: ModernDark.md (base)
2. Load secondary prompt: Neo-brutalism.md (accents)
3. Take color system from ModernDark
4. Take border/shadow system from Neo-brutalism
5. Merge carefully, explaining the hybrid approach
```

### Custom Style Requests

If user has a unique aesthetic not covered:

```
User: "Make it look like a vintage arcade cabinet"

Approach:
1. Find closest match: Retro.md or Cyberpunk.md
2. Load that as starting point
3. Modify:
   - Add arcade-specific colors (neon on black)
   - Add scanline effects
   - Use pixelated fonts
   - Add CRT screen curvature effects
4. Document modifications for consistency
```

## Troubleshooting

**Problem:** User's request is too vague

**Solution:** Use the decision tree, then confirm:
```
"Based on [context clues], I think [StyleName] would work well.
It has [key characteristics]. Sound good, or would you prefer
something different?"
```

**Problem:** Selected style conflicts with user's framework

**Solution:** Adapt the design system to their constraints:
```
"This design uses Tailwind utilities, but I see you're using
styled-components. I'll translate the design tokens to your
CSS-in-JS approach."
```

**Problem:** User wants multiple pages with different styles

**Solution:** Establish a primary style, use others as accents:
```
"I recommend ModernDark as your base design system for consistency.
We can use Neo-brutalism accents on the pricing page to make it
stand out. This creates visual hierarchy while maintaining coherence."
```

## Integration Examples

### Example: Next.js App Router + Tailwind + shadcn/ui

```jsx
// app/page.jsx
// Using ModernDark.md design system

import { Button } from '@/components/ui/button'; // shadcn
import { GradientBlobs } from '@/components/gradient-blobs'; // custom

export default function Home() {
  return (
    <div className="relative min-h-screen bg-[radial-gradient(ellipse_at_top,#0a0a0f_0%,#050506_50%,#020203_100%)]">
      <GradientBlobs /> {/* Animated ambient lighting */}

      <section className="container mx-auto px-6 py-32">
        <h1 className="text-7xl font-semibold tracking-[-0.03em] bg-gradient-to-b from-white via-white/95 to-white/70 bg-clip-text text-transparent">
          Build Something Amazing
        </h1>

        <Button className="mt-8 bg-[#5E6AD2] shadow-[0_0_0_1px_rgba(94,106,210,0.5),0_4px_12px_rgba(94,106,210,0.3)]">
          Get Started
        </Button>
      </section>
    </div>
  );
}
```

### Example: Vue 3 + Plain CSS

```vue
<!-- components/HeroSection.vue -->
<!-- Using Neo-brutalism.md design system -->

<template>
  <section class="hero">
    <div class="hero-content">
      <h1 class="hero-title">
        <span class="title-line title-line--accent">BOLD</span>
        <span class="title-line title-line--rotated">CREATIVE</span>
        <span class="title-line">DESIGN</span>
      </h1>
      <button class="cta-button">START NOW</button>
    </div>
  </section>
</template>

<style scoped>
.hero {
  background: #FFFDF5; /* Cream background */
  padding: 8rem 2rem;
  border-bottom: 8px solid #000;
}

.hero-title {
  font-family: 'Space Grotesk', sans-serif;
  font-weight: 900;
  font-size: clamp(3rem, 10vw, 8rem);
  line-height: 0.9;
  text-transform: uppercase;
}

.title-line--accent {
  color: #FF6B6B; /* Hot Red */
  text-shadow: 6px 6px 0px #000;
}

.title-line--rotated {
  display: inline-block;
  transform: rotate(-2deg);
  color: #FFD93D; /* Vivid Yellow */
}

.cta-button {
  margin-top: 2rem;
  padding: 1rem 3rem;
  background: #FF6B6B;
  color: #FFFDF5;
  border: 4px solid #000;
  box-shadow: 8px 8px 0px 0px #000;
  font-weight: 700;
  font-size: 1.125rem;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  transition: transform 0.1s;
}

.cta-button:active {
  transform: translate(4px, 4px);
  box-shadow: none;
}
</style>
```

## Maintenance

As new design systems are added to the `prompts/` directory:

1. Update the "Available Design Styles" list in SKILL.md
2. Add mapping rules in "Style Mapping Reference" section
3. Test skill with new prompts to ensure compatibility
4. Update examples if new patterns emerge

## Credits

This skill leverages the design system prompts curated in the `prompts/` directory. Each prompt represents hours of design research and systematic documentation to enable AI-assisted frontend development that produces distinctive, production-grade interfaces.
