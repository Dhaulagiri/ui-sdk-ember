// Type tests for what the roots yield, checked against the built declarations
// by `pnpm typecheck`. Each access below fails under
// `noPropertyAccessFromIndexSignature` if a root yields `Record<string, any>`.
import type { ModifierLike } from "@glint/template"
import type { CollapsiblePrimitive } from "@ui-sdk/core/collapsible"
import type { TabsPrimitive } from "@ui-sdk/core/tabs"
import { Collapsible } from "ember-ui-sdk/collapsible"
import type { PartModifier, PrimitiveHandle } from "ember-ui-sdk/primitive"
import { Tabs } from "ember-ui-sdk/tabs"

// The modifier a part yields binds any element, so it also fits an app's
// narrower `ModifierLike<{ Element: HTMLElement }>`.
const htmlModifier = (_part: ModifierLike<{ Element: HTMLElement }>) => ""
const partModifier = (_part: PartModifier) => ""
const boolean = (_value: boolean) => ""
const text = (_value: string | null) => ""
const collapsibleHandle = (_handle: PrimitiveHandle<CollapsiblePrimitive>) => ""
const tabsHandle = (_handle: PrimitiveHandle<TabsPrimitive>) => ""

<template>
  <Collapsible @render={{true}} @defaultOpen={{true}} as |c|>
    <div {{c.part}}>
      {{htmlModifier c.part}}
      {{partModifier c.part}}
      {{boolean c.state.open}}
      {{boolean c.state.disabled}}
      {{collapsibleHandle c.handle}}
      <c.Trigger as |trigger|>{{boolean trigger.state.open}}</c.Trigger>
      <c.Panel @render={{true}} @keepMounted={{true}} as |panel|>
        <section {{panel.part}}>{{htmlModifier panel.part}}</section>
      </c.Panel>
      {{! @glint-expect-error the trigger is a button }}
      <c.Trigger href="/" />
      {{! @glint-expect-error a collapsible has no such part }}
      <c.Tab />
      {{! @glint-expect-error the state has no such key }}
      {{boolean c.state.selected}}
    </div>
  </Collapsible>

  <Tabs @defaultValue="a" as |t|>
    {{htmlModifier t.part}}
    {{text t.state.value}}
    {{tabsHandle t.handle}}
    <t.List>
      <t.Tab @value="a" as |tab|>{{boolean tab.state.selected}}</t.Tab>
      <t.Tab @value="b" @disabled={{true}}>B</t.Tab>
      <t.Indicator />
    </t.List>
    <t.Panel @value="a" as |panel|>{{htmlModifier panel.part}}</t.Panel>
    <t.Panel @value="b">B</t.Panel>
    {{! @glint-expect-error a tab's value is a string }}
    <t.Tab @value={{1}} />
    {{! @glint-expect-error the yielded parts already have the handle }}
    {{collapsibleHandle t.handle}}
    {{! @glint-expect-error tabs have no such part }}
    <t.Trigger />
  </Tabs>
</template>
