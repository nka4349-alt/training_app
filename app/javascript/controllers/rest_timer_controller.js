import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["time", "panel"]

  connect() {
    this.remaining = null
    this.timerId = null
    this.hide()

    window.addEventListener("rest:start", (e) => {
      const sec = parseInt(e.detail.seconds || 0, 10)
      if (sec > 0) this.start(sec)
    })
  }

  start(seconds) {
    this.clear()
    this.remaining = seconds
    this.show()
    this.render()
    this.timerId = setInterval(() => {
      this.remaining -= 1
      if (this.remaining <= 0) {
        this.remaining = 0
        this.render()
        this.clear()
        this.hide()
        return
      }
      this.render()
    }, 1000)
  }

  add15() { if (this.remaining != null) { this.remaining += 15; this.render() } }
  sub15() { if (this.remaining != null) { this.remaining = Math.max(0, this.remaining - 15); this.render() } }
  skip() {
    this.clear()
    this.remaining = null
    this.timeTarget.textContent = "--:--"
    this.hide()
  }

  focusNext() {
    const buttons = Array.from(document.querySelectorAll("[data-role='set-done-button']"))
    const active = document.activeElement
    const currentIndex = buttons.indexOf(active)
    if (currentIndex >= 0 && buttons[currentIndex + 1]) {
      buttons[currentIndex + 1].focus()
      return
    }

    if (buttons[0]) buttons[0].focus()
  }

  clear() { if (this.timerId) clearInterval(this.timerId); this.timerId = null }
  render() {
    const m = String(Math.floor(this.remaining / 60)).padStart(2, "0")
    const s = String(this.remaining % 60).padStart(2, "0")
    this.timeTarget.textContent = `${m}:${s}`
  }

  show() {
    if (this.hasPanelTarget) this.panelTarget.style.display = "flex"
  }

  hide() {
    if (this.hasPanelTarget) this.panelTarget.style.display = "none"
  }
}
