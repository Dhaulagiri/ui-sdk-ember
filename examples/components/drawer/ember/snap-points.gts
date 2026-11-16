import { Drawer } from "ember-ui-sdk/drawer"

const places = [
  { name: "Blue Bottle Coffee", detail: "Coffee · 0.2 mi" },
  { name: "Tartine Bakery", detail: "Bakery · 0.4 mi" },
  { name: "Dolores Park", detail: "Park · 0.5 mi" },
  { name: "Mission Dolores", detail: "Landmark · 0.6 mi" },
  { name: "Ritual Coffee Roasters", detail: "Coffee · 0.7 mi" },
  { name: "Bi-Rite Creamery", detail: "Ice cream · 0.7 mi" },
  { name: "Alamo Square", detail: "Park · 1.1 mi" },
  { name: "The Castro Theatre", detail: "Cinema · 1.2 mi" },
  { name: "Ferry Building", detail: "Market · 2.3 mi" },
  { name: "Coit Tower", detail: "Landmark · 2.9 mi" },
  { name: "Golden Gate Park", detail: "Park · 3.0 mi" },
  { name: "Lands End", detail: "Trail · 5.4 mi" },
]

const snapPoints = [0.25, 0.5, 1]

<template>
  <Drawer
    @snapPoints={{snapPoints}}
    @defaultSnapPoint={{0.5}}
    @expandOnScroll={{true}}
    as |d|
  >
    <d.Trigger>Find a Place</d.Trigger>
    <d.Backdrop />
    <d.Content>
      <d.Handle aria-label="Resize" />
      <div data-slot="stack">
        <d.Title>Places nearby</d.Title>
        <d.Description>Drag the drawer, or press the handle, to see more.</d.Description>
      </div>
      <div data-slot="scroll">
        <ul data-slot="list">
          {{#each places key="name" as |place|}}
            <li>
              <div>{{place.name}}</div>
              <div data-slot="hint">{{place.detail}}</div>
            </li>
          {{/each}}
        </ul>
      </div>
    </d.Content>
  </Drawer>
</template>
