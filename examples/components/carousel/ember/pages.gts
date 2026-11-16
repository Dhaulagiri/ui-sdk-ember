import { ChevronLeft, ChevronRight } from "lucide"
import { Carousel } from "ember-ui-sdk/carousel"
import { icon } from "../../../shared/ember/icon"

const products = [1, 2, 3, 4, 5, 6, 7, 8]

const pagesOf = (count?: number) =>
  Array.from({ length: count ?? 3 }, (_, index) => index + 1)

<template>
  <Carousel aria-label="Products" @slidesPerPage={{3}} as |c|>
    <div data-slot="row">
      <c.Previous aria-label="Previous page">{{icon ChevronLeft}}</c.Previous>
      <c.Viewport>
        <c.Content>
          {{#each products key="@identity" as |product|}}
            <c.Item>
              <div data-slot="tile">{{product}}</div>
            </c.Item>
          {{/each}}
        </c.Content>
      </c.Viewport>
      <c.Next aria-label="Next page">{{icon ChevronRight}}</c.Next>
    </div>
    <div data-slot="row">
      <c.IndicatorGroup aria-label="Choose a page" as |g|>
        {{#each (pagesOf g.state.pageCount) key="@identity" as |n|}}
          <g.Indicator @page={{n}} aria-label="Page {{n}}" />
        {{/each}}
      </c.IndicatorGroup>
    </div>
  </Carousel>
</template>
