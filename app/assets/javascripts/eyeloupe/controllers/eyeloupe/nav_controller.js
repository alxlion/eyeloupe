import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["content"]

    close() {
        this.contentTarget.classList.add("hidden")
    }

    open() {
        this.contentTarget.classList.remove("hidden")
    }
}
