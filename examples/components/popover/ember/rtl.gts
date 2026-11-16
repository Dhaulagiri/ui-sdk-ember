import { Popover } from "ember-ui-sdk/popover"

<template>
  <div dir="rtl">
    <Popover as |p|>
      <p.Trigger>الأبعاد</p.Trigger>
      <p.Content @align="start" @sideOffset={{8}}>
        <p.Arrow />
        <p.Title>الأبعاد</p.Title>
        <p.Description>اضبط أبعاد الطبقة.</p.Description>
      </p.Content>
    </Popover>
  </div>
</template>
