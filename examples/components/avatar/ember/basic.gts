import { Avatar } from "ember-ui-sdk/avatar"

const person = {
  name: "shadcn",
  src: "https://github.com/shadcn.png",
}

<template>
  <div data-slot="row">
    <Avatar as |a|>
      <a.Image @src={{person.src}} alt={{person.name}} />
      <a.Fallback><span aria-hidden="true">CN</span><span
          data-slot="visually-hidden"
        >shadcn</span></a.Fallback>
    </Avatar>
  </div>
</template>
