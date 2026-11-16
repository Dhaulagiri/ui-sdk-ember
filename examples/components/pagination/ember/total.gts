import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import { Pagination } from "ember-ui-sdk/pagination"
import { ChevronLeft, ChevronRight, Ellipsis } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const total = 95

export default class Total extends Component {
  log = useLog(this)
  @tracked page = 2
  @tracked pageSize = 20

  isNumber = (item: number | string) => typeof item === "number"

  get rangeStart() {
    return (this.page - 1) * this.pageSize + 1
  }

  get rangeEnd() {
    return Math.min(this.page * this.pageSize, total)
  }

  onchange = (event: Event) => {
    const select = event.currentTarget as HTMLSelectElement
    this.pageSize = Number(select.value)
    this.page = 1
    this.log(`${select.value} rows per page`)
  }

  onPageChange = (next: number) => {
    this.page = next
    this.log(`Page ${next}`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="row">
        <p>Showing {{this.rangeStart}}–{{this.rangeEnd}} of {{total}}</p>
        <label data-slot="label">
          Rows per page
          <select value={{this.pageSize}} {{on "change" this.onchange}}>
            <option value="10">10</option>
            <option value="20">20</option>
            <option value="50">50</option>
          </select>
        </label>
      </div>
      <Pagination
        @page={{this.page}}
        @total={{total}}
        @pageSize={{this.pageSize}}
        @onPageChange={{this.onPageChange}}
        aria-label="Pagination"
        as |p|
      >
        <p.List as |l|>
          <p.Item>
            <p.Previous data-variant="ghost">
              {{icon ChevronLeft}}
              <span data-slot="visually-hidden">Previous</span>
            </p.Previous>
          </p.Item>
          {{#each l.state.items key="@identity" as |item|}}
            <p.Item>
              {{#if (this.isNumber item)}}
                <p.Link data-variant="ghost" @page={{item}} />
              {{else}}
                <p.Ellipsis>{{icon Ellipsis}}</p.Ellipsis>
              {{/if}}
            </p.Item>
          {{/each}}
          <p.Item>
            <p.Next data-variant="ghost">
              <span data-slot="visually-hidden">Next</span>
              {{icon ChevronRight}}
            </p.Next>
          </p.Item>
        </p.List>
      </Pagination>
    </div>
  </template>
}
