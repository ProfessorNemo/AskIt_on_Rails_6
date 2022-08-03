// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"



// для правильной работы dropdawn подключение скриптов
import '@popperjs/core'
import 'bootstrap/js/dist/dropdown'
// для отображения выпадающей формы
import 'bootstrap/js/dist/collapse'
import '../scripts/select'

Rails.start()
Turbolinks.start()
ActiveStorage.start()