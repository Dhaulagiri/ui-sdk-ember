import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import type { ChangeDetails } from "@ui-sdk/core"
import { Pagination } from "ember-ui-sdk/pagination"
import RouterLink, { navigate } from "./RouterLink.gts"

const href = (page: number) => `#results-${page}`
const linkClass = (current: boolean) =>
  `pagination-link ${current ? "is-active" : "is-inactive"}`

export default class PaginationRenderFixture extends Component {
  @tracked action = ""

  onPageChange = (page: number, details: ChangeDetails) => {
    if (page === 4) {
      return details.cancel()
    }
    this.action = `page: ${page}`
  }

  <template>
    <div class="fixture" {{on "click" navigate}}>
      <button>Before</button>
      <Pagination
        aria-label="Results pages"
        @pageCount={{5}}
        @getHref={{href}}
        @onPageChange={{this.onPageChange}}
        as |p|
      >
        <p.List class="pagination-list" as |l|>
          <p.Item>
            <p.Previous @render={{true}} as |s|>
              <RouterLink
                @part={{s.part}}
                class="pagination-step"
              >Previous</RouterLink>
            </p.Previous>
          </p.Item>
          {{#each l.state.items key="@identity" as |item|}}
            <p.Item>
              <p.Link @page={{item}} @render={{true}} as |k|>
                <RouterLink
                  @part={{k.part}}
                  class={{linkClass k.state.current}}
                >
                  {{k.state.page}}{{#if k.state.current}}<span
                      aria-hidden="true"
                    >•</span>{{/if}}
                </RouterLink>
              </p.Link>
            </p.Item>
          {{/each}}
          <p.Item>
            <p.Next @render={{true}} as |s|>
              <RouterLink
                @part={{s.part}}
                class="pagination-step"
              >Next</RouterLink>
            </p.Next>
          </p.Item>
        </p.List>
      </Pagination>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
    </div>
  </template>
}
