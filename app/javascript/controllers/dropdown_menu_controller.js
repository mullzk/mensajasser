import { Controller } from "@hotwired/stimulus"

// Navbar dropdown toggle (Bootstrap's JS is not loaded). Clicking a dropdown
// toggle opens its menu and closes any other open dropdown menu.
// Usage: <a data-action="click->dropdown-menu#toggle">…</a> followed by .dropdown-menu
export default class extends Controller {
  toggle(event) {
    const current = event.currentTarget.nextElementSibling
    document.querySelectorAll(".dropdown .dropdown-menu").forEach((menu) => {
      if (menu.style.display !== "block") {
        if (menu === current) {
          menu.style.display = "block"
        }
      } else {
        menu.style.display = "none"
      }
    })
    event.preventDefault()
    event.stopPropagation()
  }
}
