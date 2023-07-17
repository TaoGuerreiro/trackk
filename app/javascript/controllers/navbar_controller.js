import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  static targets = [ "menu" ]
  connect() {
    console.log("coucou");
  }

  display() {
    this.menuTarget.classList.toggle("hidden");
  }

}
