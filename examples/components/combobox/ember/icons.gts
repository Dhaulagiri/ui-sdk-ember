import {
  ArrowRight,
  ChevronDown,
  Check,
  Circle,
  CircleCheck,
  CircleX,
} from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "../../../shared/ember/icon"

<template>
  <Combobox as |c|>
    <div data-slot="stack">
      <c.Label>Status</c.Label>
      <div id="status-field" data-slot="row">
        <c.ValueIcon />
        <c.Input placeholder="Select a status" />
        <c.Trigger aria-label="Show statuses">{{icon ChevronDown}}</c.Trigger>
      </div>
    </div>
    <c.Content @anchor="#status-field">
      <c.Empty>No statuses found.</c.Empty>
      <c.List>
        <c.Item @value="backlog" @label="Backlog" as |item|>
          <item.Icon>{{icon Circle}}</item.Icon>
          <item.Text />
          <item.Indicator>{{icon Check}}</item.Indicator>
        </c.Item>
        <c.Item @value="in-progress" @label="In progress" as |item|>
          <item.Icon @mirror={{true}}>{{icon ArrowRight}}</item.Icon>
          <item.Text />
          <item.Indicator>{{icon Check}}</item.Indicator>
        </c.Item>
        <c.Item @value="done" @label="Done" as |item|>
          <item.Icon>{{icon CircleCheck}}</item.Icon>
          <item.Text />
          <item.Indicator>{{icon Check}}</item.Indicator>
        </c.Item>
        <c.Item @value="canceled" @label="Canceled" as |item|>
          <item.Icon>{{icon CircleX}}</item.Icon>
          <item.Text />
          <item.Indicator>{{icon Check}}</item.Indicator>
        </c.Item>
      </c.List>
    </c.Content>
  </Combobox>
</template>
