import { Carousel } from "ember-ui-sdk/carousel"
import { ChevronDown, ChevronUp } from "lucide"
import { icon } from "../../../shared/ember/icon"

const slides = [1, 2, 3, 4, 5]

<template>
  <Carousel aria-label="Featured" @orientation="vertical" as |c|>
    <div data-slot="row">
      <c.Previous aria-label="Previous slide">{{icon ChevronUp}}</c.Previous>
      <c.Viewport>
        <c.Content>
          {{#each slides key="@identity" as |slide|}}
            <c.Item>
              <div data-slot="tile">{{slide}}</div>
            </c.Item>
          {{/each}}
        </c.Content>
      </c.Viewport>
      <c.Next aria-label="Next slide">{{icon ChevronDown}}</c.Next>
    </div>
  </Carousel>
</template>
