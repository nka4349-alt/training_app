import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    this.toastHandler = (event) => this.show(event.detail.message)
    window.addEventListener("ui:toast", this.toastHandler)
  }

  disconnect() {
    window.removeEventListener("ui:toast", this.toastHandler)
  }

  show(message) {
    if (!this.hasContainerTarget || !message) return

    const el = document.createElement("div")
    el.textContent = message
    el.style.cssText = "background:#1f2937;color:#fff;padding:10px 12px;border-radius:10px;font-size:12px;box-shadow:0 8px 20px rgba(0,0,0,.16);"
    this.containerTarget.appendChild(el)

    setTimeout(() => {
      el.style.opacity = "0"
      el.style.transition = "opacity .25s ease"
      setTimeout(() => el.remove(), 300)
    }, 1800)
  }
}
