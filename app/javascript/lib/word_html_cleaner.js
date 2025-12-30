// Word HTML Cleaner
// Cleans up HTML pasted from Microsoft Word and other rich text sources
// Strips proprietary tags, styles, and classes while preserving semantic content

export function isWordHtml(html) {
  const wordIndicators = [
    /class="?Mso/i,
    /<o:p>/i,
    /<w:/i,
    /xmlns:w=/i,
    /xmlns:o=/i,
    /urn:schemas-microsoft-com/i,
    /mso-/i,
    /<meta[^>]*microsoft/i,
    /<meta[^>]*Word/i
  ]

  return wordIndicators.some(pattern => pattern.test(html))
}

export function cleanWordHtml(html) {
  // Create a temporary container to parse and clean the HTML
  const container = document.createElement("div")
  container.innerHTML = html

  // Remove Word-specific elements and comments
  removeWordElements(container)

  // Remove conditional comments (<!--[if gte mso 9]> etc.)
  removeConditionalComments(container)

  // Remove all style and class attributes
  removeAttributes(container)

  // Clean up empty and wrapper elements
  removeEmptyElements(container)

  // Normalize semantic tags
  normalizeSemanticTags(container)

  // Clean up whitespace
  normalizeWhitespace(container)

  return container.innerHTML
}

function removeWordElements(container) {
  // Remove style, script, meta tags
  container.querySelectorAll("style, script, meta, link, title").forEach(el => el.remove())

  // Remove XML namespace elements (Word uses these)
  const walker = document.createTreeWalker(
    container,
    NodeFilter.SHOW_ELEMENT,
    null,
    false
  )

  const toRemove = []
  while (walker.nextNode()) {
    const node = walker.currentNode
    const tagName = node.tagName?.toUpperCase() || ""

    // Remove elements with Word/Office namespaces
    if (
      tagName.startsWith("O:") ||
      tagName.startsWith("W:") ||
      tagName.startsWith("M:") ||
      tagName.startsWith("V:") ||
      tagName === "O:P"
    ) {
      toRemove.push(node)
    }
  }

  // Replace Word elements with their text content
  toRemove.forEach(node => {
    const parent = node.parentNode
    if (parent) {
      while (node.firstChild) {
        parent.insertBefore(node.firstChild, node)
      }
      node.remove()
    }
  })
}

function removeConditionalComments(container) {
  // Word adds conditional comments like <!--[if gte mso 9]>
  // We need to walk the HTML string for this
  const html = container.innerHTML
  const cleaned = html
    // Remove conditional comments and their content
    .replace(/<!--\[if[^\]]*\]>[\s\S]*?<!\[endif\]-->/gi, "")
    .replace(/<!--\[if[^\]]*\]>/gi, "")
    .replace(/<!\[endif\]-->/gi, "")
    // Remove regular HTML comments
    .replace(/<!--[\s\S]*?-->/g, "")

  container.innerHTML = cleaned
}

function removeAttributes(container) {
  const allElements = container.querySelectorAll("*")

  allElements.forEach(el => {
    // Collect attributes to remove (can't modify during iteration)
    const attrsToRemove = []

    for (const attr of el.attributes) {
      const name = attr.name.toLowerCase()

      // Keep href on links, src on images
      if (name === "href" && el.tagName === "A") continue
      if (name === "src" && el.tagName === "IMG") continue
      if (name === "alt" && el.tagName === "IMG") continue

      // Remove everything else
      attrsToRemove.push(attr.name)
    }

    attrsToRemove.forEach(attr => el.removeAttribute(attr))
  })
}

function removeEmptyElements(container) {
  // Tags to unwrap (keep content, remove wrapper)
  const unwrapTags = ["span", "font", "div"]

  // Tags to remove if empty
  const removeIfEmptyTags = ["p", "div", "span", "font", "b", "i", "u", "strong", "em"]

  let changed = true
  let iterations = 0
  const maxIterations = 10 // Prevent infinite loops

  while (changed && iterations < maxIterations) {
    changed = false
    iterations++

    // Unwrap meaningless wrapper elements
    unwrapTags.forEach(tag => {
      container.querySelectorAll(tag).forEach(el => {
        // Unwrap if it has no meaningful purpose
        if (!el.hasAttributes() || el.attributes.length === 0) {
          const parent = el.parentNode
          if (parent) {
            while (el.firstChild) {
              parent.insertBefore(el.firstChild, el)
            }
            el.remove()
            changed = true
          }
        }
      })
    })

    // Remove empty elements
    removeIfEmptyTags.forEach(tag => {
      container.querySelectorAll(tag).forEach(el => {
        const text = el.textContent?.trim() || ""
        const hasChildren = el.children.length > 0

        // Remove if truly empty or just whitespace/nbsp
        if (!hasChildren && (!text || text === "\u00A0" || text === "&nbsp;")) {
          el.remove()
          changed = true
        }
      })
    })
  }
}

function normalizeSemanticTags(container) {
  // Convert <b> to <strong>
  container.querySelectorAll("b").forEach(el => {
    const strong = document.createElement("strong")
    while (el.firstChild) {
      strong.appendChild(el.firstChild)
    }
    el.replaceWith(strong)
  })

  // Convert <i> to <em>
  container.querySelectorAll("i").forEach(el => {
    const em = document.createElement("em")
    while (el.firstChild) {
      em.appendChild(el.firstChild)
    }
    el.replaceWith(em)
  })
}

function normalizeWhitespace(container) {
  // Replace multiple spaces/nbsp with single space
  const walker = document.createTreeWalker(
    container,
    NodeFilter.SHOW_TEXT,
    null,
    false
  )

  const textNodes = []
  while (walker.nextNode()) {
    textNodes.push(walker.currentNode)
  }

  textNodes.forEach(node => {
    // Replace nbsp with regular space
    let text = node.textContent.replace(/\u00A0/g, " ")
    // Collapse multiple spaces
    text = text.replace(/  +/g, " ")
    node.textContent = text
  })
}
