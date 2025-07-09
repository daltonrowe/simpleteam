import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="auto-remove"
export default class extends Controller {
  static values = {
    duration: Number,
  };

  connect() {
    const duration = this.hasDurationValue ? this.durationValue : 7000;
    const animation = 1000;

    this.element.style.setProperty("--duration", `${duration}ms`);
    this.element.classList.add("auto-fade");

    setTimeout(() => {
      this.element.remove();
    }, duration + animation);
  }
}
