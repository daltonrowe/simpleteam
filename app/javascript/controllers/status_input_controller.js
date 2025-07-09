import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="status-input"
export default class extends Controller {
  focus(event) {
    if (event.target.value.length === 0) event.target.value = "- ";
  }

  enter(event) {
    event.preventDefault();
    event.target.value = event.target.value + "\n- ";
  }

  beforeInput(event) {
    if (event.inputType === "insertFromPaste") {
      let url;

      try {
        url = new URL(event.data);
      } catch (_error) {}

      if (url) this.createMarkdownLink(event);
    }
  }

  createMarkdownLink(event) {
    event.preventDefault();

    const beginning = event.target.value.substring(
      0,
      event.target.selectionStart,
    );
    const middle = event.target.value.substring(
      event.target.selectionStart,
      event.target.selectionEnd,
    );
    const end = event.target.value.substring(event.target.selectionEnd);

    const newValue = beginning + `[${middle}](${event.data})` + end;

    // doesn't trigger undo history change, but good enough for now
    // unsure if suitable alt to execCommand exists
    event.target.value = newValue;
  }

  blur(event) {
    if (event.target.value.trim() == "-") event.target.value = "";
  }

  submit() {
    this.element.requestSubmit();
  }
}
