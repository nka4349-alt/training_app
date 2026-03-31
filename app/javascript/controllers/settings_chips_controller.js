import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  sync(event) {
    const input = event.target
    if (!(input instanceof HTMLInputElement)) return

    const chip = input.closest(".chip")
    if (!chip) return

    if (input.type === "radio") {
      this.element
        .querySelectorAll(`input[type="radio"][name="${this.escapeSelector(input.name)}"]`)
        .forEach((radio) => {
          radio.closest(".chip")?.classList.toggle("active", radio.checked)
        })
      return
    }

    if (input.type === "checkbox") {
      chip.classList.toggle("active", input.checked)
    }
  }

  escapeSelector(value) {
    if (window.CSS && typeof window.CSS.escape === "function") return window.CSS.escape(value)
    return value.replace(/([ #;?%&,.+*~\\':"!^$[\]()=>|/@])/g, "\\$1")
  }
}
