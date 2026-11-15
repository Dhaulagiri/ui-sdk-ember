import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import {
  createResizableController,
  Resizable,
  type ResizableLayoutChangeDetails,
  type ResizableLayoutCommitDetails,
} from "ember-ui-sdk/resizable"
import {
  formatLayout,
  resizableFixture as f,
  resizableOptions,
} from "tests/fixtures/resizable.ts"

export default class ResizableFixture extends Component {
  f = f
  options = resizableOptions()
  controller = createResizableController()
  sidebar = f.editor.panels.sidebar
  main = f.editor.panels.main
  preview = f.editor.panels.preview
  code = f.main.panels.code
  terminal = f.main.panels.terminal
  @tracked action = ""
  @tracked committed: string[] = []
  @tracked layout = [25, 50, 25]

  get layoutValue() {
    return this.options.controlled ? this.layout : undefined
  }

  get committedText() {
    return this.committed.join(" ")
  }

  report(group: string, next: number[], details: ResizableLayoutChangeDetails) {
    if (group === f.editor.id && this.options.cancel) {
      return details.cancel()
    }
    this.action = formatLayout(group, next, details.reason)
  }

  commit(group: string, next: number[], details: ResizableLayoutCommitDetails) {
    this.committed = [
      ...this.committed,
      formatLayout(group, next, details.reason),
    ]
  }

  editorChange = (next: number[], details: ResizableLayoutChangeDetails) => {
    this.report(f.editor.id, next, details)
    if (!details.canceled && !this.options.ignore) {
      this.layout = next
    }
  }
  editorCommit = (next: number[], details: ResizableLayoutCommitDetails) =>
    this.commit(f.editor.id, next, details)
  areaChange = (next: number[], details: ResizableLayoutChangeDetails) =>
    this.report(f.main.id, next, details)
  areaCommit = (next: number[], details: ResizableLayoutCommitDetails) =>
    this.commit(f.main.id, next, details)

  collapse = () => this.controller.collapse(this.sidebar.id)
  expand = () => this.controller.expand(this.sidebar.id)
  resize = () => this.controller.resize(this.preview.id, f.previewSize)

  <template>
    <div class="fixture">
      <button>Before</button>
      <Resizable
        class="resizable"
        @layout={{this.layoutValue}}
        @orientation={{this.options.orientation}}
        @disabled={{this.options.disabled}}
        @step={{this.options.step}}
        @largeStep={{this.options.largeStep}}
        @autoSaveId={{this.options.autoSaveId}}
        @defaultLayout={{this.options.defaultLayout}}
        @controller={{this.controller}}
        @onLayoutChange={{this.editorChange}}
        @onLayoutCommit={{this.editorCommit}}
        as |r|
      >
        <r.Panel
          @id={{this.sidebar.id}}
          @defaultSize={{this.sidebar.defaultSize}}
          @minSize={{this.sidebar.minSize}}
          @maxSize={{this.sidebar.maxSize}}
          @collapsible={{this.sidebar.collapsible}}
          class="resizable-panel"
          role="group"
          aria-label={{this.sidebar.label}}
        >
          <button>Sidebar action</button>
        </r.Panel>
        <r.Handle
          class="resizable-handle"
          aria-label={{this.f.editor.handles.[0]}}
          @disabled={{this.options.locked}}
        />
        <r.Panel
          @id={{this.main.id}}
          @minSize={{this.main.minSize}}
          class="resizable-panel"
          role="group"
          aria-label={{this.main.label}}
        >
          <Resizable
            class="resizable-nested"
            @orientation="vertical"
            @onLayoutChange={{this.areaChange}}
            @onLayoutCommit={{this.areaCommit}}
            as |n|
          >
            <n.Panel
              @id={{this.code.id}}
              @defaultSize={{this.code.defaultSize}}
              @minSize={{this.code.minSize}}
              class="resizable-panel"
              role="group"
              aria-label={{this.code.label}}
            />
            <n.Handle
              class="resizable-handle"
              aria-label={{this.f.main.handle}}
            />
            <n.Panel
              @id={{this.terminal.id}}
              @minSize={{this.terminal.minSize}}
              @collapsible={{this.terminal.collapsible}}
              class="resizable-panel"
              role="group"
              aria-label={{this.terminal.label}}
            />
          </Resizable>
        </r.Panel>
        <r.Handle
          class="resizable-handle"
          aria-label={{this.f.editor.handles.[1]}}
        />
        <r.Panel
          @id={{this.preview.id}}
          @defaultSize={{this.preview.defaultSize}}
          @minSize={{this.preview.minSize}}
          class="resizable-panel"
          role="group"
          aria-label={{this.preview.label}}
        />
      </Resizable>
      <div class="row">
        <button
          {{on "click" this.collapse}}
        >{{this.f.buttons.collapse}}</button>
        <button {{on "click" this.expand}}>{{this.f.buttons.expand}}</button>
        <button {{on "click" this.resize}}>{{this.f.buttons.resize}}</button>
      </div>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output
        role="status"
        aria-label="Committed"
      >{{this.committedText}}</output>
    </div>
  </template>
}
