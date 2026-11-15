import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import type { ChangeDetails } from "@ui-sdk/core"
import {
  createPaginationController,
  Pagination,
} from "ember-ui-sdk/pagination"
import {
  paginationAction,
  paginationFixture as f,
  paginationOptions,
} from "tests/fixtures/pagination.ts"

export default class PaginationFixture extends Component {
  f = f
  options = paginationOptions()
  pages = createPaginationController()
  @tracked action = ""
  @tracked page = this.options.defaultPage ?? 1

  get keys() {
    return [this.options.rekey ? this.page : undefined]
  }

  onPageChange = (next: number, details: ChangeDetails) => {
    if (next === this.options.cancel) {
      return details.cancel()
    }
    this.page = next
    this.action = paginationAction(next, details.reason)
  }

  setPage = () => this.pages.setPage(f.controller.page)
  isNumber = (item: unknown) => typeof item === "number"

  <template>
    <div class="fixture">
      <button>Before</button>
      <Pagination
        aria-label={{this.f.label}}
        class="pagination"
        @controller={{this.pages}}
        @pageCount={{this.options.pageCount}}
        @siblings={{this.options.siblings}}
        @boundaries={{this.options.boundaries}}
        @getHref={{this.options.getHref}}
        @page={{if this.options.controlled this.page}}
        @defaultPage={{unless this.options.controlled this.options.defaultPage}}
        @onPageChange={{this.onPageChange}}
        as |p|
      >
        {{#each this.keys key="@identity"}}
          <p.List class="pagination-list" as |l|>
            <p.Item>
              <p.First
                class="pagination-step"
                aria-label={{this.f.first}}
              >«</p.First>
            </p.Item>
            <p.Item>
              <p.Previous
                class="pagination-step"
                aria-label={{this.f.previous}}
              >‹</p.Previous>
            </p.Item>
            {{#each l.state.items key="@identity" as |item|}}
              <p.Item>
                {{#if (this.isNumber item)}}
                  <p.Link class="pagination-link" @page={{item}} />
                {{else}}
                  <p.Ellipsis class="pagination-ellipsis" />
                {{/if}}
              </p.Item>
            {{/each}}
            <p.Item>
              <p.Next
                class="pagination-step"
                aria-label={{this.f.next}}
              >›</p.Next>
            </p.Item>
            <p.Item>
              <p.Last
                class="pagination-step"
                aria-label={{this.f.last}}
              >»</p.Last>
            </p.Item>
          </p.List>
        {{/each}}
      </Pagination>
      <button {{on "click" this.setPage}}>{{this.f.controller.label}}</button>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
    </div>
  </template>
}
