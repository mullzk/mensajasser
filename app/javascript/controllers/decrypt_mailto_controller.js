import { Controller } from "@hotwired/stimulus"

// Decrypts an obfuscated mail address into a real mailto: href on connect.
// Usage: <a data-controller="decrypt-mailto" data-decrypt-mailto-address-value="…">
export default class extends Controller {
  static values = { address: String }

  connect() {
    this.element.href = "mailto:" + this.decrypt(this.addressValue)
  }

  decrypt(string) {
    return string
      .replace(/_AAA_/g, "@")
      .replace(/_PPP_/g, ".")
      .replace(/_KKK_/g, ",")
      .replace(/_SSS_/g, " ")
  }
}
