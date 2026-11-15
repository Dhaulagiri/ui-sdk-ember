# Menubar

Move between an application’s menus with one tab stop.

Wrap a few [Menus](./menu.md) in a Menubar to connect their triggers. Tab enters the bar once; arrow keys move between menus, and pointing at another trigger switches an open menu.

```glimmer-ts title="demo.gts"
import Component from "@glimmer/component"
import { Check, ChevronRight } from "lucide"
import { Menu } from "ember-ui-sdk/menu"
import { Menubar } from "ember-ui-sdk/menubar"
import { icon } from "./icon"
import { useLog } from "./log"

const recent = ["Q3 roadmap", "Launch checklist", "Offsite notes"]
const formats = ["PDF", "Markdown", "HTML"]
const appearances = ["Light", "Dark", "System"]

export default class Demo extends Component {
  log = useLog(this)
  recent = recent
  formats = formats
  appearances = appearances

  chose = (value: string) => {
    this.log(`Chose ${value}`)
  }

  onCheckedChange = (checked: boolean, details: { value: string }) => {
    this.log(`${details.value} ${checked ? "on" : "off"}`)
  }

  onAppearance = (value: string) => {
    this.log(`${value} appearance`)
  }

  <template>
    <Menubar as |mb|>
      <mb.Menu @onAction={{this.chose}} as |m|>
        <m.Trigger>File</m.Trigger>
        <m.Content>
          <m.Item @value="New document" @shortcut="mod+n">New Document</m.Item>
          <m.Item @value="Open" @shortcut="mod+o">Open…</m.Item>
          <m.Sub as |s|>
            <s.Trigger>
              Open Recent
              {{icon ChevronRight}}
            </s.Trigger>
            <s.Content>
              {{#each this.recent key="@identity" as |name|}}
                <s.Item @value={{name}}>{{name}}</s.Item>
              {{/each}}
            </s.Content>
          </m.Sub>
          <m.Separator />
          <m.Sub as |s|>
            <s.Trigger>
              Export
              {{icon ChevronRight}}
            </s.Trigger>
            <s.Content>
              {{#each this.formats key="@identity" as |format|}}
                <s.Item @value="Export as {{format}}">{{format}}</s.Item>
              {{/each}}
            </s.Content>
          </m.Sub>
          <m.Item @value="Print" @shortcut="mod+p">Print…</m.Item>
        </m.Content>
      </mb.Menu>
      <mb.Menu @onAction={{this.chose}} as |m|>
        <m.Trigger>Edit</m.Trigger>
        <m.Content>
          <m.Item
            @value="Undo"
            @shortcut="mod+z"
            @disabled={{true}}
          >Undo</m.Item>
          <m.Item @value="Redo" @shortcut="mod+shift+z">Redo</m.Item>
          <m.Separator />
          <m.Item @value="Cut" @shortcut="mod+x">Cut</m.Item>
          <m.Item @value="Copy" @shortcut="mod+c">Copy</m.Item>
          <m.Item @value="Paste" @shortcut="mod+v">Paste</m.Item>
          <m.Separator />
          <m.Item @value="Find" @shortcut="mod+f">Find…</m.Item>
        </m.Content>
      </mb.Menu>
      <mb.Menu
        @onCheckedChange={{this.onCheckedChange}}
        @onValueChange={{this.onAppearance}}
        as |m|
      >
        <m.Trigger>View</m.Trigger>
        <m.Content>
          <m.CheckboxItem @value="Ruler" as |item|>
            <item.Indicator>{{icon Check}}</item.Indicator>
            Show Ruler
          </m.CheckboxItem>
          <m.CheckboxItem
            @value="Word count"
            @defaultChecked={{true}}
            as |item|
          >
            <item.Indicator>{{icon Check}}</item.Indicator>
            Show Word Count
          </m.CheckboxItem>
          <m.Separator />
          <m.RadioGroup @defaultValue="System" as |r|>
            <r.Label>Appearance</r.Label>
            {{#each this.appearances key="@identity" as |appearance|}}
              <r.Item @value={{appearance}} as |item|>
                <item.Indicator />
                {{appearance}}
              </r.Item>
            {{/each}}
          </m.RadioGroup>
        </m.Content>
      </mb.Menu>
    </Menubar>
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

Tab into the bar and use Left and Right to choose a menu, or point at another trigger once one is open. File has submenus, Edit has shortcuts, and View has checkboxes and an appearance choice. The console logs each one.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Composition

Use the following composition to build a `Menubar`:

```text
Menubar as |mb|
├── mb.Menu as |m|
│   ├── m.Trigger
│   └── m.Content
│       ├── m.Item
│       └── m.Item
└── mb.Menu as |m|
    ├── m.Trigger
    └── m.Content
        ├── m.Item
        └── m.Item
