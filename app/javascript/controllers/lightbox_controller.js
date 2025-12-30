import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="lightbox"
// Uses window.Luminous and window.LuminousGallery from CDN script
export default class extends Controller {
  static targets = ["item"]

  connect() {
    this.initLightbox()
  }

  disconnect() {
    // Clean up Luminous instances to prevent memory leaks and stale references
    if (this.luminousInstance) {
      this.luminousInstance.destroy()
      this.luminousInstance = null
    }
    if (this.galleryInstance) {
      this.galleryInstance.destroy()
      this.galleryInstance = null
    }
  }

  setLightboxAlt(trigger) {
    if (!trigger) return
    // Set alt text on enlarged image for accessibility
    const thumbnailImg = trigger.querySelector('img')
    const altText = thumbnailImg?.alt || trigger.dataset?.caption || ''
    // Luminous creates .lum-img for the enlarged image
    setTimeout(() => {
      const lumImg = document.querySelector('.lum-img')
      if (lumImg) lumImg.alt = altText
    }, 50)
  }

  initLightbox() {
    const items = this.itemTargets
    if (items.length === 0) return

    const luminousOpts = {
      caption: (trigger) => trigger?.dataset?.caption || ''
    }
    const galleryOpts = {
      arrowNavigation: true
    }

    if (items.length === 1) {
      this.luminousInstance = new window.Luminous(items[0], luminousOpts)
    } else if (items.length > 1) {
      this.galleryInstance = new window.LuminousGallery(items, galleryOpts, luminousOpts)
    }
  }
}
