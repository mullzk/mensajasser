import { Controller } from "@hotwired/stimulus"

// Mobile navbar toggle. Bootstrap's own JS is not loaded, so this reproduces
// the collapse toggle: clicking the toggler shows/hides every .navbar-collapse.
// Usage: <nav data-controller="navbar-toggle">
//          <button data-action="click->navbar-toggle#toggle">…</button>
export default class extends Controller {
  toggle(event) {
    document.querySelectorAll(".navbar .navbar-collapse").forEach((collapse) => {
      collapse.classList.toggle("show")
    })
    event.preventDefault()
    event.stopPropagation()
  }
}
