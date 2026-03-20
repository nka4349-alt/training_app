import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["time"]
  static values = { startedAt: String }

  connect() {
    this.tick()
    this.timerId = setInterval(() => this.tick(), 1000)
  }

  disconnect() {
    if (this.timerId) clearInterval(this.timerId)
  }

  tick() {
    if (!this.hasTimeTarget || !this.startedAtValue) return

    const startedAt = new Date(this.startedAtValue).getTime()
    const elapsedSec = Math.max(0, Math.floor((Date.now() - startedAt) / 1000))
    const m = String(Math.floor(elapsedSec / 60)).padStart(2, "0")
    const s = String(elapsedSec % 60).padStart(2, "0")
    this.timeTarget.textContent = `${m}:${s}`
  }
}
