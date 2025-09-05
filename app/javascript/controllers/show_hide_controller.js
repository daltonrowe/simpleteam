import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="show-hide"
export default class extends Controller {
  toggle() {
    const els = this.element.querySelectorAll("details");
    const allOpen = Array.from(els).every((el) => !!el.getAttribute("open"));

    if (allOpen) {
      els.forEach((el) => el.removeAttribute("open"));
    } else {
      els.forEach((el) => el.setAttribute("open", "true"));
    }
  }
}
