# Menu

Choose actions and settings from a button or a context menu.

Start with a trigger and a few actions. Add groups, checkboxes, radio choices, or submenus as the task grows. The menu handles focus, arrow keys, typeahead, and dismissal.

<ComponentExample
  name="menu/basic"
  inspect
  caption="Press Open Menu and choose an item, with the pointer or the arrow keys and Enter. The menu closes and the console logs your choice."
/>

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Composition

Use the following composition to build a `Menu`:

```text
Menu as |m|
├── m.Trigger
└── m.Content
    ├── m.Item
    └── m.Item
```

Give items a `@value` and handle `@onAction` on the menu to run the selected command. A Group and its Label can organize related actions; a Separator divides them without becoming a focus stop.

Return a promise from `@onAction` or an item’s `@onSelect` to keep the item pending. It gets `data-pending`, `aria-busy` and `aria-disabled`, the menu stays open, and choosing it again does nothing until the promise settles. The menu closes once it resolves. A rejection keeps it open and puts the reason in the item’s `error` state until the next try. After a second, screen readers hear `pendingAnnouncement`, “Loading” by default.

## Usage

Import the root and use the parts it yields:

```gts
import { Menu } from "ember-ui-sdk/menu"

<template>
  <Menu as |m|>
    <m.Trigger>Actions</m.Trigger>
    <m.Content>
      <m.Item @value="rename">Rename</m.Item>
      <m.Item @value="duplicate">Duplicate</m.Item>
    </m.Content>
  </Menu>
</template>
```

## Submenus

Nest a `m.Sub` with its own `s.Trigger` and `s.Content` to add another level. Hover or press the arrow key toward a submenu to open it. The menu lets a pointer travel diagonally into the submenu without accidentally choosing an item it passes over. Escape closes only the submenu and returns focus to its trigger, as the menu pattern asks.

```glimmer-ts title="submenu.gts"
import Component from "@glimmer/component"
import { ChevronRight } from "lucide"
import { Menu } from "ember-ui-sdk/menu"
import { icon } from "./icon"
import { useLog } from "./log"

export default class Submenu extends Component {
  log = useLog(this)

  onAction = (value: string) => {
    this.log(`Chose ${value}`)
  }

  <template>
    <Menu @onAction={{this.onAction}} as |m|>
      <m.Trigger>Edit</m.Trigger>
      <m.Content>
        <m.Item @value="undo" @shortcut="mod+z">Undo</m.Item>
        <m.Item @value="redo" @shortcut="mod+shift+z">Redo</m.Item>
        <m.Separator />
        <m.Sub as |s|>
          <s.Trigger>
            Find
            {{icon ChevronRight}}
          </s.Trigger>
          <s.Content>
            <s.Item @value="find" @shortcut="mod+f">Find…</s.Item>
            <s.Item @value="find-next" @shortcut="mod+g">Find next</s.Item>
            <s.Item @value="find-previous" @shortcut="mod+shift+g">Find previous</s.Item>
          </s.Content>
        </m.Sub>
        <m.Sub as |s|>
          <s.Trigger>
            Transform
            {{icon ChevronRight}}
          </s.Trigger>
          <s.Content>
            <s.Sub as |s2|>
              <s2.Trigger>
                Case
                {{icon ChevronRight}}
              </s2.Trigger>
              <s2.Content>
                <s2.Item @value="uppercase">Uppercase</s2.Item>
                <s2.Item @value="lowercase">Lowercase</s2.Item>
              </s2.Content>
            </s.Sub>
            <s.Item @value="trim">Trim whitespace</s.Item>
          </s.Content>
        </m.Sub>
      </m.Content>
    </Menu>
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

Open Edit, then Find or Transform. Use the arrows to enter and leave each level; choosing an action closes the menu tree.

## Shortcuts

An item’s `@shortcut` displays a platform-specific hint and sets `aria-keyshortcuts`. `mod+s` reads as Command+S on Apple platforms and Control+S elsewhere.

In markup, this is a hint: your app owns the key handler. [Data menus](#menus-as-data) also register their shortcuts while closed. Letters and digits match physical keys, including combinations such as Option+N.

```glimmer-ts title="shortcuts.gts"
import Component from "@glimmer/component"
import { Menu } from "ember-ui-sdk/menu"
import { useLog } from "./log"

export default class Shortcuts extends Component {
  log = useLog(this)

  onAction = (value: string) => {
    this.log(`Chose ${value}`)
  }

  <template>
    <Menu @onAction={{this.onAction}} as |m|>
      <m.Trigger>File</m.Trigger>
      <m.Content>
        <m.Item @value="new-tab" @shortcut="mod+t">New tab</m.Item>
        <m.Item @value="new-window" @shortcut="mod+n">New window</m.Item>
        <m.Item @value="open" @shortcut="mod+o">Open…</m.Item>
        <m.Separator />
        <m.Item @value="save" @shortcut="mod+s">Save</m.Item>
        <m.Item @value="save-as" @shortcut="mod+shift+s">Save as…</m.Item>
        <m.Separator />
        <m.Item @value="print" @shortcut="mod+p">Print…</m.Item>
      </m.Content>
    </Menu>
  </template>
}
```

Open File to see shortcut hints for your platform. Choose an item to report its action; this markup example does not register global shortcuts.

## Icons

Put decorative icons in `m.ItemIcon` so screen readers and typeahead ignore them. `@mirror={{true}}` flips a directional icon in right-to-left text. An icon-only item still needs an `aria-label`.

`data-has-icon` on items and `data-has-icons` on the menu let text line up when only some items have icons.

```glimmer-ts title="icons.gts"
import Component from "@glimmer/component"
import { Code, Download, Link, Mail, Reply, Share } from "lucide"
import { Menu } from "ember-ui-sdk/menu"
import { icon } from "./icon"
import { useLog } from "./log"

export default class Icons extends Component {
  log = useLog(this)

  onAction = (value: string) => {
    this.log(`Chose ${value}`)
  }

