import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="lightbox"
// Uses window.Luminous and window.LuminousGallery from CDN script
export default class extends Controller {
  static targets = ["item"]

  connect() {
    this.initLightbox()
  }

  initLightbox() {
    const items = this.itemTargets
    if (items.length === 1) {
      new window.Luminous(items[0])
    } else if (items.length > 1) {
      new window.LuminousGallery(items, { arrowNavigation: true })
    }
  }
}