```

Each Menu joins its surrounding Menubar automatically. There are no separate menubar trigger or item components. Name the bar with `aria-label` when people need to distinguish it from another one.

## Usage

Import the root and use the parts it yields:

```gts
import { Menubar } from "ember-ui-sdk/menubar"

<template>
  <Menubar aria-label="Application" as |mb|>
    <mb.Menu as |m|>
      <m.Trigger>File</m.Trigger>
      <m.Content>
        <m.Item @value="new">New file</m.Item>
        <m.Item @value="open">Open file</m.Item>
      </m.Content>
    </mb.Menu>
    <mb.Menu as |m|>
      <m.Trigger>Edit</m.Trigger>
      <m.Content>
        <m.Item @value="undo">Undo</m.Item>
        <m.Item @value="redo">Redo</m.Item>
      </m.Content>
    </mb.Menu>
  </Menubar>
</template>
```

## Submenu

A submenu still uses the Menu’s `m.Sub`, its trigger, and its content. The arrow toward it enters that level. On an ordinary item, the same arrow can move to the next top-level menu instead.

```glimmer-ts title="submenu.gts"
import { ChevronRight } from "lucide"
import { Menubar } from "ember-ui-sdk/menubar"
import { icon } from "./icon"

<template>
  <Menubar as |mb|>
    <mb.Menu as |m|>
      <m.Trigger>File</m.Trigger>
      <m.Content>
        <m.Item>New File</m.Item>
        <m.Sub as |s|>
          <s.Trigger>
            Share
            {{icon ChevronRight}}
          </s.Trigger>
          <s.Content>
            <s.Item>Email link</s.Item>
            <s.Item>Messages</s.Item>
          </s.Content>
        </m.Sub>
      </m.Content>
    </mb.Menu>
    <mb.Menu as |m|>
      <m.Trigger>Edit</m.Trigger>
      <m.Content>
        <m.Item>Undo</m.Item>
        <m.Sub as |s|>
          <s.Trigger>
            Find
            {{icon ChevronRight}}
          </s.Trigger>
          <s.Content>
            <s.Item>Find…</s.Item>
            <s.Item>Find Next</s.Item>
          </s.Content>
        </m.Sub>
      </m.Content>
    </mb.Menu>
  </Menubar>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Open File and enter Share with the arrow key. Go back to File, then move to Edit without leaving the menubar.

## Vertical

Pass `@orientation="vertical"` to move between triggers with Up and Down. The arrow toward the popup opens it; the arrow back closes it and returns to the trigger.

```glimmer-ts title="vertical.gts"
import { Menubar } from "ember-ui-sdk/menubar"

const labels = ["Inbox", "Drafts", "Archive"]

<template>
  <Menubar @orientation="vertical" as |mb|>
    {{#each labels key="@identity" as |label|}}
      <mb.Menu as |m|>
        <m.Trigger>{{label}}</m.Trigger>
        <m.Content>
          <m.Item>Open {{label}}</m.Item>
          <m.Item>Mark all as read</m.Item>
        </m.Content>
      </mb.Menu>
    {{/each}}
  </Menubar>
</template>
```

Use Up and Down to choose Inbox, Drafts, or Archive. Right opens its menu in left-to-right text; Left returns to its trigger.

## Menus as Data

