import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="status-input"
export default class extends Controller {
  focus(event) {
    if (event.target.value.length === 0) event.target.value = '- '
  }

  enter(event) {
    event.preventDefault();
    event.target.value = event.target.value + "\n- "
  }

  input(event) {
    if (event.target.value.length == 0) event.target.value = '- '
  }

  blur(event) {
    if (event.target.value.trim() == '-') event.target.value = '';
  }

  submit() {
    this.element.requestSubmit();
  }
}
