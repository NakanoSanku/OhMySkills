# UI Analysis Guide (V3 - Context-Optimized Deep Extraction)

## Critical: Context Management

To prevent context overflow, ALL extraction scripts must:
1. Limit array results to essential items only
2. Aggregate similar patterns instead of listing each instance
3. Return summarized data, not raw dumps

---

## Analysis Workflow

### Step 1: Anti-Bot & Navigation Check

1. Navigate to URL.
2. **CRITICAL CHECK**: Inspect `document.title` and `document.body.innerText`.
   - If it contains "Just a moment", "Cloudflare", "Challenge", or "Verify you are human":
   - **STOP**. Ask the user to manually solve the CAPTCHA in the opened browser window.
   - Wait for user confirmation before proceeding.

### Step 2: Deep Extraction (The "Source of Truth")

Run these scripts **in sequence** using `mcp__chrome-devtools__evaluate_script`.

#### A. CSS Variables & Design Tokens (Run First)

Extracts CSS custom properties with smart categorization. Limited to 50 most important tokens.

```javascript
() => {
  const tokens = { colors: {}, spacing: {}, typography: {}, other: {} };
  let count = 0;
  const MAX_TOKENS = 50;

  const categorize = (name, value) => {
    const v = value.toLowerCase();
    if (v.includes('#') || v.includes('rgb') || v.includes('hsl') || name.includes('color') || name.includes('bg')) {
      return 'colors';
    }
    if (name.includes('font') || name.includes('text') || name.includes('line-height')) {
      return 'typography';
    }
    if (name.includes('space') || name.includes('gap') || name.includes('margin') || name.includes('padding') || name.includes('radius')) {
      return 'spacing';
    }
    return 'other';
  };

  try {
    Array.from(document.styleSheets).forEach(sheet => {
      if (count >= MAX_TOKENS) return;
      try {
        Array.from(sheet.cssRules).forEach(rule => {
          if (count >= MAX_TOKENS) return;
          if (rule.selectorText === ':root' || rule.selectorText === 'html' || rule.selectorText === ':root, :host') {
            for (let i = 0; i < rule.style.length && count < MAX_TOKENS; i++) {
              const prop = rule.style[i];
              if (prop.startsWith('--')) {
                const val = rule.style.getPropertyValue(prop).trim();
                const cat = categorize(prop, val);
                tokens[cat][prop] = val;
                count++;
              }
            }
          }
        });
      } catch(e) {}
    });
  } catch(e) {}

  return { tokenCount: count, tokens };
}
```

#### B. Animation & Keyframes Extractor (Enhanced)

Extracts **all animation-related CSS** including keyframes, animation properties, and transitions.
Limited to 10 keyframes and 15 transitions.

```javascript
() => {
  const result = {
    keyframes: {},
    animationUsage: [],
    transitions: []
  };
  let kfCount = 0, transCount = 0;
  const MAX_KF = 10, MAX_TRANS = 15;
  const seenSelectors = new Set();

  const processRules = (rules) => {
    Array.from(rules).forEach(rule => {
      // Handle @keyframes
      if (rule.type === CSSRule.KEYFRAMES_RULE && kfCount < MAX_KF) {
        const frames = {};
        Array.from(rule.cssRules).forEach(frame => {
          frames[frame.keyText] = frame.style.cssText;
        });
        result.keyframes[rule.name] = frames;
        kfCount++;
      }
      // Handle @media rules (nested)
      else if (rule.type === CSSRule.MEDIA_RULE) {
        processRules(rule.cssRules);
      }
      // Handle style rules
      else if (rule.style) {
        const sel = rule.selectorText || '';
        // Animation usage
        if (rule.style.animation || rule.style.animationName) {
          const anim = rule.style.animation || rule.style.animationName;
          if (!seenSelectors.has(sel + ':anim')) {
            result.animationUsage.push({
              selector: sel,
              animation: anim,
              duration: rule.style.animationDuration || '',
              timing: rule.style.animationTimingFunction || '',
              delay: rule.style.animationDelay || ''
            });
            seenSelectors.add(sel + ':anim');
          }
        }
        // Transitions
        const trans = rule.style.transition;
        if (trans && trans !== 'none' && trans !== 'all 0s ease 0s' && transCount < MAX_TRANS) {
          if (!seenSelectors.has(sel + ':trans')) {
            result.transitions.push({
              selector: sel,
              transition: trans
            });
            seenSelectors.add(sel + ':trans');
            transCount++;
          }
        }
      }
    });
  };

  try {
    Array.from(document.styleSheets).forEach(sheet => {
      try { processRules(sheet.cssRules); } catch(e) {}
    });
  } catch(e) {}

  // Also check inline styles on animated elements
  document.querySelectorAll('[style*="animation"], [style*="transition"]').forEach(el => {
    const s = el.style;
    if (s.animation && result.animationUsage.length < 20) {
      result.animationUsage.push({
        selector: el.tagName + (el.className ? '.' + el.className.split(' ')[0] : ''),
        animation: s.animation,
        inline: true
      });
    }
  });

  return {
    keyframeCount: Object.keys(result.keyframes).length,
    transitionCount: result.transitions.length,
    animationUsageCount: result.animationUsage.length,
    data: result
  };
}
```

#### C. Interaction State Extractor (:hover / :focus / :active)

Extracts pseudo-state styles. Limited to 15 most relevant interactions.