Each Menu can take `@items` and register its shortcuts while closed. The [Menu data example](./menu.md#menus-as-data) explains the item shapes and callbacks.

```gts
import { Menu } from "ember-ui-sdk/menu"
import { Menubar } from "ember-ui-sdk/menubar"
import type { MenuData } from "ember-ui-sdk/menu"

const file: MenuData = [
  { value: "new", label: "New File", shortcut: "mod+alt+n" },
  { value: "open", label: "Open…" },
  { type: "separator" },
  {
    type: "submenu",
    label: "Share",
    items: [{ value: "email", label: "Email link" }],
  },
]

<template>
  <Menubar as |mb|>
    <mb.Menu @items={{file}} @onAction={{this.run}} as |m|>
      <m.Trigger>File</m.Trigger>
      <m.Content />
    </mb.Menu>
  </Menubar>
</template>
```

## Disabled

A disabled trigger stays focusable with `aria-disabled`, so people can discover it, but cannot open its menu. Set `@disabled={{true}}` on the bar to disable all its triggers while preserving the tab stop.

```gts
<Menubar as |mb|>
  <mb.Menu as |m|>
    <m.Trigger @disabled={{true}}>Share</m.Trigger>
    <m.Content />
  </mb.Menu>
</Menubar>

<Menubar @disabled={{true}} />
```

## Modal

The bar supplies `@modal` to menus that do not set their own value. The default, `"pointer"`, consumes an outside press while closing. With `@modal={{true}}`, the page also becomes inert and stops scrolling, but the menubar stays usable so you can switch menus.

```gts
<Menubar @modal={{true}} as |mb|>…</Menubar>
```

## Loop

Arrow keys wrap between triggers and open menus by default. Set `@loop={{false}}` to stop at the ends.

```gts
<Menubar @loop={{false}} as |mb|>…</Menubar>
```

## Controller

Create one with `createMenubarController()` and pass it as `@controller`. `focus()` moves focus to the bar; `close()` closes its active menu. Each menu still owns its own open state and controller. Connect a shortcut like Alt+M to `focus()`, like an application command that moves focus into its menus.

```gts
import { on } from "@ember/modifier"
import { Menubar, createMenubarController } from "ember-ui-sdk/menubar"

const menubar = createMenubarController()

<template>
  <Menubar @controller={{menubar}} as |mb|>…</Menubar>
  <button type="button" {{on "click" menubar.focus}}>Focus Menubar</button>
</template>
```

## Shared Menu Features

[Checkboxes](./menu.md#checkboxes), [radio groups](./menu.md#radio-group), [icons](./menu.md#icons), [shortcuts](./menu.md#shortcuts), and [links](./menu.md#links-and-custom-rendering) work as they do in Menu. The first example combines settings and actions in one bar. Menus inside a menubar always use the popover presentation.

## Styling

The bar gets `data-open` while any menu is open; a trigger gets it only for its own menu. Use `data-orientation` for row or column layout. Style the popups and their items through the same [Menu attributes and CSS variables](./menu.md#styling).

Each part has a `data-slot`, such as `menubar`, and its state attributes are listed under [Data Attributes](#data-attributes).

## Data Attributes

### Menubar
`[data-slot="menubar"]`

- `data-orientation` (`horizontal`, `vertical`): Which arrow keys move between menus.
- `data-disabled`: Present when the whole menubar is disabled.
- `data-open`: Present while one of its menus is open.

## API Reference

Pass the root's options as `@` arguments.

### Menubar

- `orientation?` (`MenubarOrientation`): Which arrow keys move between menus: left and right, or up and down. A vertical menubar opens its menus to the side.
- `loop?` (`boolean`): Whether arrow keys wrap from the last menu to the first, between triggers and between open menus.
- `disabled?` (`boolean`): Stops every menu from opening. Triggers stay focusable with `aria-disabled`, so the menubar keeps its tab stop and stays discoverable.
- `modal?` (`"pointer" | boolean`): The `modal` setting of every menu in the menubar that doesn't set its own. `"pointer"`: an outside press only closes the open menu. `true`: also locks scroll, traps focus and makes the rest of the page inert, except the menubar. `false`: outside presses reach what they hit.
- `controller?` (`{ focus: () => void; isOpen: () => boolean; close: (options?: ChangeOptions<MenuOpenChangeReason>) => boolean; }`): Opens, closes and focuses the menubar from anywhere. Create one with `createMenubarController()`.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

Menus, items and their icons take the arguments on the Menu page, like [`MenuItemIcon`](./menu.md#menuitemicon).

### State

- `orientation` (`MenubarOrientation`): Which arrow keys move between menus, from the `orientation` option. A vertical menubar opens its menus to the side.
- `disabled` (`boolean`): Whether the whole menubar is disabled.
- `open` (`boolean`): Whether one of its menus is open.
- `modal` (`boolean | "pointer"`): The modal setting its menus inherit.

### Reasons

A menu that another menu in the menubar takes over closes with `submenu-switch`, one opened by pointing at its trigger opens with `trigger-hover`, and one opened with an arrow key opens with `trigger-press`. See [Menu](./menu.md#reasons) for every reason.

### Controller

- `focus()` (`() => void`): Moves focus to the trigger that holds the menubar's tab stop: the one used last, or the first.
- `isOpen()` (`() => boolean`): Whether one of its menus is open.
- `close(options?)` (`(options?: ChangeOptions<MenuOpenChangeReason> | undefined) => boolean`): Closes the open menu, if any, and its submenus. Returns false when the close was canceled or it was already closed.

## Accessibility

The menubar follows the [WAI-ARIA menubar pattern](https://www.w3.org/WAI/ARIA/apg/patterns/menubar/).

### Keyboard

Tab first lands on the first trigger, then remembers the last one used. While a menu is open, moving the pointer onto another enabled trigger opens its menu, unless the pointer is only passing over it on the way into the open menu. Pressing that trigger keeps it open. Moving to a disabled trigger closes the current menu without opening another.

| Key             | On a Trigger              | In an Open Menu                                  |
| --------------- | ------------------------- | ------------------------------------------------ |
| Left / Right    | Previous or next trigger. | Previous or next menu, or enter/leave a submenu. |
| Down            | Open at the first item.   | Next item.                                       |
| Up              | Open at the last item.    | Previous item.                                   |
| Enter / Space   | Open at the first item.   | Choose the focused item.                         |
| Home / End      | First or last trigger.    | First or last item.                              |
| A letter        | Find a trigger by name.   | Find an item by name.                            |
| Escape          | —                         | Close and return to the trigger.                 |
| Tab / Shift+Tab | Leave the bar.            | Close and leave the bar.                         |

These directions describe a horizontal bar in left-to-right text. Right-to-left text reverses the horizontal keys and submenu side; vertical bars use Up and Down between triggers.

### Tested Behavior

Every line below is an automated test.

- The menubar is named, and its triggers are menu items that open menus.
- The menubar is one tab stop, on its first trigger.
- Left and Right move between triggers, and Home goes to the first.
- Tab comes back to the trigger used last.
- ArrowDown opens a menu and focuses its first item.
- Enter opens a menu and focuses its first item.
- Space opens a menu and focuses its first item.
- Escape closes the menu and focuses its trigger.
- Tab in an open menu closes it and moves past the menubar.
- A press opens a menu, and a press on its trigger closes it.
- While a menu is open, pointing at another trigger opens its menu instead.
- Crossing another trigger on the way to the open menu keeps the menu.
- Resting on another trigger on the way to the open menu switches to it.
- While a menu is open, pointing at a disabled trigger closes it and opens nothing.
- After pointing at a disabled trigger, pointing at another trigger opens its menu.
- Pointing at a trigger while every menu is closed opens nothing.
- A press outside closes the open menu.
- Choosing an item runs it, closes the menu and focuses its trigger.
- Checkbox and radio items work in a menubar's menus.
- A disabled item in a menubar's menu is focusable and does nothing.
- With loop off, arrows stop at the ends.

**Vertical**

- Up and Down move between triggers, and Right opens a menu to the side.

Runs in React, Vue and web components.
