import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Resizable, createResizableController } from "ember-ui-sdk/resizable"
import { useLog } from "../../../shared/ember/log"

export default class ControllerExample extends Component {
  log = useLog(this)
  editor = createResizableController()

  collapse = () => {
    this.editor.collapse("controller-sidebar")
  }

  expand = () => {
    this.editor.expand("controller-sidebar")
  }

  resize = () => {
    this.editor.resize("controller-sidebar", "240px")
  }

  read = () => {
    const collapsed = this.editor.isCollapsed("controller-sidebar")
      ? ", collapsed"
      : ""
    this.log(
      `Layout ${this.editor.getLayout().map(Math.round).join(" / ")}${collapsed}`
    )
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.collapse}}>Collapse</button>
        <button type="button" {{on "click" this.expand}}>Expand</button>
        <button type="button" {{on "click" this.resize}}>240px</button>
        <button type="button" {{on "click" this.read}}>Read</button>
      </div>
      <Resizable @controller={{this.editor}} as |r|>
        <r.Panel
          @id="controller-sidebar"
          @defaultSize={{30}}
          @minSize={{20}}
          @collapsible={{true}}
        >
          <h3>Files</h3>
          <ul>
            <li>page.tsx</li>
            <li>layout.tsx</li>
            <li>globals.css</li>
          </ul>
        </r.Panel>
        <r.Handle aria-label="Resize files" />
        <r.Panel @minSize={{30}}>
          <h3>page.tsx</h3>
          <span data-slot="hint">Saved just now</span>
        </r.Panel>
      </Resizable>
    </div>
  </template>
}
