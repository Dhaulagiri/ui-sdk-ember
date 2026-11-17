import { hash } from "@ember/helper"
import type { ChangeDetails } from "@ui-sdk/core"
import Component from "@glimmer/component"
import {
  pagination,
  type PaginationController,
  type PaginationPageChangeReason,
} from "@ui-sdk/core/pagination"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import PaginationList from "./pagination-list.gts"
import PaginationItem from "./pagination-item.gts"
import PaginationLink from "./pagination-link.gts"
import PaginationEllipsis from "./pagination-ellipsis.gts"
import PaginationFirst from "./pagination-first.gts"
import PaginationPrevious from "./pagination-previous.gts"
import PaginationNext from "./pagination-next.gts"
import PaginationLast from "./pagination-last.gts"

/** A navigation landmark around the page links. Name it with `aria-label`. Yields its parts. */
class Pagination extends Component<{
  Element: HTMLElement
  Args: {
    /** The current page, from 1. Pass it with `@onPageChange` to control the pagination. */
    page?: number
    /** The page at first, when uncontrolled. */
    defaultPage?: number
    /** How many pages there are. */
    pageCount?: number
    /** How many items there are in all, to count pages with `@pageSize`. */
    total?: number
    /** How many items a page holds. */
    pageSize?: number
    /** How many pages show on each side of the current one. */
    siblings?: number
    /** How many pages show at each end. */
    boundaries?: number
    /** Makes the page links real links to this address. */
    getHref?: (page: number) => string
    /** Changes the page from anywhere. Create one with `createPaginationController()`. */
    controller?: PaginationController
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Runs when the page wants to change. `details.cancel()` stops it. */
    onPageChange?: (
      page: number,
      details: ChangeDetails<PaginationPageChangeReason>
    ) => void
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, pagination)
  get isLink() {
    return !!this.args.getHref
  }

  root = usePart(this, () => this.handle, "root")

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        List=(component PaginationList handle=this.handle)
        Item=(component PaginationItem handle=this.handle)
        Link=(component PaginationLink handle=this.handle isLink=this.isLink)
        Ellipsis=(component PaginationEllipsis handle=this.handle)
        First=(component PaginationFirst handle=this.handle isLink=this.isLink)
        Previous=(component
          PaginationPrevious handle=this.handle isLink=this.isLink
        )
        Next=(component PaginationNext handle=this.handle isLink=this.isLink)
        Last=(component PaginationLast handle=this.handle isLink=this.isLink)
      )
      as |p|
    }}
      {{#if @render}}
        {{yield p}}
      {{else}}
        <nav ...attributes {{this.root.modifier}}>{{yield p}}</nav>
      {{/if}}
    {{/let}}
  </template>
}

export default Pagination
