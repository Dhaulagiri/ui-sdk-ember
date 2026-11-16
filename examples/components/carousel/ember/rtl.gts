import { ChevronLeft, ChevronRight } from "lucide"
import { Carousel } from "ember-ui-sdk/carousel"
import { icon } from "../../../shared/ember/icon"

const slides = [1, 2, 3, 4, 5]

<template>
  <div dir="rtl">
    <Carousel aria-label="مميز" as |c|>
      <c.Viewport>
        <c.Content>
          {{#each slides key="@identity" as |slide|}}
            <c.Item>
              <div data-slot="tile">
                {{slide}}
              </div>
            </c.Item>
          {{/each}}
        </c.Content>
      </c.Viewport>
      <div data-slot="row">
        <c.Previous aria-label="الشريحة السابقة">{{icon
            ChevronLeft
          }}</c.Previous>
        <c.IndicatorGroup aria-label="اختر شريحة" as |g|>
          {{#each slides key="@identity" as |slide|}}
            <g.Indicator @page={{slide}} aria-label="الشريحة {{slide}}" />
          {{/each}}
        </c.IndicatorGroup>
        <c.Next aria-label="الشريحة التالية">{{icon ChevronRight}}</c.Next>
      </div>
    </Carousel>
  </div>
</template>
