import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="checkbox-group"
// Provides select-all / deselect-all behavior for a group of checkboxes.
// Mark each checkbox with data-checkbox-group-target="checkbox".
export default class extends Controller {
  static targets = ["checkbox"];

  selectAll() {
    this.setAll(true);
  }

  deselectAll() {
    this.setAll(false);
  }

  setAll(checked) {
    this.checkboxTargets.forEach((checkbox) => {
      checkbox.checked = checked;
    });
  }
}
