import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"

// для правильной работы dropdawn подключение скриптов
import 'bootstrap/js/dist/dropdown'
// для отображения выпадающей формы
import 'bootstrap/js/dist/collapse'
import './scripts/select'

Rails.start()
Turbolinks.start()
ActiveStorage.start()