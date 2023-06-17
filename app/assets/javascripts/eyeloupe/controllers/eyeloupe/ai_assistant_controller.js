import { Controller } from "@hotwired/stimulus"
import showdown from "showdown"
export default class extends Controller {
    static targets = ["result", "loader", "btn"]
    static values = { url: String }

    assist() {
        this.btnTarget.classList.add("hidden")
        this.resultTarget.innerHTML = ""
        this.loaderTarget.classList.remove("hidden")

        fetch(this.urlValue)
            .then(response => response.json())
            .then(json => {
                let result = json.choices[0].message.content
                let converter = new showdown.Converter()
                this.resultTarget.innerHTML = converter.makeHtml(result)

            })
            .catch(error => {
                this.resultTarget.innerHTML = error
            })
            .finally(() => {
                this.loaderTarget.classList.add("hidden")
            })
    }
}
