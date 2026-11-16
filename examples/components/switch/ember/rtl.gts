import { Switch } from "ember-ui-sdk/switch"

<template>
  <div dir="rtl">
    <label data-slot="label">
      وضع الطيران
      <Switch as |s|>
        <s.Thumb />
      </Switch>
    </label>
  </div>
</template>
