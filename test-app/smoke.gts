import { Tabs } from "ember-ui-sdk/tabs"
import { Dialog } from "ember-ui-sdk/dialog"
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
  {{! @glint-expect-error a numeric tab value is not a valid argument }}
  <Tabs @defaultValue={{123}} />
</template>
