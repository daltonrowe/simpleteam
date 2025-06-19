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

  toggleSet(event) {
    const { selector, classNames } = event.target.dataset;

    const sets = classNames.split(' ').reduce((acc, current) => {
      const [set, name] = current.split(':')
      acc[set].push(name)

      return acc
    }, { a: [], b: [] })

    const els = document.querySelectorAll(selector)

    if (!els.length) return;

    els.forEach(el => {
      const current = el.classList.contains(sets['a'][0]) ? 'a' : 'b'

      Object.keys(sets).forEach(set => {
        const action = set === current ? 'remove' : 'add'
        sets[set].forEach(className => {
          el.classList[action](className)
        })
      })
    })
  }
}
