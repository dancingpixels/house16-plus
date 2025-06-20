import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "container", "template", "priceDisplay", "priceField",
    "quantity", "lineTotal", "invoiceTotal"
  ]

  connect() {
    console.log("✅ line-items controller connected")
    this.updateInvoiceTotal()
  }

  add() {
    const time = new Date().getTime()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, time)
    this.containerTarget.insertAdjacentHTML("beforeend", content)
  }

  remove(event) {
    const wrapper = event.target.closest(".nested-fields")
    wrapper.querySelector("input[name*='_destroy']").value = 1
    wrapper.style.display = "none"
    this.updateInvoiceTotal()
  }

  updatePrice(event) {
    const select = event.target
    const wrapper = select.closest(".nested-fields")
    const selected = select.selectedOptions[0]
    const price = parseFloat(selected.dataset.price || 0).toFixed(2)

    const priceDisplay = wrapper.querySelector("[data-line-items-target='priceDisplay']")
    const priceField = wrapper.querySelector("[data-line-items-target='priceField']")

    priceDisplay.textContent = price
    priceField.value = price

    this.updateLineTotalFromWrapper(wrapper)
  }

  updateLineTotal(event) {
    const wrapper = event.target.closest(".nested-fields")
    this.updateLineTotalFromWrapper(wrapper)
  }

  updateLineTotalFromWrapper(wrapper) {
    const quantity = parseFloat(wrapper.querySelector("[data-line-items-target='quantity']")?.value || 0)
    const price = parseFloat(wrapper.querySelector("[data-line-items-target='priceField']")?.value || 0)
    const total = (quantity * price).toFixed(2)

    const totalDisplay = wrapper.querySelector("[data-line-items-target='lineTotal']")
    if (totalDisplay) totalDisplay.textContent = total

    this.updateInvoiceTotal()
  }

  updateInvoiceTotal() {
    let total = 0
    this.containerTarget.querySelectorAll(".nested-fields").forEach(wrapper => {
      if (wrapper.style.display === "none") return
      const quantity = parseFloat(wrapper.querySelector("[data-line-items-target='quantity']")?.value || 0)
      const price = parseFloat(wrapper.querySelector("[data-line-items-target='priceField']")?.value || 0)
      total += quantity * price
    })
    this.invoiceTotalTarget.textContent = total.toFixed(2)
  }
}
