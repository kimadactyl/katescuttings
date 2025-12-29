import { Controller } from "@hotwired/stimulus"

// Manages the attachments list for blog posts
// Handles adding new attachments, removing, and image previews
export default class extends Controller {
  static targets = ["list", "template"]

  connect() {
    this.index = this.listTarget.querySelectorAll('.attachment-card').length
    // Auto-resize all existing textareas
    this.element.querySelectorAll('textarea').forEach(ta => this.autoResize(ta))
  }

  add(event) {
    event.preventDefault()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.listTarget.insertAdjacentHTML('beforeend', content)
    this.index++
  }

  remove(event) {
    event.preventDefault()
    const card = event.target.closest('.attachment-card')
    const destroyInput = card.querySelector('input[name*="_destroy"]')

    if (destroyInput) {
      // Existing record - mark for destruction and hide
      destroyInput.value = '1'
      card.classList.add('attachment-card--deleted')
      card.querySelector('.attachment-card__undo').style.display = 'block'
    } else {
      // New record - just remove from DOM
      card.remove()
    }
  }

  undo(event) {
    event.preventDefault()
    const card = event.target.closest('.attachment-card')
    const destroyInput = card.querySelector('input[name*="_destroy"]')

    if (destroyInput) {
      destroyInput.value = '0'
      card.classList.remove('attachment-card--deleted')
      card.querySelector('.attachment-card__undo').style.display = 'none'
    }
  }

  preview(event) {
    const input = event.target
    const card = input.closest('.attachment-card')
    const preview = card.querySelector('.attachment-card__preview')
    const placeholder = card.querySelector('.attachment-card__placeholder')

    if (input.files && input.files[0]) {
      const reader = new FileReader()

      reader.onload = (e) => {
        preview.src = e.target.result
        preview.style.display = 'block'
        if (placeholder) placeholder.style.display = 'none'
      }

      reader.readAsDataURL(input.files[0])
    }
  }

  // Auto-resize textarea as content grows
  resize(event) {
    this.autoResize(event.target)
  }

  autoResize(textarea) {
    textarea.style.height = 'auto'
    textarea.style.height = textarea.scrollHeight + 'px'
  }

  // Copy caption to alt text until alt text is manually edited
  syncCaption(event) {
    const card = event.target.closest('.attachment-card')
    const altTextarea = card.querySelector('textarea[name*="alt_text"]')

    if (altTextarea && !altTextarea.dataset.edited) {
      altTextarea.value = event.target.value
      this.autoResize(altTextarea)
    }
  }

  // Mark alt text as manually edited
  markEdited(event) {
    event.target.dataset.edited = 'true'
  }
}
