import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["weight", "reps", "rpe", "status", "doneButton"]
  static values = {
    weightStep: Number,
    restSeconds: Number,
    showRpe: Boolean,
    sessionId: Number,
    setEntryId: Number,
    autoStartRestTimer: Boolean,
    autoFocusNext: Boolean
  }

  incWeight() { this.bump(this.weightTarget, +this.weightStepValue) }
  decWeight() { this.bump(this.weightTarget, -this.weightStepValue, 0) }
  incReps() { this.bump(this.repsTarget, +1) }
  decReps() { this.bump(this.repsTarget, -1, 0) }

  setRpe(event) {
    this.rpeTarget.value = event.params.rpe
    this.submit()
  }

  toggleDone() {
    const isDone = this.statusTarget.value === "done"
    if (!isDone && !this.ensureWeight()) return

    this.statusTarget.value = isDone ? "planned" : "done"

    if (!isDone && this.autoStartRestTimerValue) {
      window.dispatchEvent(new CustomEvent("rest:start", { detail: { seconds: this.restSecondsValue } }))
    }

    if (!isDone && this.autoFocusNextValue) {
      this.focusNextDoneButton()
    }

    this.warnOutlierValues()
    this.submit()
  }

  submit() {
    if (navigator.onLine) {
      this.element.requestSubmit()
      return
    }

    this.persistLocalDraft()
    this.toast("オフライン中のため端末に保存しました")
  }

  bump(input, delta, minValue = null) {
    const current = parseFloat(input.value || "0")
    let next = current + delta
    if (minValue !== null) next = Math.max(minValue, next)
    next = Math.round(next * 100) / 100
    input.value = next
    this.submit()
  }

  ensureWeight() {
    if (this.weightTarget.value !== "") return true
    const confirmed = window.confirm("重量未入力です。0kgとして記録しますか？")
    if (!confirmed) {
      this.weightTarget.focus()
      return false
    }

    this.weightTarget.value = "0"
    return true
  }

  warnOutlierValues() {
    const reps = parseInt(this.repsTarget.value || "0", 10)
    const weight = parseFloat(this.weightTarget.value || "0")
    if (reps === 0) this.toast("回数が0回です")
    if (weight >= 500) this.toast("重量が高すぎる可能性があります")
  }

  focusNextDoneButton() {
    const buttons = Array.from(document.querySelectorAll("[data-role='set-done-button']"))
    const idx = buttons.indexOf(this.doneButtonTarget)
    if (idx >= 0 && buttons[idx + 1]) buttons[idx + 1].focus()
  }

  persistLocalDraft() {
    window.dispatchEvent(new CustomEvent("workout:draft-save", {
      detail: {
        sessionId: this.sessionIdValue,
        setEntryId: this.setEntryIdValue,
        payload: {
          weight: this.weightTarget.value,
          reps: this.repsTarget.value,
          rpe: this.hasRpeTarget ? this.rpeTarget.value : "",
          status: this.statusTarget.value,
          failed: this.element.querySelector("input[type='checkbox']")?.checked || false,
          updatedAt: Date.now()
        }
      }
    }))
  }

  toast(message) {
    window.dispatchEvent(new CustomEvent("ui:toast", { detail: { message } }))
  }
}
