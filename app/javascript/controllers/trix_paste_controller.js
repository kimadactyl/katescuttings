import { Controller } from "@hotwired/stimulus"
import { isWordHtml, cleanWordHtml } from "lib/word_html_cleaner"

// Stimulus controller that intercepts paste events in Trix editor
// and cleans up HTML pasted from Microsoft Word
export default class extends Controller {
  connect() {
    // Find the trix-editor within this controller's scope
    this.trixEditor = this.element.querySelector("trix-editor")
    if (this.trixEditor) {
      // Intercept paste before Trix processes it
      this.trixEditor.addEventListener("paste", this.handlePaste.bind(this), true)
    }
  }

  disconnect() {
    if (this.trixEditor) {
      this.trixEditor.removeEventListener("paste", this.handlePaste.bind(this), true)
    }
  }

  handlePaste(event) {
    const clipboardData = event.clipboardData || window.clipboardData
    if (!clipboardData) return

    const html = clipboardData.getData("text/html")

    // Only process if there's HTML content that looks like it's from Word
    if (!html || !isWordHtml(html)) return

    // Prevent default paste
    event.preventDefault()
    event.stopPropagation()

    // Clean the HTML
    const cleanedHtml = cleanWordHtml(html)

    // Get plain text as fallback
    const plainText = clipboardData.getData("text/plain")

    // Insert the cleaned content via Trix API
    const editor = this.trixEditor.editor
    if (cleanedHtml.trim()) {
      // Insert as HTML
      editor.insertHTML(cleanedHtml)
    } else if (plainText) {
      // Fall back to plain text
      editor.insertString(plainText)
    }
  }
}
