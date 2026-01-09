# UI Analysis Guide (V2 - Deep Extraction)

## Analysis Workflow

### Step 1: Anti-Bot & Navigation Check

1. Navigate to URL.
2. **CRITICAL CHECK**: Inspect `document.title` and `document.body.innerText`.
   - If it contains "Just a moment", "Cloudflare", "Challenge", or "Verify you are human":
   - **STOP**. Ask the user to manually solve the CAPTCHA in the opened browser window.
   - Wait for user confirmation before proceeding.

### Step 2: Deep Extraction (The "Source of Truth")

Do not rely solely on screenshots. Use these scripts to extract the raw CSS logic.

#### A. Deep Animation & Transition Extractor
This script traverses CSS stylesheets to find `@keyframes` and classes with transitions.

```javascript
() => {
  const animations = {
    transitions: [],
    keyframes: {}
  };

  try {
    // Helper to serialize CSS rules
    const parseRule = (rule) => {
      if (rule.type === 7) { // CSSKeyframesRule
        const frames = {};
        Array.from(rule.cssRules).forEach(r => {
           frames[r.keyText] = r.style.cssText;
        });
        animations.keyframes[rule.name] = frames;
      }
      else if (rule.style) {
        // Check for transitions
        if (rule.style.transition && rule.style.transition !== 'all 0s ease 0s') {
          animations.transitions.push({
            selector: rule.selectorText,
            transition: rule.style.transition
          });
        }
        // Check for animation usage
        if (rule.style.animationName) {
           // We already capture the keyframe definition above, now we capture usage
        }
      }
    };

    // Traverse all loaded stylesheets
    Array.from(document.styleSheets).forEach(sheet => {
      try {
        Array.from(sheet.cssRules).forEach(parseRule);
      } catch (e) {
        // CORS restriction on some cross-origin sheets
        console.log('Skipping cross-origin sheet');
      }
    });

  } catch (e) { return { error: e.message }; }

  return animations;
}
```

#### B. Interaction State Extractor (:hover / :focus)
Extracts pseudo-states directly from CSS rules instead of trying to simulate mouse events.

```javascript
() => {
  const interactions = [];

  try {
    Array.from(document.styleSheets).forEach(sheet => {
      try {
        Array.from(sheet.cssRules).forEach(rule => {
          if (rule.selectorText && (rule.selectorText.includes(':hover') || rule.selectorText.includes(':focus'))) {
            // Filter only relevant interaction changes (color, background, transform, shadow)
            const style = rule.style;
            if (style.color || style.backgroundColor || style.transform || style.boxShadow || style.borderColor) {
               interactions.push({
                 selector: rule.selectorText,
                 changes: style.cssText
               });
            }
          }
        });
      } catch (e) {}
    });
  } catch (e) {}

  // Return top 20 most relevant interactions to save context
  return interactions.slice(0, 20);
}
```

#### C. Variable & Token Extractor (Enhanced)
Extracts all CSS variables defined on `:root` to find the defined palette.

```javascript
() => {
  const tokens = {};
  const computed = getComputedStyle(document.documentElement);

  // 1. Try to find CSS variables by iterating common patterns if strict iteration fails
  // Note: Standard API doesn't let you iterate all defined vars easily on computed style
  // so we fallback to reading the style attribute of :root in stylesheets

  try {
     Array.from(document.styleSheets).forEach(sheet => {
       try {
         Array.from(sheet.cssRules).forEach(rule => {
           if (rule.selectorText === ':root' || rule.selectorText === 'html') {
             for (let i = 0; i < rule.style.length; i++) {
               const prop = rule.style[i];
               if (prop.startsWith('--')) {
                 tokens[prop] = rule.style.getPropertyValue(prop).trim();
               }
             }
           }
         });
       } catch(e) {}
     });
  } catch(e) {}

  return tokens;
}
```

### Step 3: Visual Verification (Snapshots)

Take screenshots ONLY to verify the layout structure and vibe, not for extracting exact pixel values (since we now have the CSS).

### Step 4: Tech Stack Fingerprinting

Check for global variables to identify the underlying tech (which informs the implementation guide).

```javascript
() => {
  return {
    isTailwind: !!document.querySelector('.text-center') || !!document.querySelector('.flex'),
    isBootstrap: !!document.querySelector('.btn-primary'),
    isReact: !!Object.keys(window).find(k => k.startsWith('__react')),
    isVue: !!document.querySelector('[data-v-app]'),
    isNext: !!window.__NEXT_DATA__,
    isFramerMotion: !!document.querySelector('[style*="transform"]') // loose check
  };
}
```

## Output Mapping

Map extracted `keyframes` to the `Animation & Motion` section of the template.
Map extracted `:hover` rules to the `Interactive Elements` section.
