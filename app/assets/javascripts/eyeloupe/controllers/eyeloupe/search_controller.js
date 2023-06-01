import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["frame"]

    submit(e) {
        e.preventDefault()
        let q = e.target.elements["q"].value
        this.frameTarget.src = this.frameTarget.src + "&q=" + q
    }
}
