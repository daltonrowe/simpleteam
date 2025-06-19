import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle-class"
export default class extends Controller {
  toggle(event) {
    const { selector, classNames } = event.target.dataset;
    const classesArray = classNames.split(' ')

    const els = document.querySelectorAll(selector)

    if (els.length) {
      els.forEach(el => {
        classesArray.forEach(className => {
          el.classList.toggle(className)
        })
      })
    }
  }
}
