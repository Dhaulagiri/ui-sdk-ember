# Accordion

Show and hide sections of content from their headings.

Use an Accordion for content people can explore one section at a time, such as answers, settings, or a course outline. Each heading is a button that opens its panel.

```glimmer-ts title="basic.gts"
import { array } from "@ember/helper"
import { Accordion } from "ember-ui-sdk/accordion"
import { ChevronDown } from "lucide"
import { icon } from "./icon"

const items = [
  {
    value: "shipping",
    label: "What are your shipping options?",
    content: [
      "We offer standard (5 to 7 days), express (2 to 3 days) and overnight shipping.",
      "Every order ships with tracking, and orders over $50 ship free.",
    ],
  },
  {
    value: "returns",
    label: "What is your return policy?",
    content: [
      "Return any unused item in its original packaging within 30 days. Refunds arrive within 5 to 7 business days.",
    ],
  },
  {
    value: "support",
    label: "How can I reach support?",
    content: [
      "Write to us by email or chat, or call us. We answer within 24 hours on business days.",
    ],
  },
]

<template>
  <Accordion @defaultValue={{array "shipping"}} as |a|>
    {{#each items key="value" as |item|}}
      <a.Item @value={{item.value}} as |i|>
        <i.Header>
          <i.Trigger>
            {{item.label}}
            {{icon ChevronDown}}
          </i.Trigger>
        </i.Header>
        <i.Panel>
          {{#each item.content as |paragraph|}}
            <p>{{paragraph}}</p>
          {{/each}}
        </i.Panel>
      </a.Item>
    {{/each}}
  </Accordion>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Press “What is your return policy?”. Its answer opens and the shipping answer closes. Press the same heading again to close it.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Composition

Use the following composition to build an `Accordion`:

```text
Accordion as |a|
├── a.Item as |i|
│   ├── i.Header
│   │   └── i.Trigger
│   └── i.Panel
└── a.Item as |i|
    ├── i.Header
    │   └── i.Trigger
    └── i.Panel
```

Give every item a unique `@value`. Put its trigger inside a heading, then add the panel it opens. The accordion's value is always an array of open item values, even when only one can be open.

`i.Header` renders an `h3` by default. Use a heading level that fits the surrounding document. Tab moves between triggers; Enter or Space opens and closes their panels. Arrow keys, Home and End do nothing here: the APG removed them from the pattern, and a screen reader’s heading navigation already reaches each trigger.

## Usage

Import the root and use the parts it yields:

```gts
import { Accordion } from "ember-ui-sdk/accordion"

<template>
  <Accordion as |a|>
    <a.Item @value="shipping" as |i|>
      <i.Header>
        <i.Trigger>Shipping</i.Trigger>
      </i.Header>
      <i.Panel>Orders arrive in five to seven days.</i.Panel>
    </a.Item>
  </Accordion>
</template>
```

`ember-ui-sdk/accordion` also exports each part by name, such as `AccordionItem` and `AccordionTrigger`.

## Multiple

Set `@multiple={{true}}` to let several items stay open. Opening one then leaves the others as they are.

```glimmer-ts title="multiple.gts"
import { array } from "@ember/helper"
import { Accordion } from "ember-ui-sdk/accordion"
import { ChevronDown } from "lucide"
import { icon } from "./icon"

const items = [
  {
    value: "notifications",
    label: "Notification settings",
    content: "Choose what we email you about, and how often.",
  },
  {
    value: "privacy",
    label: "Privacy and security",
    content: "Turn on two-factor authentication and review signed-in devices.",
  },
  {
    value: "billing",
    label: "Billing and subscription",
    content: "Update your payment method and download past invoices.",
  },
]

