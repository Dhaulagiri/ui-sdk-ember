import { Progress } from "ember-ui-sdk/progress"

<template>
  <div dir="rtl">
    <Progress @value={{56}} @locale="ar-EG" as |p|>
      <p.Label>تقدم الرفع</p.Label>
      <p.Value />
      <p.Track>
        <p.Indicator />
      </p.Track>
    </Progress>
  </div>
</template>
