import { SegmentedControl } from "ember-ui-sdk/segmented-control"

<template>
  <div data-slot="stack">
    <SegmentedControl
      aria-label="Theme"
      @defaultValue="system"
      @disabled={{true}}
      as |s|
    >
      <s.Indicator />
      <s.Item @value="light">Light</s.Item>
      <s.Item @value="dark">Dark</s.Item>
      <s.Item @value="system">System</s.Item>
    </SegmentedControl>
    <SegmentedControl
      aria-label="Billing period"
      @defaultValue="monthly"
      as |s|
    >
      <s.Indicator />
      <s.Item @value="monthly">Monthly</s.Item>
      <s.Item @value="yearly">Yearly</s.Item>
      <s.Item @value="lifetime" @disabled={{true}}>Lifetime</s.Item>
    </SegmentedControl>
  </div>
</template>