  <template>
    <Menu @onAction={{this.onAction}} as |m|>
      <m.Trigger>
        {{icon Share}}
        Share
      </m.Trigger>
      <m.Content>
        <m.Item @value="copy-link">
          <m.ItemIcon>{{icon Link}}</m.ItemIcon>
          Copy link
        </m.Item>
        <m.Item @value="email">
          <m.ItemIcon>{{icon Mail}}</m.ItemIcon>
          Email
        </m.Item>
        <m.Item @value="reply">
          <m.ItemIcon @mirror={{true}}>{{icon Reply}}</m.ItemIcon>
          Reply
        </m.Item>
        <m.Separator />
        <m.Item @value="download">
          <m.ItemIcon>{{icon Download}}</m.ItemIcon>
          Download
        </m.Item>
        <m.Item @value="embed">
          <m.ItemIcon>{{icon Code}}</m.ItemIcon>
          Embed
        </m.Item>
      </m.Content>
    </Menu>
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

Open Share and type an item’s name. The icons aren’t part of the item’s accessible name or the text typeahead matches.

## Checkboxes

Checkbox items toggle independently and stay open by default. Pass `@checked` and update it in `@onCheckedChange`, or use `@defaultChecked` for an uncontrolled item. An item indicator renders the check; `@keepMounted={{true}}` preserves its space while unchecked. Style `data-checked` and `data-unchecked` for each state.

```glimmer-ts title="checkboxes.gts"
import Component from "@glimmer/component"
import { Check } from "lucide"
import { Menu } from "ember-ui-sdk/menu"
import { icon } from "./icon"
import { useLog } from "./log"

export default class Checkboxes extends Component {
  log = useLog(this)

  onCheckedChange = (checked: boolean, details: { value: string }) => {
    this.log(`${details.value} ${checked ? "on" : "off"}`)
  }

  <template>
    <Menu @onCheckedChange={{this.onCheckedChange}} as |m|>
      <m.Trigger>View</m.Trigger>
      <m.Content>
        <m.Group as |g|>
          <g.Label>Appearance</g.Label>
          <m.CheckboxItem @value="status-bar" @defaultChecked={{true}} as |item|>
            <item.Indicator @keepMounted={{true}}>{{icon
                Check
              }}</item.Indicator>
            Status bar
          </m.CheckboxItem>
          <m.CheckboxItem @value="minimap" as |item|>
            <item.Indicator @keepMounted={{true}}>{{icon
                Check
              }}</item.Indicator>
            Minimap
          </m.CheckboxItem>
        </m.Group>
        <m.Separator />
        <m.CheckboxItem @value="line-numbers" @defaultChecked={{true}} as |item|>
          <item.Indicator @keepMounted={{true}}>{{icon Check}}</item.Indicator>
          Line numbers
        </m.CheckboxItem>
        <m.CheckboxItem @value="word-wrap" as |item|>
          <item.Indicator @keepMounted={{true}}>{{icon Check}}</item.Indicator>
          Word wrap
        </m.CheckboxItem>
      </m.Content>
    </Menu>
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

Open View and toggle Status bar or Minimap. The menu stays open so you can change several settings, and the console logs each one.

## Radio Group

Radio items choose one value in their group and stay open by default. Pass `@value` and update it in `@onValueChange`, or use `@defaultValue` for an uncontrolled group. Give the group a `@name` when it should identify itself in the menu’s value-change callback.

```glimmer-ts title="radio-group.gts"
import Component from "@glimmer/component"
import { Menu } from "ember-ui-sdk/menu"
import { useLog } from "./log"

const positions = [
  { value: "top", label: "Top" },
  { value: "bottom", label: "Bottom" },
  { value: "right", label: "Right" },
]

const densities = [
  { value: "compact", label: "Compact" },
  { value: "comfortable", label: "Comfortable" },
]

export default class RadioGroup extends Component {
  log = useLog(this)
  positions = positions
  densities = densities

  onPosition = (value: string) => {
    this.log(`Panel at the ${value}`)
  }

  onDensity = (value: string) => {
    this.log(`${value} density`)
  }

