import { Drawer } from "ember-ui-sdk/drawer"

const sides = [
  {
    side: "top",
    label: "Top",
    title: "Notifications",
    description: "You're all caught up.",
    preventEdgeSwipe: false,
  },
  {
    side: "right",
    label: "Right",
    title: "Cart",
    description: "2 items, $84.00.",
    preventEdgeSwipe: true,
  },
  {
    side: "bottom",
    label: "Bottom",
    title: "Share",
    description: "Send this page to your team.",
    preventEdgeSwipe: false,
  },
  {
    side: "left",
    label: "Left",
    title: "Menu",
    description: "Jump to a section of the docs.",
    preventEdgeSwipe: true,
  },
]

<template>
  <div data-slot="row">
    {{#each sides key="side" as |entry|}}
      <Drawer
        @side={{entry.side}}
        @preventEdgeSwipe={{entry.preventEdgeSwipe}}
        as |d|
      >
        <d.Trigger>{{entry.label}}</d.Trigger>
        <d.Backdrop />
        <d.Content>
          <div data-slot="stack">
            <d.Title>{{entry.title}}</d.Title>
            <d.Description>{{entry.description}}</d.Description>
          </div>
          <d.Close data-variant="solid">Close</d.Close>
        </d.Content>
      </Drawer>
    {{/each}}
  </div>
</template>