```javascript
() => {
  const interactions = [];
  const MAX = 15;
  const seenBase = new Set();

  const prioritySelectors = ['button', 'a', 'input', 'nav', 'card', 'btn', 'link'];

  const getPriority = (sel) => {
    const s = sel.toLowerCase();
    for (let i = 0; i < prioritySelectors.length; i++) {
      if (s.includes(prioritySelectors[i])) return i;
    }
    return 99;
  };

  try {
    const allInteractions = [];
    Array.from(document.styleSheets).forEach(sheet => {
      try {
        Array.from(sheet.cssRules).forEach(rule => {
          const sel = rule.selectorText || '';
          if (sel.includes(':hover') || sel.includes(':focus') || sel.includes(':active')) {
            const style = rule.style;
            const changes = [];
            // Only capture visual changes
            ['color', 'backgroundColor', 'background', 'transform', 'boxShadow', 'borderColor', 'opacity', 'scale', 'filter'].forEach(prop => {
              const val = style[prop] || style.getPropertyValue(prop.replace(/[A-Z]/g, m => '-' + m.toLowerCase()));
              if (val) changes.push(`${prop}: ${val}`);
            });
            if (changes.length > 0) {
              const base = sel.replace(/:hover|:focus|:active/g, '');
              if (!seenBase.has(base)) {
                allInteractions.push({
                  selector: sel,
                  changes: changes.join('; '),
                  priority: getPriority(sel)
                });
                seenBase.add(base);
              }
            }
          }
        });
      } catch(e) {}
    });
    // Sort by priority and take top MAX
    allInteractions.sort((a, b) => a.priority - b.priority);
    interactions.push(...allInteractions.slice(0, MAX));
  } catch(e) {}

  return { count: interactions.length, interactions };
}
```

#### D. Typography Extractor

Extracts font information from key elements.

```javascript
() => {
  const typography = {};
  const elements = {
    h1: document.querySelector('h1'),
    h2: document.querySelector('h2'),
    h3: document.querySelector('h3'),
    body: document.body,
    p: document.querySelector('p'),
    button: document.querySelector('button'),
    a: document.querySelector('a')
  };

  Object.entries(elements).forEach(([name, el]) => {
    if (el) {
      const cs = getComputedStyle(el);
      typography[name] = {
        fontFamily: cs.fontFamily.split(',')[0].replace(/['"]/g, ''),
        fontSize: cs.fontSize,
        fontWeight: cs.fontWeight,
        lineHeight: cs.lineHeight,
        letterSpacing: cs.letterSpacing !== 'normal' ? cs.letterSpacing : null
      };
    }
  });

  return typography;
}
```

#### E. Layout & Spacing Sampler

Extracts common spacing and layout patterns.

```javascript
() => {
  const layout = {
    borderRadius: new Set(),
    gaps: new Set(),
    shadows: new Set()
  };

  // Sample key container elements
  const containers = document.querySelectorAll('main, section, article, .container, .card, [class*="card"], [class*="container"]');
  const buttons = document.querySelectorAll('button, [class*="btn"], a[class*="button"]');

  const addVal = (set, val, max = 5) => {
    if (val && val !== '0px' && val !== 'none' && set.size < max) set.add(val);
  };

  containers.forEach(el => {
    const cs = getComputedStyle(el);
    addVal(layout.borderRadius, cs.borderRadius);
    addVal(layout.gaps, cs.gap);
    addVal(layout.shadows, cs.boxShadow);
  });

  buttons.forEach(el => {
    const cs = getComputedStyle(el);
    addVal(layout.borderRadius, cs.borderRadius);
  });

  return {
    borderRadius: [...layout.borderRadius],
    gaps: [...layout.gaps],
    shadows: [...layout.shadows].slice(0, 3) // Shadows can be verbose
  };
}
```

### Step 3: Tech Stack Fingerprinting

```javascript
() => {
  const stack = [];
  if (document.querySelector('[class*="tw-"], .flex, .grid, .text-center')) stack.push('Tailwind CSS');
  if (document.querySelector('.btn-primary, .container-fluid')) stack.push('Bootstrap');
  if (Object.keys(window).find(k => k.startsWith('__react'))) stack.push('React');
  if (document.querySelector('[data-v-app], [data-v]')) stack.push('Vue');
  if (window.__NEXT_DATA__) stack.push('Next.js');
  if (window.__NUXT__) stack.push('Nuxt');
  if (document.querySelector('[data-framer-appear-id]')) stack.push('Framer Motion');
  if (document.querySelector('[class*="chakra"]')) stack.push('Chakra UI');
  if (document.querySelector('[class*="mantine"]')) stack.push('Mantine');
  if (document.querySelector('[class*="ant-"]')) stack.push('Ant Design');
  if (document.querySelector('[class*="MuiBox"], [class*="css-"]')) stack.push('MUI/Emotion');
  return stack.length > 0 ? stack : ['Unknown/Custom CSS'];
}
```

---

## Output Mapping

| Extracted Data | Template Section |
|----------------|------------------|
| CSS Variables (colors) | Design Token System > Colors |
| CSS Variables (spacing) | Spacing, Radius & Borders |
| Typography data | Typography |
| Keyframes + animationUsage | Animation & Motion > Key Animations |
| Transitions | Animation & Motion > Timing |
| :hover/:focus rules | Interactive Elements, Component Styling |
| Layout sampler | Layout Principles |
| Tech stack | Implementation Notes |
