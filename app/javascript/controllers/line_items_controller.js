import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "container"]

  connect() {
    console.log("✅ line-items controller connected")
  }

  add(event) {
    event.preventDefault()
    const time = new Date().getTime()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, time)
    this.containerTarget.insertAdjacentHTML("beforeend", content)
    console.log("✅ Line item added")
  }

  remove(event) {
    event.preventDefault()
    const wrapper = event.target.closest(".nested-fields")
    const destroyInput = wrapper.querySelector("input[name*='_destroy']")
    if (destroyInput) {
      destroyInput.value = 1
      wrapper.style.display = "none"
    } else {
      wrapper.remove()
    }
  }
}
