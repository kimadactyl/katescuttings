import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = []

  connect() {
    this.timeout = null
  }

  search(event) {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      event.target.form.requestSubmit()
    }, 300)
  }
}
