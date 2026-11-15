import { registerDestructor } from "@ember/destroyable"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Tree } from "ember-ui-sdk/tree"
import { treeLinksFixture } from "tests/fixtures/tree.ts"
import TreeFixtureItems from "../tree/TreeFixtureItems.gts"

export default class TreeLinksFixture extends Component {
  f = treeLinksFixture
  @tracked current = location.hash.slice(1) || "usage"

  constructor(owner: Owner, args: object) {
    super(owner, args)
    const changed = () => (this.current = location.hash.slice(1))
    window.addEventListener("hashchange", changed)
    registerDestructor(this, () =>
      window.removeEventListener("hashchange", changed)
    )
  }

  <template>
    <div class="fixture">
      <button>Before</button>
      <Tree
        class="tree"
        aria-label={{this.f.label}}
        @items={{this.f.items}}
        @mode="none"
        @current={{this.current}}
        as |t|
      >
        <TreeFixtureItems
          @parts={{t}}
          @items={{this.f.items}}
          @checkable={{false}}
        />
      </Tree>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.current}}</output>
    </div>
  </template>
}
