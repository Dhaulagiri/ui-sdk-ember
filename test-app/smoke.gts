import { Tabs } from "ember-ui-sdk/tabs"
import { array } from "@ember/helper"
import { Dialog } from "ember-ui-sdk/dialog"
import { Combobox } from "ember-ui-sdk/combobox"
import { attach } from "ember-ui-sdk/primitive"
import type { ComponentLike } from "@glint/template"

const TypedTabs: ComponentLike<{
  Args: { defaultValue?: string | null }
  Blocks: { default: [Record<string, any>] }
  Element: HTMLDivElement
}> = Tabs

const attachment = (_element: Element) => {}

<template>
  <TypedTabs @defaultValue="a" />
  <Dialog @defaultOpen={{false}} />
  <div {{attach attachment}}></div>
  <Combobox as |c|>
    <c.Label>Country</c.Label>
    <c.Input />
    <c.Clear>Clear</c.Clear>
    <c.Trigger>Choose</c.Trigger>
    <c.Content>
      <c.Empty>No countries</c.Empty>
      <c.List>
        <c.Item @value="fr" as |item|>
          <item.Text>France</item.Text>
          <item.Indicator>Selected</item.Indicator>
          <item.Icon />
          {{! @glint-expect-error unknown item parts are not supported }}
          <item.DoesNotExist />
        </c.Item>
        <c.Group as |group|>
          <group.Label>Europe</group.Label>
          <group.Item @value="de" as |item|>
            <item.Text>Germany</item.Text>
            <item.Indicator>Selected</item.Indicator>
          </group.Item>
          <group.Items @items={{array "es" "it"}} />
          <group.SelectAll>Select Europe</group.SelectAll>
        </c.Group>
      </c.List>
    </c.Content>
    <c.Chip @value="fr" as |chip|>
      <chip.Remove>Remove France</chip.Remove>
    </c.Chip>
    {{! @glint-expect-error unknown root parts are not supported }}
    <c.DoesNotExist />
    {{! @glint-expect-error Input keeps its actual argument types }}
    <c.Input @shared="invalid" />
  </Combobox>
  {{! @glint-expect-error a numeric tab value is not a valid argument }}
  <Tabs @defaultValue={{123}} />
</template>