  <template>
    <Menu as |m|>
      <m.Trigger>Panel</m.Trigger>
      <m.Content>
        <m.RadioGroup @name="position" @defaultValue="bottom" @onValueChange={{this.onPosition}} as |r|>
          <r.Label>Position</r.Label>
          {{#each this.positions key="value" as |option|}}
            <r.Item @value={{option.value}} as |item|>
              <item.Indicator />
              {{option.label}}
            </r.Item>
          {{/each}}
        </m.RadioGroup>
        <m.Separator />
        <m.RadioGroup @defaultValue="comfortable" @onValueChange={{this.onDensity}} as |r|>
          <r.Label>Density</r.Label>
          {{#each this.densities key="value" as |option|}}
            <r.Item @value={{option.value}} as |item|>
              <item.Indicator />
              {{option.label}}
            </r.Item>
          {{/each}}
        </m.RadioGroup>
      </m.Content>
    </Menu>
  </template>
}
```

Open Panel and choose a position. Only one item in each group is checked, the menu stays open, and the console logs the change.

## Context Menu

A `m.ContextTrigger` opens at a right-click or long press. Give the area a tab stop so Shift+F10 and the context-menu key can open it from the keyboard. Right-clicking elsewhere in the same area repositions an open menu.

Set `@disabled={{true}}` to leave that area’s native browser menu available. Context triggers can pass a payload too.

```glimmer-ts title="context-menu.gts"
import { Menu } from "ember-ui-sdk/menu"
import { useLog } from "./log"
import Component from "@glimmer/component"

export default class ContextMenu extends Component {
  log = useLog(this)

  onAction = (value: string) => {
    this.log(`Chose ${value}`)
  }

  <template>
    <Menu @onAction={{this.onAction}} as |m|>
      <m.ContextTrigger tabindex="0">Right-click or long-press here</m.ContextTrigger>
      <m.Content>
        <m.Item @value="back">Back</m.Item>
        <m.Item @value="forward" @disabled={{true}}>Forward</m.Item>
        <m.Item @value="reload">Reload</m.Item>
        <m.Separator />
        <m.Item @value="save">Save page as…</m.Item>
        <m.Item @value="print">Print…</m.Item>
      </m.Content>
    </Menu>
  </template>
}
```

Right-click or long-press the area, or focus it and press Shift+F10. Choose an action and the console logs it.

## Placement

`@side` and `@align` choose the starting position. The menu flips or shifts when it does not fit; `data-side` reports where it ended up. Logical alignment and submenu keys follow the surrounding text direction.

```gts
<m.Content @side="right" @align="start">…</m.Content>
```

## Offsets and Collision Padding

`@sideOffset` sets the gap, `@alignOffset` shifts along the anchor, and `@collisionPadding` leaves room around the viewport. Use `--anchor-width` to match the trigger's width and `--available-height` to scroll a long list.

```gts
<m.Content @sideOffset={{8}} @alignOffset={{-4}} @collisionPadding={{24}}>…</m.Content>
```

## Modal

The default `@modal="pointer"` consumes an outside press while closing the menu. `@modal={{true}}` also locks scrolling and makes the page inert. `@modal={{false}}` lets the outside press reach its target after closing.

```gts
<Menu @modal={{false}} as |m|>
  <m.Trigger>Actions</m.Trigger>
  <m.Content />
</Menu>
```

## Submenu Delay

`@delay` is the hover wait in milliseconds, 100 by default. It applies to the submenus directly inside that menu. Set it on a `m.Sub` to change the delay for the next level.

```gts
<Menu @delay={{300}} as |m|>
  <m.Trigger>File</m.Trigger>
  <m.Content>
    <m.Sub @delay={{0}} as |s|>
      <s.Trigger>Open recent</s.Trigger>
      <s.Content />
    </m.Sub>
  </m.Content>
</Menu>
```

## Keyboard Navigation

Arrow keys wrap by default; `@loop={{false}}` stops at the ends. Typing finds an item by name. If an item has extra descriptive text, set `@label` to the text typeahead should match. `@label` does not replace its accessible name; use `aria-label` for that.

```gts
<Menu @loop={{false}} as |m|>
  <m.Trigger>Status</m.Trigger>
  <m.Content>
    <m.Item @value="busy" @label="Do not disturb">
      Do not disturb
      <span>Notifications are muted</span>
    </m.Item>
  </m.Content>
</Menu>
```

## Focus After Closing

When the menu closes with focus inside it, focus returns to the trigger. If an action removes the trigger or moves people on to something else, set `@finalFocus` on the content to a selector, an element or a function returning one, or to `"none"` to leave focus where the action put it.

```gts
<m.Content @finalFocus="#file-list">…</m.Content>
```

## Disabled Items

Disabled items remain focusable so people can discover them, but cannot run or open a submenu. A disabled trigger is a native disabled button and cannot receive focus. Add `@focusableWhenDisabled={{true}}` to keep it in the tab order, so it can host a tooltip that says why; presses still do nothing.

```glimmer-ts title="disabled.gts"
import Component from "@glimmer/component"
import { Check, ChevronRight } from "lucide"
import { Menu } from "ember-ui-sdk/menu"
import { icon } from "./icon"
import { useLog } from "./log"

export default class Disabled extends Component {
  log = useLog(this)

  onAction = (value: string) => {
    this.log(`Chose ${value}`)
  }

  <template>
    <div data-slot="row">
      <Menu @onAction={{this.onAction}} as |m|>
        <m.Trigger>Document</m.Trigger>
        <m.Content>
          <m.Item
            @value="undo"
            @shortcut="mod+z"
            @disabled={{true}}
          >Undo</m.Item>
          <m.Item @value="redo" @shortcut="mod+shift+z">Redo</m.Item>
          <m.Separator />
          <m.CheckboxItem @value="autosave" @defaultChecked={{true}} @disabled={{true}} as |item|>
            <item.Indicator>{{icon Check}}</item.Indicator>
            Autosave
          </m.CheckboxItem>
          <m.Separator />
          <m.RadioGroup @defaultValue="pdf" as |r|>
            <r.Label>Export as</r.Label>
            <r.Item @value="pdf" as |item|>
              <item.Indicator>{{icon Check}}</item.Indicator>
              PDF
            </r.Item>
            <r.Item @value="docx" @disabled={{true}} as |item|>
              <item.Indicator>{{icon Check}}</item.Indicator>
              Word
            </r.Item>
            <r.Item @value="markdown" as |item|>
              <item.Indicator>{{icon Check}}</item.Indicator>
              Markdown
            </r.Item>
          </m.RadioGroup>
          <m.Separator />
          <m.Sub as |s|>
            <s.Trigger @disabled={{true}}>
              Move to
              {{icon ChevronRight}}
            </s.Trigger>
            <s.Content>
              <s.Item>Archive</s.Item>
            </s.Content>
          </m.Sub>
        </m.Content>
      </Menu>
      <Menu as |m|>
        <m.Trigger @disabled={{true}}>Locked</m.Trigger>
        <m.Content>
          <m.Item>Unlock</m.Item>
        </m.Content>
      </Menu>
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

Open Document and move through its items with the arrow keys. Disabled actions remain discoverable but cannot run; Locked cannot open a menu.

## Keeping the Menu Open

Plain items close when selected; checkbox and radio items stay open. `@closeOnSelect` changes either default. A selection handler can also prevent the default event to keep it open for one action.

```gts
<m.Item @value="zoom-in" @closeOnSelect={{false}}>Zoom in</m.Item>
<m.CheckboxItem @value="fit" @closeOnSelect={{true}}>Fit to window</m.CheckboxItem>
```

## Container

Menus render in place and use the top layer. `@container` moves the popup to another element; submenus remain inside their parent popup. Pass the actual element after it exists.

```gts
<m.Content @container={{this.panel}}>…</m.Content>
```

## Animation

The menu stays mounted through an exit animation. `data-starting-style`, `data-ending-style`, `data-side`, and `--transform-origin` describe the transition. `@keepMounted={{true}}` leaves the closed content hidden afterward; `@onOpenChangeComplete` reports when it finishes.

```glimmer-ts title="animation.gts"
import Component from "@glimmer/component"
import { ChevronRight } from "lucide"
import { Menu } from "ember-ui-sdk/menu"
import { icon } from "./icon"
import { useLog } from "./log"

export default class Animation extends Component {
  log = useLog(this)

  onOpenChange = (open: boolean) => {
    this.log(open ? "Opening" : "Closing")
  }

  onOpenChangeComplete = (open: boolean) => {
    this.log(open ? "Finished opening" : "Finished closing")
  }

  <template>
    <Menu @onOpenChange={{this.onOpenChange}} @onOpenChangeComplete={{this.onOpenChangeComplete}} as |m|>
      <m.Trigger>Animated</m.Trigger>
      <m.Content @keepMounted={{true}}>
        <m.Item>Back</m.Item>
        <m.Item>Forward</m.Item>
        <m.Item>Reload</m.Item>
        <m.Separator />
        <m.Sub as |s|>
          <s.Trigger>
            More tools
            {{icon ChevronRight}}
          </s.Trigger>
          <s.Content>
            <s.Item>Save page as…</s.Item>
            <s.Item>Developer tools</s.Item>
          </s.Content>
        </m.Sub>
      </m.Content>
    </Menu>
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

Open Animated, then its More tools submenu, and close them. The console logs Opening or Closing, then when the animation finishes.

## Presentation

`@presentation="auto"` uses a sheet on small touch screens and a popover elsewhere; `"sheet"` always requests a sheet. The sheet keeps menu roles and keys. Submenus replace the current level, and Escape or the arrow toward the parent goes back. Context menus and menus in a menubar remain popovers.

Use `data-presentation` or the content’s `presentation` state for the two layouts. Leave a sheet’s translation to the SDK. `--sheet-backdrop` sets its dimming color, and the sheet is modal unless `@modal` is false.

```glimmer-ts title="presentation.gts"
import Component from "@glimmer/component"
import { ChevronRight, Download, Link, Share, Trash } from "lucide"
import { Menu } from "ember-ui-sdk/menu"
import { icon } from "./icon"
import { useLog } from "./log"

export default class Presentation extends Component {
  log = useLog(this)

  onAction = (value: string) => {
    this.log(`Chose ${value}`)
  }

  <template>
    <Menu @presentation="sheet" @onAction={{this.onAction}} as |m|>
      <m.Trigger>Options</m.Trigger>
      <m.Content>
        <m.Item @value="share">
          {{icon Share}}
          Share
        </m.Item>
        <m.Item @value="copy-link">
          {{icon Link}}
          Copy link
        </m.Item>
        <m.Sub as |s|>
          <s.Trigger>
            {{icon Download}}
            Move to
            {{icon ChevronRight}}
          </s.Trigger>
          <s.Content>
            <s.Item @value="inbox">Inbox</s.Item>
            <s.Item @value="archive">Archive</s.Item>
          </s.Content>
        </m.Sub>
        <m.Separator />
        <m.Item @value="delete" @destructive={{true}}>
          {{icon Trash}}
          Delete
        </m.Item>
      </m.Content>
    </Menu>
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

Open Options as a sheet, enter Move to, then go back or choose a destination. You can drag downward to dismiss the sheet.

## Controlled

Pass `@open` and update it in `@onOpenChange`. A change carries a reason, and `details.cancel()` can refuse it. A controller can open the menu from another control.

```gts
<Menu @open={{this.open}} @onOpenChange={{this.onOpenChange}} as |m|>
  <m.Trigger>Actions</m.Trigger>
  <m.Content />
</Menu>
```

## Triggers Outside the Menu

Connect external triggers and one menu to a `createMenuController<File>()`. Each trigger passes its row as `@payload`, which the content reads from its state. Only the active trigger is expanded and receives focus back. Code can also open with a `payload` and `anchor`; the Promise resolves when the menu closes.

```glimmer-ts title="payload.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Ellipsis } from "lucide"
import { Menu, MenuTrigger, createMenuController } from "ember-ui-sdk/menu"
import { icon } from "./icon"
import { useLog } from "./log"

type File = { name: string; size: string }

const files: File[] = [
  { name: "Roadmap.pdf", size: "2.4 MB" },
  { name: "Budget.xlsx", size: "860 KB" },
  { name: "Team photo.jpg", size: "5.1 MB" },
]

export default class Payload extends Component {
  log = useLog(this)
  files = files
  menu = createMenuController<File>()

  openFirst = async (event: MouseEvent) => {
    const result = await this.menu.open({
      payload: files[0],
      anchor: event.currentTarget as HTMLElement,
    })
    this.log(`Closed with ${result.reason}`)
  }

  onAction = (action: string) => {
    this.log(`${action} ${this.menu.getPayload()?.name}`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.openFirst}}>Open Roadmap.pdf
          Actions</button>
      </div>
      <ul data-slot="list">
        {{#each this.files key="name" as |file|}}
          <li data-slot="row">
            {{file.name}}
            <span data-slot="hint">{{file.size}}</span>
            <MenuTrigger
              @controller={{this.menu}}
              @payload={{file}}
              aria-label="Actions for {{file.name}}"
              data-variant="ghost"
              data-size="sm"
            >
              {{icon Ellipsis}}
            </MenuTrigger>
          </li>
        {{/each}}
      </ul>
      <Menu @controller={{this.menu}} @onAction={{this.onAction}} as |m|>
        <m.Content @align="end" as |content|>
          <m.Group as |g|>
            <g.Label>{{content.state.payload.name}}</g.Label>
            <m.Item @value="open">Open</m.Item>
            <m.Item @value="rename">Rename</m.Item>
            <m.Item @value="duplicate">Duplicate</m.Item>
          </m.Group>
          <m.Separator />
          <m.Item @value="delete">Delete</m.Item>
        </m.Content>
      </Menu>
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

Open the actions for different files. One menu shows the active row; opening from code uses the same payload and reports the closing reason.

## Menus as Data

`@items` accepts `MenuData`: actions, groups, checkboxes, radio groups, and submenus. A string is shorthand for an item whose label and value match. Data menus register their shortcuts even while closed; set `@itemShortcuts={{false}}` to turn that off.

`@onCheckedChange` reports the checkbox’s value in `details.value`; `@onValueChange` reports the radio group’s name in `details.group`. Either change can be canceled. You can also render your own parts from the same data while `@items` keeps the shortcuts registered. Lists and Menus covers the data shape.

```gts
import { Menu } from "ember-ui-sdk/menu"
import type { MenuData } from "ember-ui-sdk/menu"

const fileMenu: MenuData = [
  { value: "open", label: "Open…", shortcut: "mod+o" },
  { type: "separator" },
  {
    type: "checkbox",
    value: "toolbar",
    label: "Toolbar",
    defaultChecked: true,
  },
  {
    type: "radio-group",
    name: "sort",
    label: "Sort by",
    defaultValue: "name",
    items: [
      { value: "name", label: "Name" },
      { value: "date", label: "Date modified" },
    ],
  },
  { type: "submenu", label: "Share", items: ["Copy link", "Email"] },
]

<template>
  <Menu @items={{fileMenu}} @onAction={{this.run}} as |m|>
    <m.Trigger>File</m.Trigger>
    <m.Content />
  </Menu>
</template>
```

## Links and Custom Rendering

Render an item as a native link by passing `@render={{true}}` and binding the yielded `part` to your element. Enter follows the link like a click, preserving its target and modifier-key behavior.

```gts
<m.Item @value="composition" @render={{true}} as |item|>
  <a {{item.part}} href="#composition">Composition</a>
</m.Item>
```

## Custom Rendering

See [Links and Custom Rendering](#links-and-custom-rendering) for a native link. Every part accepts `@render` the same way, and its state is listed under [State](#api-reference).

## Styling

Use `data-highlighted` for the active item, `data-disabled` for unavailable actions, and `data-checked` for selected settings. Popup sizing and motion hooks are shared across the popup components.

Each part has a `data-slot`, such as `menu-item`, and its state attributes are listed under [Data Attributes](#data-attributes).

### MenuContent
- `--anchor-width`: Width of the anchor, usually the trigger. Use it to match widths.
- `--anchor-height`: Height of the anchor.
- `--available-width`: Space beside the popup, up to the viewport edge. Not inherited either.
- `--available-height`: Space between the anchor and the viewport edge. Use it for max-height. Not inherited, so a child that needs it copies it on the popup, like `[--list-height:var(--available-height)]`, and reads `max-h-(--list-height)`. The first popup registers both names for the whole page with `CSS.registerProperty`, so they don't inherit anywhere. A page that needs them to inherit calls it first, with `inherits: true`. An `@property` rule can't, since a registration in script wins.
- `--transform-origin`: The point on the anchor the popup opens from. Use it to scale from the right place.
- `--arrow-offset`: Where the anchor's center falls along the popup's edge, kept `arrowPadding` from the corners. Position a ::before arrow with it.
- `--drawer-progress`: While it presents as a sheet: how far open the sheet is, from 0 closed to 1 at its largest snap point. Never past 1.
- `--drawer-dim`: While it presents as a sheet: how dim the page behind is, from 0 to 1. The backdrop's opacity follows it.
- `--drawer-expand`: While it presents as a sheet: 0 at the second-largest snap point and below, 1 at the largest. With one snap point, the whole travel.
- `--drawer-stack`: While it presents as a sheet: how many sheets opened from inside this one are open above it, rising smoothly as each one opens. Push it back with it.
- `--sheet-backdrop`: Set it yourself: the color the page dims to while it presents as a sheet. Black at 0.2 by default.

### Viewport
- `--keyboard-inset`: While it presents as a sheet: how many pixels of the page the on-screen keyboard covers, 0 without one.
- `--visual-viewport-width`: While it presents as a sheet: the width of the part of the page you can see.
- `--visual-viewport-height`: While it presents as a sheet: the height of the part of the page you can see, above the keyboard.
- `--visual-viewport-top`: While it presents as a sheet: how far the part of the page you can see is scrolled from the top of the layout, as when the keyboard pushes it up.

## Data Attributes

`MenuRadioGroup`, `MenuGroup`, `MenuGroupLabel`, `MenuSeparator` and `MenuShortcut` have no state attributes.

### MenuTrigger
`[data-slot="menu-trigger"]`

- `data-closed`: Present on a trigger while the menu isn't open from it.
- `data-open`: Present on the trigger that opened the menu, while it's open.

### MenuContextTrigger
`[data-slot="menu-context-trigger"]`

- `data-closed`: Present on an area while the menu isn't open from it.
- `data-disabled`: Present when the item can't be chosen.

### MenuContent
`[data-slot="menu-content"]`

- `data-closed`: Present while the menu is closed, including while it animates out.
- `data-presentation` (`popover`, `sheet`): How the menu presents this time it's open. Submenus present like their root.
- `data-nested`: Present on submenus.
- `data-open`: Present while the menu is open. A submenu trigger has it while its submenu is open.
- `data-starting-style`: Present for the first frame. Style the state you animate from.
- `data-ending-style`: Present while the menu animates out. Style the state you animate to.
- `data-has-icons`: Present while any item inside holds an icon part, so items without one can line up.

### MenuItem
`[data-slot="menu-item"]`

- `data-disabled`: Present when the item can't be chosen.
- `data-has-icon`: Present on an item while it holds an icon part.

### MenuCheckboxItem
`[data-slot="menu-checkbox-item"]`

- `data-checked`: Present on checked checkbox items, and on the radio item that's its group's value.
- `data-unchecked`: Present on items that aren't checked.

### MenuItemIndicator
`[data-slot="menu-item-indicator"]`

- `data-checked`: Present while its item is checked.
- `data-unchecked`: Present while its item isn't checked, with `keepMounted`.

### MenuRadioItem
`[data-slot="menu-radio-item"]`

- `data-checked`: Present on checked checkbox items, and on the radio item that's its group's value.
- `data-unchecked`: Present on items that aren't checked.

### MenuItemIcon
`[data-slot="menu-item-icon"]`

- `data-mirror`: Present on an icon that flips in right-to-left text, with `mirror`.

## API Reference

Pass the root's options as `@` arguments. `@open`, `@checked` and `@value` are controlled with their `@on…Change` callbacks.

### Menu

- `container?` (`DocumentFragment | Element | null`): Renders the popup into this element instead of in place, like a container inside a shadow root or an iframe. On web components, a CSS selector. Nested popups stay inside their parent.
- `open?` (`boolean`): Whether the menu is open. Pass it to control the menu.
- `defaultOpen?` (`boolean`): Whether the menu starts open, when uncontrolled.
- `onOpenChange?` (`((open: boolean, details: ChangeDetails<MenuOpenChangeReason>) => void)`): Runs when the menu wants to open or close. `details.reason` says why, and `details.cancel()` stops it.
- `onOpenChangeComplete?` (`((open: boolean) => void)`): Runs once the menu has finished opening or closing, after any animation.
- `onPayloadChange?` (`((payload: unknown, details: ChangeDetails<MenuPayloadChangeReason>) => void)`): Runs when the payload the content shows changes: a trigger or context area with another payload opens the menu, or takes the open menu over, which fires no `@onOpenChange`, and so does a controller's `open({ payload })` on the open menu. `details.cancel()` keeps the previous payload.
- `onAction?` (`((value: string, details: MenuActionDetails) => unknown)`): Runs for every plain item, including items in submenus, with the item's value. Return a Promise to mark the item pending until it settles: it gets `data-pending`, `aria-busy` and `aria-disabled`, the menu stays open, and choosing it again waits. It closes once the Promise resolves, and a rejection keeps it open with the reason in the item's `error` state until the next try.
- `pendingAnnouncement?` (`string`): What screen readers hear once an item has been pending for a second, so a slow action doesn't pass in silence. Set it in the page's language. An empty string says nothing.
- `onCheckedChange?` (`((checked: boolean, details: MenuCheckedChangeDetails) => void)`): Runs when any checkbox item in the menu or its submenus toggles, with the item's value in `details.value`. Made for data menus.
- `onValueChange?` (`((value: string, details: MenuValueChangeDetails) => void)`): Runs when any radio group in the menu or its submenus changes, with the group in `details.group`. Made for data menus.
- `items?` (`MenuData`): The menu as data. Renders the content for you, unless you place a content part of your own, and runs the items' shortcuts.
- `itemShortcuts?` (`boolean`): Whether a data menu runs its items' shortcuts while closed.
- `loop?` (`boolean`): Whether arrow keys wrap from the last item to the first.
- `delay?` (`number`): Milliseconds the pointer rests on a submenu trigger before its submenu opens.
- `presentation?` (`PresentationSetting<"popover">`): How the menu presents. `"sheet"` slides it up from the bottom of the screen, where it can be swiped away and submenus open in its place, and `"auto"` does that on small touch screens. Decided each time it opens; the server renders `"popover"` for `"auto"`. A context menu and a menu in a menubar are always popovers.
- `controller?` (`MenuController`): Opens, closes and inspects the menu from anywhere, and connects triggers outside it. Create one with `createMenuController()`.
- `modal?` (`"pointer" | boolean`): `"pointer"`: an outside press only closes the menu. `true`: also locks scroll, traps focus and makes the rest of the page inert. `false`: outside presses reach what they hit.
- `dismissible?` (`boolean`): Whether Escape, an outside press, focus or the window leaving, Android's back gesture and a sheet's swipe can close it. Triggers, Close parts and the controller always can. Pass `false` while it holds unsaved work, and ask in `@onDismissAttempt`.
- `onDismissAttempt?` (`function`): Runs when `dismissible` refused a dismissal made on purpose: Escape, an outside press, back or a swipe. Focus or the window leaving is refused without it. Ask "Discard changes?" here.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### MenuTrigger

A trigger outside the menu also takes `@controller`.

- `disabled?` (`boolean`): Stops the trigger from opening the menu. A native button can't be focused or pressed, unless `focusableWhenDisabled` is set.
- `focusableWhenDisabled?` (`boolean`): Keeps a disabled trigger in the tab order with `aria-disabled` instead of the native attribute, so it can host a tooltip that says why. Presses still do nothing.
- `payload?` (`unknown`): Data for the content to render when this trigger opens the menu, like the row it belongs to.
- `shortcut?` (`string`): A keyboard shortcut that opens the menu from anywhere, like `"mod+j"`. `mod` is Command on Apple platforms and Control elsewhere. Sets `aria-keyshortcuts`.
- `controller?` (`PopupController<any, MenuOpenChangeReason, MenuOpenOptions, string, MenuPayloadChangeReason>`): Connects a trigger outside the menu, like one per table row, to the menu with this controller.

### MenuContextTrigger

- `disabled?` (`boolean`): Stops a right-click, a long press or Shift+F10 from opening the menu here. The browser's own menu shows instead.
- `payload?` (`unknown`): Data for the content to render when this area opens the menu, like the row it belongs to.
- `controller?` (`PopupController<any, MenuOpenChangeReason, MenuOpenOptions, string, MenuPayloadChangeReason>`): Connects an area outside the menu to the menu with this controller.

### MenuContent

- `side?` (`Side`): Which side of the anchor the popup opens on. Flips to the other side when there isn't room. Which side of the trigger the menu opens on. Submenus open to the side, mirrored in right-to-left layouts.
- `align?` (`Align`): How the popup lines up with the anchor along that side. `start` and `end` follow the reading direction. How the menu lines up with the trigger along that side.
- `sideOffset?` (`number`): Gap between the anchor and the popup, in pixels. Gap between the trigger and the menu, in pixels.
- `alignOffset?` (`number`): Shift along the anchor, in pixels. Shift along the trigger, in pixels. Submenus default to lining up their first item with the trigger.
- `collisionPadding?` (`number`): Space to keep from the viewport edges, in pixels.
- `arrowPadding?` (`number`): Space to keep between the arrow and the popup's corners, in pixels.
- `anchor?` (`string | Anchor | null`): Positions the popup against this instead of its trigger: an element, a CSS selector, a point like `{ x, y }`, or anything with `getBoundingClientRect()`. It's read on every check, so it can move. A controller's `open({ anchor })` wins for that open.
- `container?` (`DocumentFragment | Element | null`): Renders the popup into this element instead of in place, like a container inside a shadow root or an iframe. On web components, a CSS selector. Nested popups stay inside their parent.
- `finalFocus?` (`PopupFocusTarget`): Where focus goes when the menu closes while focus is inside it. `"trigger"` returns it to the trigger and `"none"` leaves it. A CSS selector, an element or a function picks a specific element.
- `keepMounted?` (`boolean`): Whether the menu stays in the page, hidden, while closed. For animation libraries that drive the exit from state.

### MenuItem

- `value?` (`string`): Passed to `@onAction` when the item runs.
- `label?` (`string`): The text typeahead matches, when the content isn't plain text. It isn't the accessible name: use `aria-label` for that.
- `disabled?` (`boolean`): Keeps the item focusable but stops it from running, as the menu pattern asks. Sets `data-disabled` and `aria-disabled`.
- `destructive?` (`boolean`): Styles the item as dangerous, like Delete. Sets `data-destructive`.
- `shortcut?` (`string`): A keyboard shortcut like `"mod+n"`. Shows `⌘N` on Apple platforms and `Ctrl+N` elsewhere, and sets `aria-keyshortcuts`.
- `closeOnSelect?` (`boolean`): Whether running the item closes the menu.
- `onSelect?` (`((event: Event) => unknown)`): Runs when the item is selected, by pointer or keyboard, with the event that selected it, or a new `select` Event when no DOM event did. Call `event.preventDefault()` to keep the menu open and skip `@onAction`. Return a Promise to mark the item pending until it settles, like `@onAction`.

### MenuCheckboxItem

- `value` (`string`): Identifies the item, in the menu's `@onCheckedChange`.
- `label?` (`string`): The text typeahead matches, when the content isn't plain text. It isn't the accessible name: use `aria-label` for that.
- `disabled?` (`boolean`): Keeps the item focusable but stops it from toggling, as the menu pattern asks.
- `checked?` (`boolean`): Whether the item is checked. Pass it to control the item.
- `defaultChecked?` (`boolean`): Whether the item starts checked, when uncontrolled.
- `onCheckedChange?` (`((checked: boolean, details: ChangeDetails<MenuCheckedChangeReason>) => void)`): Runs when the item wants to toggle. `details.reason` says why, and `details.cancel()` stops it.
- `closeOnSelect?` (`boolean`): Whether toggling closes the menu.

### MenuRadioGroup

- `value?` (`T | null`): The selected value. Pass it to control the group. `null` selects nothing.
- `defaultValue?` (`T | null`): The value selected at first, when uncontrolled.
- `onValueChange?` (`((value: T, details: ChangeDetails<MenuValueChangeReason>) => void)`): Runs when the selection wants to change. `details.reason` says why, and `details.cancel()` stops it.
- `name?` (`string`): Identifies the group in the menu's `@onValueChange`. Defaults to a generated id.

### MenuRadioItem

- `value` (`string`): Selected in the group when the item is chosen.
- `label?` (`string`): The text typeahead matches, when the content isn't plain text. It isn't the accessible name: use `aria-label` for that.
- `disabled?` (`boolean`): Keeps the item focusable but stops it from being chosen, as the menu pattern asks.
- `closeOnSelect?` (`boolean`): Whether choosing the item closes the menu.

### MenuItemIndicator

- `keepMounted?` (`boolean`): Whether the indicator stays in the page while its item is unchecked, so it can be styled or animated in both states.

### MenuItemIcon

- `mirror?` (`boolean`): Flips the icon horizontally in right-to-left text, for icons that point a way, like arrows and chevrons. Icons that picture a thing, like a clock or a check, stay as they are.

### MenuSub

- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.
- `open?` (`boolean`): Whether the submenu is open. Pass it with `@open` and update it in `@onOpenChange` to control the submenu.
- `defaultOpen?` (`boolean`): Whether the submenu starts open, when uncontrolled.
- `onOpenChange?` (`((open: boolean, details: ChangeDetails<MenuOpenChangeReason>) => void)`): Runs when the menu wants to open or close. `details.reason` says why, and `details.cancel()` stops it.
- `onOpenChangeComplete?` (`((open: boolean) => void)`): Runs once the menu has finished opening or closing, after any animation.
- `loop?` (`boolean`): Whether arrow keys wrap from the last item to the first.
- `delay?` (`number`): Milliseconds the pointer rests on a submenu trigger before its submenu opens.
- `controller?` (`MenuController`): Opens, closes and inspects the submenu. Create one with `createMenuController()`. Triggers outside the menu can't connect to it.

### MenuSubTrigger

- `disabled?` (`boolean`): Keeps the submenu trigger focusable but stops it from opening its submenu, as the menu pattern asks. Sets `data-disabled` and `aria-disabled`.

### MenuSubContent

It takes the same arguments as `MenuContent`.

### MenuGroup, MenuGroupLabel and MenuSeparator

These take no arguments of their own, only the arguments of the element they render.

### State

What `@render` parts and their blocks receive, per part.

`MenuTrigger`, `MenuContextTrigger` and `MenuSubTrigger`:

- `open` (`boolean`): Whether the menu is open from this trigger.
- `disabled` (`boolean`): Whether the trigger's `disabled` prop is set, or the menubar it's in is disabled.

`MenuContent`:

- `open` (`boolean`): Whether the menu is open. False while it animates out.
- `nested` (`boolean`): Whether this is a submenu.
- `presentation` (`Presentation`): How the menu is shown.
- `payload` (`Payload | undefined`): The payload of the last open, from the trigger that opened it or a controller, typed as the controller's `Payload`.

`MenuItem`:

- `highlighted` (`boolean`): Whether the item has keyboard focus or is under the pointer.
- `disabled` (`boolean`): Whether the item can't be chosen.
- `pending` (`boolean`): Whether its `onSelect` or `onAction` Promise is running.
- `error` (`unknown`): Why its last action failed, until it runs again.

`MenuCheckboxItem` and `MenuRadioItem`:

- `highlighted` (`boolean`): Whether the item has keyboard focus or is under the pointer.
- `disabled` (`boolean`): Whether the item can't be chosen.
- `checked` (`boolean`): Whether the item is on: its `checked` prop when you pass one, otherwise `defaultChecked` until a press changes it.

`MenuRadioGroup`:

- `value` (`string | null`): The selected value, or null when nothing is selected.

`MenuItemIndicator`:

- `checked` (`boolean`): Whether its checkbox item is on, or its radio item is its group's value. While false, the indicator isn't shown unless `keepMounted` is set.
- `disabled` (`boolean`): Whether the item can't be chosen.

`MenuItemIcon`:

- `mirror` (`boolean`): Whether it flips in right-to-left text.

### Reasons

`details.reason` says why the menu or a submenu opened or closed.

- `trigger-press` (`MouseEvent | KeyboardEvent | TouchEvent`): Click, tap, Enter or Space on the part that opens, closes or toggles. Arrow keys that open a menu or submenu count too. A tap on a combobox's input that opens a sheet reports its `touchend`.
- `trigger-hover` (`PointerEvent`): The pointer rested on a trigger, or left it, with hover opening.
- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `outside-press` (`MouseEvent`): A press outside the layer.
- `escape-key` (`KeyboardEvent`): Escape, or a submenu's close key (ArrowLeft in left-to-right layouts).
- `close-press` (`MouseEvent | KeyboardEvent | SubmitEvent`): A Close part was pressed, or a form with `method="dialog"` was submitted.
- `focus-out` (`KeyboardEvent | FocusEvent`): Focus left the layer, or Tab moved it out.
- `window-blur` (`FocusEvent`): The window lost focus.
- `submenu-switch` (`KeyboardEvent | PointerEvent`): Another submenu in the same menu, or another menu in the same menubar, took over.
- `parent-close` (`none`): The parent layer closed.
- `trigger-release` (`PointerEvent`): A press-and-hold open was released outside the popup.
- `back` (`Event`): Going back: the Android back button or gesture, or Backspace in an empty command input, which returns to the previous page.
- `shortcut` (`KeyboardEvent`): A keyboard shortcut, like a trigger's `shortcut`.
- `swipe` (`TouchEvent | PointerEvent`): A swipe gesture: a finger, mouse or pen dragged it.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

For a payload change, it says what opened the menu or took it over.

- `trigger-press` (`MouseEvent | KeyboardEvent | TouchEvent`): Click, tap, Enter or Space on the part that opens, closes or toggles. Arrow keys that open a menu or submenu count too. A tap on a combobox's input that opens a sheet reports its `touchend`.
- `trigger-hover` (`PointerEvent`): The pointer rested on a trigger, or left it, with hover opening.
- `shortcut` (`KeyboardEvent`): A keyboard shortcut, like a trigger's `shortcut`.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

With `@dismissible={{false}}`, the refused dismissals `@onDismissAttempt` reports:

- `outside-press` (`MouseEvent`): A press outside the layer.
- `escape-key` (`KeyboardEvent`): Escape, or a submenu's close key (ArrowLeft in left-to-right layouts).
- `back` (`Event`): Going back: the Android back button or gesture, or Backspace in an empty command input, which returns to the previous page.
- `swipe` (`TouchEvent | PointerEvent`): A swipe gesture: a finger, mouse or pen dragged it.

Checkbox items report why they toggled, in `@onCheckedChange`:

- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

Radio groups report why their value changed, in `@onValueChange`:

- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

### Controller

Create one with `createMenuController<Payload>()` and pass it as `@controller`, to the menu and to any triggers outside it. `Payload` is the type of the data triggers and `open()` pass.

Every write method takes an optional `{ reason, event }`, passed to `@onOpenChange`. `open()` also takes `focus`: `"first"`, `"last"`, `"popup"` or `"none"`.

- `isOpen()` (`() => boolean`): Whether it's open. False as soon as it starts closing, while it still animates out.
- `setOpen(open, options?)` (`(open: boolean, options?: PopupChangeOptions<MenuOpenChangeReason> | undefined) => boolean`): Opens or closes it. Returns false when the change was canceled or it was already open or closed.
- `open(options?)` (`(options?: (PopupChangeOptions<MenuPayloadChangeReason> & { payload?: Payload | undefined; anchor?: Anchor | undefined; signal?: AbortSignal | undefined; } & MenuOpenOptions) | undefined) => Promise<...>`): Opens it, and resolves once it closes, with why, how and any return value. Resolves exactly once and never rejects: on the next close from any source, when `signal` aborts, or with reason `"unmount"` when the component leaves the page.
- `close(options?)` (`(options?: (PopupChangeOptions<MenuOpenChangeReason> & { returnValue?: Result | undefined; }) | undefined) => boolean`): Closes it. `returnValue` is passed to the promise `open()` returned. Returns false when the close was canceled or it was already closed.
- `toggle(options?)` (`(options?: PopupChangeOptions<MenuOpenChangeReason> | undefined) => boolean`): Opens it when it's closed, and closes it when it's open. Returns false when the change was canceled.
- `getPayload()` (`() => Payload | undefined`): The payload of the last open, from a controller or the trigger that opened it.
- `focus()` (`() => void`): Moves focus to the trigger that opened it last, or the first trigger.

### Events

Callbacks get the new state first, then the details. A controlled `@open`, `@checked` or `@value` only updates when its change callback wasn't canceled.

| Argument                | On                 | Receives                                                                       |
| ----------------------- | ------------------ | ------------------------------------------------------------------------------ |
| `@onOpenChange`         | `Menu`             | `(open, details)`: the new state, and the [reason](#reasons)                   |
| `@onOpenChangeComplete` | `Menu`             | `(open)`, after the animation                                                  |
| `@onPayloadChange`      | `Menu`             | `(payload, details)`: the content's new payload, and the [reason](#reasons)    |
| `@onAction`             | `Menu`             | `(value, { event })` for every plain item, including items in submenus         |
| `@onCheckedChange`      | `Menu`             | `(checked, details)`, with the item's value in `details.value`. For data menus |
| `@onValueChange`        | `Menu`             | `(value, details)`, with the group's name in `details.group`. For data menus   |
| `@onDismissAttempt`     | `Menu`             | `({ reason, event })`, when a dismissal was refused                            |
| `@onOpenChange`         | `MenuSub`          | `(open, details)`: the new state, and the [reason](#reasons)                   |
| `@onSelect`             | `MenuItem`         | `(event)`, before the menu closes. `event.preventDefault()` keeps it open      |
| `@onCheckedChange`      | `MenuCheckboxItem` | `(checked, details)`: the new state, and the [reason](#reasons)                |
| `@onValueChange`        | `MenuRadioGroup`   | `(value, details)`: the selected value, and the [reason](#reasons)             |

## Accessibility

The menu follows the [WAI-ARIA menu button pattern](https://www.w3.org/WAI/ARIA/apg/patterns/menu-button/).

### Tested Behavior

Every line below is an automated test.

**Trigger**

- Advertises its menu and reflects the open state.
- Click opens the menu and moves focus into it.
- Click on the open trigger closes the menu.
- Enter opens the menu and focuses the first item.
- Space opens the menu and focuses the first item.
- ArrowDown opens the menu and focuses the first item.
- ArrowUp opens the menu and focuses the last item.
- A click on a trigger in a shadow root opens the menu, and it stays open. Vue and web components only.

**Keyboard navigation**

- ArrowDown and ArrowUp move between items, skipping separators and labels.
- Disabled items are focusable.
- Focus wraps at both ends.
- Home and End move to the first and last items.
- Typing a character moves to the next item that starts with it.
- Typing several characters quickly matches the whole prefix.

**Activation**

- Enter on an item runs it, closes the menu and returns focus.
- Clicking an item runs it and closes the menu.
- Disabled items do nothing.
- Checkbox items toggle and keep the menu open.
- Radio items select one value and keep the menu open.
- Hovering an item highlights it.

**Dismissal**

- Escape closes the menu and returns focus to the trigger.
- Clicking outside closes the menu.
- Escape while an input method is composing text leaves the menu open.
- Pressing a scrollbar outside the menu leaves it open.
- Tab closes the menu.

**Submenu**

- The submenu trigger advertises its menu.
- ArrowRight opens the submenu and focuses its first item.
- Enter opens the submenu and focuses its first item.
- Space opens the submenu and focuses its first item.
- ArrowLeft closes the submenu and returns focus to its trigger.
- Nested submenus open and run their items.
- Submenu keyboard navigation stays inside the submenu.
- Keys pressed in quick succession are never lost.
- Clicking outside closes every menu.

Runs in React, Vue and web components.

Screen readers hear the same thing in each tested framework, recorded by a virtual screen reader:

- Announcements while using the menu with a keyboard.
- Item shortcuts are announced.

Runs in React, Vue and web components.
