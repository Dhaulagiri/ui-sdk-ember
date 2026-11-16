import { HoverCard } from "ember-ui-sdk/hover-card"

<template>
  <div dir="rtl">
    <HoverCard as |h|>
      <h.Trigger href="https://example.com/people/hollis">هوليس غرانت</h.Trigger>
      <h.Content @align="start" @sideOffset={{10}}>
        <h.Arrow />
        <p>هوليس غرانت</p>
        <p>مهندس تصميم في فريق المدفوعات.</p>
      </h.Content>
    </HoverCard>
  </div>
</template>
