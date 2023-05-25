import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    SETTING_NAME = "eyeloupe-refresh"
    static targets = ["btn", "frame"]

    connect() {
        this._setActiveClass()
        this._setupRefresh()
    }

    toggle() {
        localStorage.setItem(this.SETTING_NAME, !this.enabled)
        this._setActiveClass()
        this._setupRefresh()
    }

    _setupRefresh() {
        if (this.enabled) {
            this._fetch()
            this.interval = setInterval(this._fetch.bind(this), 3000)
        } else {
            if (this.interval) {
                clearTimeout(this.interval)
            }
        }
    }

    _setActiveClass() {
        if (this.enabled) {
            this.btnTarget.classList.add("bg-red-500", "text-white", "hover:bg-red-600")
            this.btnTarget.classList.remove("bg-gray-200", "text-gray-500", "hover:bg-gray-300")
        } else {
            this.btnTarget.classList.remove("bg-red-500", "text-white", "hover:bg-red-600")
            this.btnTarget.classList.add("bg-gray-200", "text-gray-500", "hover:bg-gray-300")
        }
    }

    _fetch() {
        this.frameTarget.reload()
    }

    get enabled() {
        return localStorage.getItem(this.SETTING_NAME) === "true"
    }

}
