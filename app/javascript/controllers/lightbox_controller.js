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
    const luminousOpts = {
      caption: (trigger) => trigger.dataset.caption || ''
    }
    const galleryOpts = {
      arrowNavigation: true
    }

    if (items.length === 1) {
      new window.Luminous(items[0], luminousOpts)
    } else if (items.length > 1) {
      // LuminousGallery(elements, galleryOpts, luminousOpts)
      new window.LuminousGallery(items, galleryOpts, luminousOpts)
    }
  }
}
