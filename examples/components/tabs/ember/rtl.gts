import { Tabs } from "ember-ui-sdk/tabs"

<template>
  <div dir="rtl">
    <Tabs @defaultValue="account" as |t|>
      <t.List aria-label="الإعدادات">
        <t.Tab @value="account">الحساب</t.Tab>
        <t.Tab @value="password">كلمة المرور</t.Tab>
        <t.Tab @value="notifications">الإشعارات</t.Tab>
        <t.Indicator />
      </t.List>
      <t.Panel @value="account">عدّل اسمك وبريدك الإلكتروني وصورتك.</t.Panel>
      <t.Panel @value="password">
        غيّر كلمة المرور وفعّل التحقق بخطوتين.
      </t.Panel>
      <t.Panel @value="notifications">اختر ما نرسله إليك بالبريد.</t.Panel>
    </Tabs>
  </div>
</template>
