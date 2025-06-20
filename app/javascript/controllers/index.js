// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
// import LineItemsController from "line_items_controller"
import LineItemsController from "controllers/line_items_controller"


eagerLoadControllersFrom("controllers", application)
application.register("line-items", LineItemsController)