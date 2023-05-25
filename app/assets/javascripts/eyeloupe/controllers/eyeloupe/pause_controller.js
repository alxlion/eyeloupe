import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    SETTING_NAME = "eyeloupe-pause"
    static targets = ["btn"]
    static values = { enabled: Boolean }

    connect() {
        this._setActiveClass()
        this._setupRefresh()
    }

    toggle() {
        localStorage.setItem(this.SETTING_NAME, !this.enabled)
        this._setActiveClass()
    }

    _setActiveClass() {
        if (this.enabledValue) {
            this.btnTarget.classList.add("bg-red-500", "text-white", "hover:bg-red-600")
            this.btnTarget.classList.remove("bg-gray-200", "text-gray-500", "hover:bg-gray-300")
        } else {
            this.btnTarget.classList.remove("bg-red-500", "text-white", "hover:bg-red-600")
            this.btnTarget.classList.add("bg-gray-200", "text-gray-500", "hover:bg-gray-300")
        }
    }

}