<template>
  <Accordion @multiple={{true}} @defaultValue={{array "notifications"}} as |a|>
    {{#each items key="value" as |item|}}
      <a.Item @value={{item.value}} as |i|>
        <i.Header>
          <i.Trigger>
            {{item.label}}
            {{icon ChevronDown}}
          </i.Trigger>
        </i.Header>
        <i.Panel>{{item.content}}</i.Panel>
      </a.Item>
    {{/each}}
  </Accordion>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Open Privacy and security. Notification settings stays open; close either section independently.

## Disabled

Set `@disabled={{true}}` on an item or on a single trigger to prevent changes, or on the accordion to disable every item. Disabled triggers stay in the tab order so people can still discover them. A disabled `<fieldset>` around the accordion disables it too.

```glimmer-ts title="disabled.gts"
import { Accordion } from "ember-ui-sdk/accordion"
import { ChevronDown } from "lucide"
import { icon } from "./icon"

const items = [
  {
    value: "access",
    label: "Can I access my account history?",
    content:
      "Yes. Every order and payment from the last five years is in your account.",
  },
  {
    value: "premium",
    label: "Premium feature information",
    content:
      "Premium includes priority support and early access to new features.",
    disabled: true,
  },
  {
    value: "email",
    label: "How do I update my email address?",
    content:
      "Open Settings, then Account, and change it there. We'll send a confirmation link.",
  },
]

<template>
  <Accordion as |a|>
    {{#each items key="value" as |item|}}
      <a.Item @value={{item.value}} @disabled={{item.disabled}} as |i|>
        <i.Header>
          <i.Trigger>
            {{item.label}}
            {{icon ChevronDown}}
          </i.Trigger>
        </i.Header>
        <i.Panel>{{item.content}}</i.Panel>
      </a.Item>
    {{/each}}
  </Accordion>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Tab to Premium feature information. It stays focusable, and pressing it leaves its panel closed. Try “How do I update my email address?” instead.

<span id="behavior-and-options" />

## Collapsible

Set `@collapsible={{false}}` when the open item should stay open until another item replaces it. Pair it with `@defaultValue={{array "overview"}}` so a panel starts open.

The open trigger reports `aria-disabled="true"` because pressing it leaves its panel open.

```gts
<Accordion @collapsible={{false}} @defaultValue={{array "overview"}} as |a|>…</Accordion>
```

```glimmer-ts title="collapsible.gts"
import { array } from "@ember/helper"
import { Accordion } from "ember-ui-sdk/accordion"
import { ChevronDown } from "lucide"
import { icon } from "./icon"

const items = [
  {
    value: "overview",
    label: "Overview",
    content: "A summary of the project, its goals and its owners.",
  },
  {
    value: "timeline",
    label: "Timeline",
    content: "Kickoff in March, beta in June and launch in September.",
  },
  {
    value: "budget",
    label: "Budget",
    content: "Approved for two engineers and one designer for six months.",
  },
]

<template>
  <Accordion @collapsible={{false}} @defaultValue={{array "overview"}} as |a|>
    {{#each items key="value" as |item|}}
      <a.Item @value={{item.value}} as |i|>
        <i.Header>
          <i.Trigger>
            {{item.label}}
            {{icon ChevronDown}}
          </i.Trigger>
        </i.Header>
        <i.Panel>{{item.content}}</i.Panel>
      </a.Item>
    {{/each}}
  </Accordion>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Open Timeline, then press it again. It stays open until you choose another heading.

## Controlled

Pass `@value` and update it in `@onValueChange` to own the open items.

An item can refuse a change: call `details.cancel()` in its `@onOpenChange` callback. Item callbacks run before the accordion's `@onValueChange`, including the item that would close when another opens. Canceling any one of them cancels the whole change. `@onValueChange` also gets the [reason](#reasons) for the change.

```glimmer-ts title="controlled.gts"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Accordion, createAccordionController } from "ember-ui-sdk/accordion"
import { ChevronDown } from "lucide"
import { icon } from "./icon"

const items = [
  {
    value: "account",
    label: "Account",
    content: "Your name, email address and profile photo.",
  },
  {
    value: "security",
    label: "Security",
    content: "Your password, passkeys and two-factor authentication.",
  },
  {
    value: "sessions",
    label: "Sessions",
    content: "Devices signed in to your account in the last 30 days.",
  },
]

export default class Controlled extends Component {
  accordion = createAccordionController()
  @tracked value: string[] = ["account"]

  reviewSecurity = () => this.accordion.open("security")

  onValueChange = (next: string[]) => {
    this.value = next
  }

  confirmClose = (
    item: string,
    open: boolean,
    details: { cancel: () => void }
  ) => {
    if (
      !open &&
      item === "security" &&
      !window.confirm("Close the security settings?")
    ) {
      details.cancel()
    }
  }

  <template>
    <div>
      <div data-slot="controls">
        <button type="button" {{on "click" this.reviewSecurity}}>Review security</button>
      </div>
      <Accordion
        @multiple={{true}}
        @value={{this.value}}
        @onValueChange={{this.onValueChange}}
        @controller={{this.accordion}}
        as |a|
      >
        {{#each items key="value" as |item|}}
          <a.Item @value={{item.value}} @onOpenChange={{fn this.confirmClose item.value}} as |i|>
            <i.Header>
              <i.Trigger>
                {{item.label}}
                {{icon ChevronDown}}
              </i.Trigger>
            </i.Header>
            <i.Panel>{{item.content}}</i.Panel>
          </a.Item>
        {{/each}}
      </Accordion>
    </div>
  </template>
}
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Press Security to open it, then press it again. Cancel the confirmation and Security stays open; accept it and the section closes.

## Keep Mounted

A closed panel normally unmounts. Add `@keepMounted={{true}}` to one panel or the whole accordion to keep its content hidden in the page. This preserves local state, such as a draft in a field.

```glimmer-ts title="keep-mounted.gts"
import { array } from "@ember/helper"
import { Accordion } from "ember-ui-sdk/accordion"
import { Field } from "ember-ui-sdk/field"
import { Textarea } from "ember-ui-sdk/textarea"
import { ChevronDown } from "lucide"
import { icon } from "./icon"

<template>
  <Accordion @defaultValue={{array "reply"}} as |a|>
    <a.Item @value="reply" as |i|>
      <i.Header>
        <i.Trigger>
          Reply to this thread
          {{icon ChevronDown}}
        </i.Trigger>
      </i.Header>
      <i.Panel @keepMounted={{true}}>
        <Field as |f|>
          <f.Label>Message</f.Label>
          <Textarea rows="3" placeholder="Write a reply…" @field={{f.field}} />
        </Field>
      </i.Panel>
    </a.Item>
    <a.Item @value="formatting" as |i|>
      <i.Header>
        <i.Trigger>
          Formatting
          {{icon ChevronDown}}
        </i.Trigger>
      </i.Header>
      <i.Panel>
        <p>Use **bold**, _italics_ and `code`. Links paste as previews.</p>
      </i.Panel>
    </a.Item>
  </Accordion>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Write a message, switch to Formatting, then return to Reply to this thread. Your draft is still there.

## Find in Page

Add `@hiddenUntilFound={{true}}` to keep closed panels available to the browser's Find command. A match opens the item immediately, without an animation, with the [reason](#reasons) `find-in-page`.

```glimmer-ts title="find-in-page.gts"
import { Accordion } from "ember-ui-sdk/accordion"
import { ChevronDown } from "lucide"
import { icon } from "./icon"

const items = [
  {
    value: "fruit",
    label: "Which fruit do you stock?",
    content: "Apples, pears, mangoes and, in summer, pineapple.",
  },
  {
    value: "organic",
    label: "Is it organic?",
    content: "Everything we stock is certified organic.",
  },
  {
    value: "delivery",
    label: "When do you deliver?",
    content: "Every weekday morning before 10.",
  },
]

<template>
  <Accordion @hiddenUntilFound={{true}} as |a|>
    {{#each items key="value" as |item|}}
      <a.Item @value={{item.value}} as |i|>
        <i.Header>
          <i.Trigger>
            {{item.label}}
            {{icon ChevronDown}}
          </i.Trigger>
        </i.Header>
        <i.Panel>{{item.content}}</i.Panel>
      </a.Item>
    {{/each}}
  </Accordion>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Use your browser’s Find command to search for “pineapple”. The closed “Which fruit do you stock?” panel opens to reveal the match.

<span id="deep-links" />

A link to an element inside a closed panel can reveal it too. Give the target an `id` and link to it with a hash, such as `href="#refund-timeline"`.

```glimmer-ts title="deep-link.gts"
import { Accordion } from "ember-ui-sdk/accordion"
import { ChevronDown } from "lucide"
import { icon } from "./icon"

<template>
  <div>
    <nav data-slot="controls" aria-label="Jump to">
      <a href="#refund-timeline">Jump to the refund timeline</a>
      <a href="#return-label">Print a return label</a>
    </nav>
    <Accordion @hiddenUntilFound={{true}} as |a|>
      <a.Item @value="returns" as |i|>
        <i.Header>
          <i.Trigger>
            Returns
            {{icon ChevronDown}}
          </i.Trigger>
        </i.Header>
        <i.Panel>
          <div data-slot="stack">
            <p>
              Return any unused item in its original packaging within 30 days.
            </p>
            <p id="return-label">
              To print a return label, open the order and choose Return. The
              label is free.
            </p>
          </div>
        </i.Panel>
      </a.Item>
      <a.Item @value="refunds" as |i|>
        <i.Header>
          <i.Trigger>
            Refunds
            {{icon ChevronDown}}
          </i.Trigger>
        </i.Header>
        <i.Panel>
          <div data-slot="stack">
            <p>Refunds go back to the card you paid with.</p>
            <p id="refund-timeline">
              Timeline: we inspect the item within 2 days of receiving it, and
              your bank shows the refund 5 to 7 business days later.
            </p>
          </div>
        </i.Panel>
      </a.Item>
      <a.Item @value="exchanges" as |i|>
        <i.Header>
          <i.Trigger>
            Exchanges
            {{icon ChevronDown}}
          </i.Trigger>
        </i.Header>
        <i.Panel>
          <div data-slot="stack">
            <p>
              Start a return, choose Exchange and pick the new size. Shipping
              both ways is free.
            </p>
          </div>
        </i.Panel>
      </a.Item>
    </Accordion>
  </div>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Press Jump to the refund timeline. The closed Refunds panel opens and the browser moves to the linked paragraph.

For an initial URL hash, [open the item explicitly](#url-hash).

## Animation

Each part has a `data-slot`, such as `accordion-panel`. The panel exposes its measured height as `--accordion-panel-height`. Animate that height to or from zero with `data-starting-style` and `data-ending-style`:

```css
[data-slot="accordion-panel"] {
  height: var(--accordion-panel-height);
  overflow: hidden;
  transition: height 0.15s;

  &:is([data-starting-style], [data-ending-style]) {
    height: 0;
  }
}
```

The panel stays mounted until its exit animation finishes. An item's `@onOpenChangeComplete` runs afterward with the open state. A panel that starts open appears right away, with no animation and no completion callback.

```glimmer-ts title="animation.gts"
import { array } from "@ember/helper"
import { Accordion } from "ember-ui-sdk/accordion"
import { ChevronDown } from "lucide"
import { icon } from "./icon"

const items = [
  {
    value: "one",
    label: "Why animate the height?",
    content: "So the content below slides instead of jumping.",
  },
  {
    value: "two",
    label: "Where does the height come from?",
    content:
      "The panel measures itself and writes the result to a CSS variable while it animates.",
  },
  {
    value: "three",
    label: "Does it animate on first paint?",
    content: "No. Panels open on the server or on mount show at once.",
  },
]

<template>
  <Accordion @defaultValue={{array "one"}} as |a|>
    {{#each items key="value" as |item|}}
      <a.Item @value={{item.value}} as |i|>
        <i.Header>
          <i.Trigger>
            {{item.label}}
            {{icon ChevronDown}}
          </i.Trigger>
        </i.Header>
        <i.Panel>{{item.content}}</i.Panel>
      </a.Item>
    {{/each}}
  </Accordion>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Open or close an item. Its panel animates its height.

## Expand All

With `@multiple={{true}}`, a controller's `openAll()` opens every enabled item. `closeAll()` closes every item that may close. Create one with `createAccordionController()` and pass it as `@controller`.

```glimmer-ts title="expand-all.gts"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Accordion, createAccordionController } from "ember-ui-sdk/accordion"
import { ChevronDown } from "lucide"
import { icon } from "./icon"

const weeks = [
  {
    value: "week-1",
    label: "Week 1: Foundations",
    content:
      "Set up your editor, meet the command line and write your first script.",
  },
  {
    value: "week-2",
    label: "Week 2: Data and types",
    content:
      "Strings, numbers, lists and objects, and how to tell them apart when a program runs.",
  },
  {
    value: "week-3",
    label: "Week 3: Control flow",
    content:
      "Conditions, loops and functions. The project this week is a small text adventure.",
  },
  {
    value: "week-4",
    label: "Week 4: Working with files",
    content:
      "Read and write files, parse CSV and JSON, and handle the errors that come with them.",
  },
  {
    value: "week-5",
    label: "Week 5: Final project",
    content:
      "Build a tool you'll use yourself, then present it to the group in a five-minute demo.",
  },
]

export default class ExpandAll extends Component {
  syllabus = createAccordionController()
  @tracked pressed: string | null = null

  expandAll = () => this.syllabus.openAll()
  collapseAll = () => this.syllabus.closeAll()

  openChange = (value: string, open: boolean, details: { reason: string }) => {
    if (open && details.reason === "trigger-press") {
      this.pressed = value
    } else if (this.pressed === value) {
      this.pressed = null
    }
  }

  openChangeComplete = (value: string, open: boolean) => {
    if (!open || this.pressed !== value) {
      return
    }
    this.pressed = null
    document
      .getElementById(value)
      ?.scrollIntoView({ block: "nearest", behavior: "smooth" })
  }

  <template>
    <div>
      <div data-slot="controls">
        <button type="button" {{on "click" this.expandAll}}>Expand all</button>
        <button type="button" {{on "click" this.collapseAll}}>Collapse all</button>
      </div>
      <div data-slot="scroll">
        <Accordion @multiple={{true}} @controller={{this.syllabus}} as |a|>
          {{#each weeks key="value" as |week|}}
            <a.Item
              id={{week.value}}
              @value={{week.value}}
              @onOpenChange={{fn this.openChange week.value}}
              @onOpenChangeComplete={{fn this.openChangeComplete week.value}}
              as |i|
            >
              <i.Header>
                <i.Trigger>
                  {{week.label}}
                  {{icon ChevronDown}}
                </i.Trigger>
              </i.Header>
              <i.Panel>{{week.content}}</i.Panel>
            </a.Item>
          {{/each}}
        </Accordion>
      </div>
    </div>
  </template>
}
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Press Expand all or Collapse all. Open an individual week near the bottom to scroll it into view after its panel opens.

## Nested

Put another accordion inside a panel when a section has its own expandable sections. Each accordion tracks its own items. Give the inner headings a lower level than the outer headings.

```glimmer-ts title="nested.gts"
import { Accordion } from "ember-ui-sdk/accordion"
import { ChevronDown } from "lucide"
import { icon } from "./icon"

const sections = [
  {
    value: "profile",
    label: "Profile",
    content: "Your name, photo and the email address people see.",
  },
  {
    value: "notifications",
    label: "Notifications",
    topics: [
      {
        value: "email",
        label: "Email",
        content: "A weekly digest, and mentions as they happen.",
      },
      {
        value: "push",
        label: "Push",
        content: "Direct messages and replies to your comments.",
      },
    ],
  },
  {
    value: "billing",
    label: "Billing",
    topics: [
      {
        value: "payment",
        label: "Payment methods",
        content: "A Visa card ending in 4242, used for every renewal.",
      },
      {
        value: "invoices",
        label: "Invoices",
        content: "Download a PDF of any invoice from the last two years.",
      },
    ],
  },
]

<template>
  <Accordion @defaultValue={{array "notifications"}} as |a|>
    {{#each sections key="value" as |section|}}
      <a.Item @value={{section.value}} as |i|>
        <i.Header>
          <i.Trigger>
            {{section.label}}
            {{icon ChevronDown}}
          </i.Trigger>
        </i.Header>
        <i.Panel>
          {{#if section.topics}}
            <Accordion @multiple={{true}} as |n|>
              {{#each section.topics key="value" as |topic|}}
                <n.Item @value={{topic.value}} as |ti|>
                  <ti.Header @render={{true}} as |h|>
                    <h4 {{h.part}}>
                      <ti.Trigger>
                        {{topic.label}}
                        {{icon ChevronDown}}
                      </ti.Trigger>
                    </h4>
                  </ti.Header>
                  <ti.Panel>{{topic.content}}</ti.Panel>
                </n.Item>
              {{/each}}
            </Accordion>
          {{else}}
            <div>{{section.content}}</div>
          {{/if}}
        </i.Panel>
      </a.Item>
    {{/each}}
  </Accordion>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Open Billing, then Invoices inside it. The inner accordion changes without closing Billing.

## FAQ Search

<span id="faq-with-search" />

Combine a search field with a controlled accordion: filter the questions and set `@value` to the matching items. The example also highlights matches and leaves the triggers usable while the search is active.

```glimmer-ts title="search.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Accordion } from "ember-ui-sdk/accordion"
import { ChevronDown } from "lucide"
import { icon } from "./icon"

const faq = [
  {
    value: "returns",
    question: "What is your return policy?",
    answer:
      "Return any unused item within 30 days. Once it reaches us, your refund is on its way.",
  },
  {
    value: "refunds",
    question: "How long do refunds take?",
    answer:
      "Refunds reach your card within 5 to 7 business days after we receive the item.",
  },
  {
    value: "shipping",
    question: "Do you ship internationally?",
    answer:
      "We ship to 40 countries. Duties are included in the price at checkout.",
  },
  {
    value: "tracking",
    question: "How do I track my order?",
    answer:
      "Every shipping email has a tracking link. You'll also find it under Orders.",
  },
  {
    value: "exchange",
    question: "Can I exchange an item for another size?",
    answer:
      "Yes. Start a return, choose Exchange and pick the new size. Shipping is free.",
  },
  {
    value: "gift",
    question: "Can I send an order as a gift?",
    answer:
      "Add a gift note at checkout and we'll leave the prices off the packing slip.",
  },
]

type Question = (typeof faq)[number]
type Part = { text: string; match: boolean }

function matches(question: Question, query: string) {
  const search = query.trim().toLowerCase()
  return (
    !search ||
    question.question.toLowerCase().includes(search) ||
    question.answer.toLowerCase().includes(search)
  )
}

export default class Search extends Component {
  @tracked query = ""
  @tracked value: string[] = []

  get results() {
    return faq.filter((question) => matches(question, this.query))
  }

  get empty() {
    return this.results.length === 0
  }

  highlight = (text: string, query: string) => {
    const search = query.trim().toLowerCase()
    if (!search) {
      return [{ text, match: false }]
    }
    const parts: Part[] = []
    let start = 0
    for (let index = text.toLowerCase().indexOf(search); index !== -1;) {
      if (index > start) {
        parts.push({ text: text.slice(start, index), match: false })
      }
      parts.push({
        text: text.slice(index, index + search.length),
        match: true,
      })
      start = index + search.length
      index = text.toLowerCase().indexOf(search, start)
    }
    if (start < text.length) {
      parts.push({ text: text.slice(start), match: false })
    }
    return parts
  }

  search = (next: string) => {
    this.query = next
    this.value = next.trim()
      ? this.results.map((question) => question.value)
      : []
  }

  onInput = (event: Event) =>
    this.search((event.currentTarget as HTMLInputElement).value)

  onValueChange = (next: string[]) => {
    this.value = next
  }

  <template>
    <div>
      <div data-slot="controls">
        <input
          type="search"
          aria-label="Search questions"
          placeholder="Search questions…"
          value={{this.query}}
          {{on "input" this.onInput}}
        />
      </div>
      <Accordion @multiple={{true}} @value={{this.value}} @onValueChange={{this.onValueChange}} as |a|>
        {{#each this.results key="value" as |question|}}
          <a.Item @value={{question.value}} as |i|>
            <i.Header>
              <i.Trigger>
                <span>
                  {{#each
                    (this.highlight question.question this.query)
                    as |part|
                  }}
                    {{#if part.match}}<mark
                      >{{part.text}}</mark>{{else}}{{part.text}}{{/if}}
                  {{/each}}
                </span>
                {{icon ChevronDown}}
              </i.Trigger>
            </i.Header>
            <i.Panel>
              {{#each (this.highlight question.answer this.query) as |part|}}
                {{#if part.match}}<mark
                  >{{part.text}}</mark>{{else}}{{part.text}}{{/if}}
              {{/each}}
            </i.Panel>
          </a.Item>
        {{/each}}
      </Accordion>
      <p data-slot="hint" role="status">
        {{#if this.empty}}No questions match “{{this.query}}”.{{/if}}
      </p>
    </div>
  </template>
}
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Search for “refund” to show and open matching answers. Try “zzz” for the empty result, then clear the search to restore all questions.

## URL Hash

<span id="open-the-item-in-the-url-hash" />

A hash can name an item's `@value` instead of an element inside its panel. Read it after mount and on `hashchange`, then open and focus the matching item through your controller:

```ts
const value = decodeURIComponent(location.hash.slice(1))
if (items.some((item) => item.value === value)) {
  accordion.open(value)
  accordion.focus(value)
}
```

Check the value against your items first. A controller can hold a value even when no item renders it. Remove the `hashchange` listener when the component unmounts.

## Query String

<span id="keep-open-items-in-the-query-string" />

Use `open` query parameters when several items should be shareable. Read the initial values from your router on the server, then write accepted changes back to the URL:

```ts
function saveOpenItems(value: string[]) {
  const url = new URL(location.href)
  url.searchParams.delete("open")
  for (const item of value) url.searchParams.append("open", item)
  history.replaceState(null, "", url)
}
```

Call this from `@onValueChange` after updating your state. If your app already has a router, use its navigation API instead.

## Scroll into View

<span id="scroll-an-item-into-view" />

Scroll after `@onOpenChangeComplete`, when the panel has its full height. Scrolling in `@onOpenChange` would measure it before it opens. The [Expand All example](#expand-all) shows the full setup and scrolls only when someone opens a single item.

## Custom Rendering

<span id="render-functions" />

Pass `@render={{true}}` to a part to choose another heading level or element. The part yields `{ part, state }`: bind `part` to your element as a modifier, and read `state` to add to its content. Accordion's states are listed under [State](#state).

```glimmer-ts title="render.gts"
import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { Accordion } from "ember-ui-sdk/accordion"

const steps = [
  {
    value: "install",
    label: "Install the package",
    content: "Add it with your package manager. It has no dependencies.",
  },
  {
    value: "import",
    label: "Import the parts",
    content: "Import the accordion parts you need from the package.",
  },
  {
    value: "style",
    label: "Style it",
    content: "Every part renders its state as data attributes you can style.",
  },
]

export default class Render extends Component {
  position = (index: number) =>
    index >= 0 ? String(index + 1).padStart(2, "0") : ""

  <template>
    <Accordion @multiple={{true}} @defaultValue={{array "install"}} as |a|>
      {{#each steps key="value" as |step|}}
        <a.Item @value={{step.value}} as |i|>
          <i.Header @render={{true}} as |h|>
            <h4 {{h.part}}>
              <i.Trigger @render={{true}} as |t|>
                <button {{t.part}}>
                  <span data-slot="hint" aria-hidden="true">
                    {{this.position t.state.index}}
                  </span>
                  <span>{{step.label}}</span>
                  <span data-slot="hint" aria-hidden="true">
                    {{if t.state.open "Hide" "Show"}}
                  </span>
                </button>
              </i.Trigger>
            </h4>
          </i.Header>
          <i.Panel>{{step.content}}</i.Panel>
        </a.Item>
      {{/each}}
    </Accordion>
  </template>
}
```

Each step is an h4 with its number and a Show or Hide hint that follows its open state. Open Import the parts to see it update.

## Styling

Style the parts with the attributes below. This turns the chevron as its panel opens, mirrors it in right to left with `:dir(rtl)`, and dims disabled triggers:

```css
[data-slot="accordion-trigger"] {
  & > svg {
    rotate: -90deg;

    &:dir(rtl) {
      rotate: 90deg;
    }
  }

  &[data-open] > svg {
    rotate: 0deg;
  }

  &[data-disabled] {
    color: gray;
  }
}
```

### AccordionPanel
- `--accordion-panel-height`: The panel's content height in pixels while it animates, auto once open and 0px while closed.
- `--accordion-panel-width`: The panel's content width, the same way. For accordions that open sideways.

## Data Attributes

### Accordion
`[data-slot="accordion"]`

- `data-disabled`: Present when the whole accordion is disabled.

### AccordionItem
`[data-slot="accordion-item"]`

- `data-open`: Present while the item is open.
- `data-closed`: Present while the item is closed, including while its panel animates out.
- `data-disabled`: Present when the item can't open or close.

### AccordionHeader
`[data-slot="accordion-header"]`

- `data-open`: Present while the item is open.
- `data-closed`: Present while the item is closed, including while its panel animates out.
- `data-disabled`: Present when the item can't open or close.

### AccordionTrigger
`[data-slot="accordion-trigger"]`

- `data-open`: Present while the item is open.
- `data-closed`: Present while the item is closed, including while its panel animates out.
- `data-disabled`: Present when the item can't open or close.

### AccordionPanel
`[data-slot="accordion-panel"]`

- `data-open`: Present while the item is open.
- `data-closed`: Present while the item is closed, including while its panel animates out.
- `data-disabled`: Present when the item can't open or close.
- `data-starting-style`: Present for a panel's first frame. Style the state you animate from.
- `data-ending-style`: Present while a panel animates closed. Style the state you animate to.

## API Reference

Options and callbacks are the same as below, as arguments: `@value`, `@onValueChange`. Every part also takes `@render`. Headers, triggers and panels take their item's value from the item.

### Accordion

- `value?` (`T[]`): The open items' values. Pass it to control the accordion.
- `defaultValue?` (`T[]`): The items open at first, when uncontrolled.
- `onValueChange?` (`((value: T[], details: ChangeDetails<AccordionValueChangeReason>) => void)`): Runs when items want to open or close. `details.reason` says why, and `details.cancel()` stops it.
- `multiple?` (`boolean`): Whether several items can be open at once. Otherwise opening one closes the others.
- `collapsible?` (`boolean`): Whether the open item can close when only one may be open. With `false`, one item always stays open and its trigger reports it can't be pressed.
- `disabled?` (`boolean`): Stops every item from opening or closing. Triggers stay focusable.
- `keepMounted?` (`boolean`): Whether closed panels stay in the page, hidden.
- `hiddenUntilFound?` (`boolean`): Keeps closed panels in the page as `hidden="until-found"`, so the browser's find in page can match their text and open them.
- `controller?` (`object`): Opens and closes items from anywhere. Create one with `createAccordionController()`.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### AccordionItem

- `disabled?` (`boolean`): Stops the item from opening or closing. Its trigger stays focusable.
- `onOpenChange?` (`((open: boolean, details: ChangeDetails<AccordionValueChangeReason>) => void)`): Runs before the item opens or closes, before the accordion's `@onValueChange`. `details.cancel()` stops it.
- `onOpenChangeComplete?` (`((open: boolean) => void)`): Runs once the item's panel has finished opening or closing, after any animation.
- `value?` (`T`): Identifies the item. The accordion's value lists the open items' values. Defaults to a generated id.

### AccordionHeader

The header takes no options of its own, only the props of the element it renders.

### AccordionTrigger

- `disabled?` (`boolean`): Stops this trigger from opening or closing the item. It stays focusable.

### AccordionPanel

- `keepMounted?` (`boolean`): Whether the panel stays in the page, hidden, while closed. Overrides the accordion's.
- `hiddenUntilFound?` (`boolean`): Whether the panel stays findable with `hidden="until-found"` while closed. Overrides the accordion's.

### State

What `@render={{true}}` yields as `state`, per part.

`Accordion`:

- `value` (`T[]`): The open items' values.
- `disabled` (`boolean`): Whether the whole accordion is disabled, by its `disabled` option or a disabled fieldset around it.
- `multiple` (`boolean`): Whether several items can be open at once.

`AccordionItem`, `AccordionHeader`, `AccordionTrigger` and `AccordionPanel`:

- `open` (`boolean`): Whether the accordion's `value` holds this item's value.
- `disabled` (`boolean`): Whether the item can't open or close.
- `index` (`number`): The item's position among the accordion's items, from 0. -1 until it's in the page.

### Reasons

`details.reason` says why items opened or closed, for `@onValueChange` and every item's `@onOpenChange`.

- `trigger-press` (`MouseEvent | KeyboardEvent | TouchEvent`): Click, tap, Enter or Space on the part that opens, closes or toggles. Arrow keys that open a menu or submenu count too. A tap on a combobox's input that opens a sheet reports its `touchend`.
- `find-in-page` (`Event`): The browser's find in page matched hidden content.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

### Controller

Create one with `createAccordionController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, runs the item and accordion callbacks like a press, and returns `false` when the change is canceled or does nothing.

- `getValue()` (`() => T[]`): The open items' values.
- `setValue(value, options?)` (`(value: T[], options?: AccordionChangeOptions | undefined) => boolean`): Sets the open items. Only the first counts unless `multiple` is set. Returns false when canceled.
- `isOpen(value)` (`(value: T) => boolean`): Whether an item is open.
- `open(value, options?)` (`(value: T, options?: AccordionChangeOptions | undefined) => boolean`): Opens an item. With one item open at a time, closes the others.
- `close(value, options?)` (`(value: T, options?: AccordionChangeOptions | undefined) => boolean`): Closes an item, unless it's the one item that must stay open.
- `toggle(value, options?)` (`(value: T, options?: AccordionChangeOptions | undefined) => boolean`): Opens a closed item, or closes an open one.
- `openAll(options?)` (`(options?: AccordionChangeOptions | undefined) => boolean`): Opens every enabled item. Only when `multiple` is set.
- `closeAll(options?)` (`(options?: AccordionChangeOptions | undefined) => boolean`): Closes every item that may close.
- `focus(value?)` (`(value?: T | undefined) => void`): Moves focus to an item's trigger, or the first trigger.

### Events

Callbacks get the new state first, then the details.

| Argument                | On              | Receives                                                       |
| ----------------------- | --------------- | -------------------------------------------------------------- |
| `@onValueChange`        | `Accordion`     | `(value, details)`: the open items, and the [reason](#reasons) |
| `@onOpenChange`         | `AccordionItem` | `(open, details)`, before `@onValueChange`                     |
| `@onOpenChangeComplete` | `AccordionItem` | `(open)`, after the panel's animation                          |

## Accessibility

The accordion follows the [WAI-ARIA accordion pattern](https://www.w3.org/WAI/ARIA/apg/patterns/accordion/). Every line below is an automated test.

**Expanding and collapsing**

- The default item is expanded and shows its panel.
- Clicking a collapsed trigger expands it and collapses the open one.
- Clicking an expanded trigger collapses it.
- Clicking a disabled trigger does nothing.
- A change can be canceled.
- Without a default value, every item starts collapsed.
- A default value can expand several items.

**Multiple**

- Items expand and collapse independently.
- Every item can be expanded at once.

**Disabled**

- A disabled item's trigger is marked disabled and stays focusable.
- A disabled accordion disables every trigger.

**Keyboard**

- Tab moves through every trigger in order, disabled ones included.
- Enter toggles the focused trigger's panel.
- Space toggles the focused trigger's panel.
- Enter on a disabled trigger does nothing.
- Tab moves from an expanded trigger into its panel.
- Keys pressed in quick succession are never lost.
- Arrow keys leave focus where it is.

**Structure**

- Each trigger sits in a heading.
- The trigger controls its panel, and the panel is labelled by its trigger.

**Mounting**

- Collapsed panels leave the page by default.
- With keepMounted, collapsed panels stay in the page, hidden.
- With keepMounted, a class that sets display doesn't show collapsed panels.
- With hiddenUntilFound, collapsed panels stay findable.
- Finding text in a collapsed panel expands it.
- Following a link into a collapsed panel expands it.
- The browser's own find expands a collapsed panel.

Runs in React, Vue and web components.

Beyond the pattern's baseline:

**Enhancements**

- With collapsible off, the open trigger is marked disabled and stays open.
- Closing a panel that holds focus moves focus to its trigger.
- A canceled find in page keeps the panel hidden until found.
- An infinite exit animation still unmounts the panel.
- A controller expands and collapses items from anywhere.
- An item's onOpenChangeComplete runs once its panel has finished animating.
- Find in page opens a panel at once, without an animation.

Runs in React, Vue and web components.

Every panel is a region labelled by its trigger, so screen readers can list open panels as landmarks. With many panels open at once, such as `@multiple` with Expand all, keep the number of items modest so that list stays short.

Screen readers hear the same thing in each tested framework, recorded by a virtual screen reader:

- Announcements while using the accordion with a keyboard.

Runs in React, Vue and web components.
