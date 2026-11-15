import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Resizable } from "ember-ui-sdk/resizable"

const counts = { renders: 0 }

export default class Fixture extends Component {
  @tracked action = ""

  constructor(owner: Owner, args: object) {
    super(owner, args)
    Object.assign(window, { panelRenders: counts })
  }

  count = (..._reads: unknown[]) => {
    counts.renders++
    return true
  }

  round = (size: number) => Math.round(size)

  onLayoutCommit = (layout: number[]) => {
    this.action = `layout:${layout.map(Math.round)}`
  }

  <template>
    <div class="fixture">
      <button>Before</button>
      <Resizable
        class="resizable"
        @onLayoutCommit={{this.onLayoutCommit}}
        as |r|
      >
        <r.Panel
          @defaultSize={{30}}
          @collapsible={{true}}
          @minSize={{10}}
          class="resizable-panel"
          role="group"
          aria-label="Files"
          as |panel|
        >
          {{#if (this.count panel.state.collapsed)}}
            <span class="panel-state">{{if
                panel.state.collapsed
                "Collapsed"
                "Open"
              }}</span>
          {{/if}}
        </r.Panel>
        <r.Handle
          aria-label="Resize files"
          class="resizable-handle"
          @render={{true}}
          as |handle|
        >
          <span
            aria-label="Resize files"
            class="resizable-handle"
            {{handle.part}}
          >
            <span class="handle-state">{{if
                handle.state.dragging
                "dragging"
                "idle"
              }}</span>
          </span>
        </r.Handle>
        <r.Panel
          class="resizable-panel"
          role="group"
          aria-label="Editor"
          as |panel|
        >
          <span class="panel-size">{{this.round panel.state.size}}</span>
        </r.Panel>
      </Resizable>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
    </div>
  </template>
}
