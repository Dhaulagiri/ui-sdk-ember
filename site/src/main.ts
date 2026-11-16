import { renderComponent } from "@ember/renderer"
import "../../examples/styles/tokens.css"
import "../../examples/styles/base.css"
import "./site.css"
import { App } from "./app.gts"
import { apply, read } from "./theme.ts"

apply(read())

import.meta.glob("../../examples/components/*/*.css", { eager: true })

renderComponent(App, { into: document.getElementById("root")! })
