import { Controller } from "@hotwired/stimulus"

// Navbar submenu toggle. Shows/hides the sibling [toggle-view] element.
// Usage: <a toggle-link data-action="click->submenu#toggle">…</a><div toggle-view>…</div>
export default class extends Controller {
  toggle(event) {
    const submenu = event.currentTarget.nextElementSibling
    if (submenu?.hasAttribute("toggle-view")) {
      submenu.style.display =
        submenu.style.display !== "block" ? "block" : "none"
    }
    event.preventDefault()
    event.stopPropagation()
  }
}
