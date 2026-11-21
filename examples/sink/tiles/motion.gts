import { Frame, Image, Type } from "lucide"
import { Resizable } from "ember-ui-sdk/resizable"
import "../../../vendor/ui/apps/docs/app/sink/tiles/motion.css"
import { icon } from "../icon.ts"
import type { Tile } from "../types.ts"

/* 19. Resizable: split panes in a design tool */

const SplitPanes = <template>
  <Resizable class="mo-split" as |r|>
    <r.Panel
      @id="mo-layers"
      @defaultSize={{34}}
      @minSize={{24}}
      class="mo-split-panel"
    >
      <span class="mo-split-label">Layers</span>
      <ul class="mo-split-layers">
        <li>
          {{icon Frame 14}}
          <span>Page</span>
        </li>
        <li>
          {{icon Type 14}}
          <span>Title</span>
        </li>
        <li>
          {{icon Image 14}}
          <span>Cover</span>
        </li>
      </ul>
    </r.Panel>
    <r.Handle aria-label="Resize layers" class="mo-split-handle">
      <span class="mo-split-grip"></span>
    </r.Handle>
    <r.Panel
      @id="mo-canvas"
      @defaultSize={{30}}
      @minSize={{20}}
      class="mo-split-panel mo-split-canvas"
    >
      <span class="mo-split-board"></span>
    </r.Panel>
    <r.Handle aria-label="Resize inspector" class="mo-split-handle">
      <span class="mo-split-grip"></span>
    </r.Handle>
    <r.Panel
      @id="mo-inspector"
      @defaultSize={{36}}
      @minSize={{26}}
      class="mo-split-panel"
    >
      <span class="mo-split-label">Inspector</span>
      <dl class="mo-split-props">
        <div>
          <dt>W</dt>
          <dd>1440</dd>
        </div>
        <div>
          <dt>H</dt>
          <dd>900</dd>
        </div>
      </dl>
    </r.Panel>
  </Resizable>
</template>

export const tiles: Tile[] = [
  {
    id: "motion-split",
    title: "Split the workspace.",
    blurb: "Drag the dividers between panels.",
    tone: "paper",
    Demo: SplitPanes,
  },
]
