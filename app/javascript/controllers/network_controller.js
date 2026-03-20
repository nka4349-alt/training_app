import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["status"]

  connect() {
    this.onlineHandler = () => this.render()
    this.offlineHandler = () => this.render()
    window.addEventListener("online", this.onlineHandler)
    window.addEventListener("offline", this.offlineHandler)
    this.render()
  }

  disconnect() {
    window.removeEventListener("online", this.onlineHandler)
    window.removeEventListener("offline", this.offlineHandler)
  }

  render() {
    if (!this.hasStatusTarget) return

    const online = navigator.onLine
    this.statusTarget.textContent = online ? "オンライン" : "オフライン"
    this.statusTarget.style.color = online ? "#1a7f37" : "#b42318"
  }
}
