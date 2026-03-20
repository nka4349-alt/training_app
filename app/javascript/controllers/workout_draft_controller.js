import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static values = { sessionId: Number }

  connect() {
    this.onDraftSave = this.handleDraftSave.bind(this)
    this.onOnline = this.syncDrafts.bind(this)
    window.addEventListener("workout:draft-save", this.onDraftSave)
    window.addEventListener("online", this.onOnline)
    this.syncDrafts()
  }

  disconnect() {
    window.removeEventListener("workout:draft-save", this.onDraftSave)
    window.removeEventListener("online", this.onOnline)
  }

  handleDraftSave(event) {
    const { sessionId, setEntryId, payload } = event.detail
    if (parseInt(sessionId, 10) !== this.sessionIdValue) return
    localStorage.setItem(this.keyFor(setEntryId), JSON.stringify(payload))
  }

  async syncDrafts() {
    if (!navigator.onLine) return

    const csrf = document.querySelector("meta[name='csrf-token']")?.content
    if (!csrf) return

    for (const key of this.keys()) {
      const setEntryId = key.split(":").pop()
      const draft = this.parse(localStorage.getItem(key))
      if (!draft) continue

      const body = new FormData()
      body.append("set_entry[weight]", draft.weight ?? "")
      body.append("set_entry[reps]", draft.reps ?? "")
      body.append("set_entry[rpe]", draft.rpe ?? "")
      body.append("set_entry[status]", draft.status ?? "planned")
      body.append("set_entry[failed]", draft.failed ? "1" : "0")

      const response = await fetch(`/set_entries/${setEntryId}`, {
        method: "PATCH",
        headers: {
          "X-CSRF-Token": csrf,
          "Accept": "text/vnd.turbo-stream.html"
        },
        body
      })

      if (response.status === 422 || response.status === 403) {
        localStorage.removeItem(key)
        continue
      }

      if (!response.ok) continue

      const text = await response.text()
      Turbo.renderStreamMessage(text)
      localStorage.removeItem(key)
      window.dispatchEvent(new CustomEvent("ui:toast", { detail: { message: "オフライン下書きを同期しました" } }))
    }
  }

  keys() {
    const prefix = `training-app:draft:${this.sessionIdValue}:`
    return Object.keys(localStorage).filter((key) => key.startsWith(prefix))
  }

  keyFor(setEntryId) {
    return `training-app:draft:${this.sessionIdValue}:${setEntryId}`
  }

  parse(value) {
    try {
      return JSON.parse(value || "{}")
    } catch (_error) {
      return null
    }
  }
}
