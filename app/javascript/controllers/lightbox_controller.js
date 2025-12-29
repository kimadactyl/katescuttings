import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="lightbox"
// Uses window.Luminous and window.LuminousGallery from CDN script
export default class extends Controller {
  static targets = ["item"]

  connect() {
    this.initLightbox()
  }

  setLightboxAlt(trigger) {
    // Set alt text on enlarged image for accessibility
    const thumbnailImg = trigger.querySelector('img')
    const altText = thumbnailImg?.alt || trigger.dataset.caption || ''
    // Luminous creates .lum-img for the enlarged image
    setTimeout(() => {
      const lumImg = document.querySelector('.lum-img')
      if (lumImg) lumImg.alt = altText
    }, 50)
  }

  initLightbox() {
    const items = this.itemTargets
    const self = this

    const luminousOpts = {
      caption: (trigger) => trigger.dataset.caption || '',
      onOpen: (trigger) => self.setLightboxAlt(trigger)
    }
    const galleryOpts = {
      arrowNavigation: true,
      onChange: ({ currentIndex }) => {
        // Update alt text when navigating gallery
        const trigger = items[currentIndex]
        if (trigger) self.setLightboxAlt(trigger)
      }
    }

    if (items.length === 1) {
      new window.Luminous(items[0], luminousOpts)
    } else if (items.length > 1) {
      new window.LuminousGallery(items, galleryOpts, luminousOpts)
    }
  }
}
