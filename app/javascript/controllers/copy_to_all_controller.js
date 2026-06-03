import { Controller } from "@hotwired/stimulus"

// Copies the changed field's value into every "field" target. Used in the
// round form so entering the number of games in one row fills all rows.
// Usage: <table data-controller="copy-to-all">
//          <input data-copy-to-all-target="field" data-action="change->copy-to-all#copy">
export default class extends Controller {
  static targets = ["field"]

  copy(event) {
    this.fieldTargets.forEach((field) => {
      field.value = event.currentTarget.value
    })
  }
}
