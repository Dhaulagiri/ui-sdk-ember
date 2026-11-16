import { Menubar } from "ember-ui-sdk/menubar"

<template>
  <div dir="rtl">
    <Menubar as |mb|>
      <mb.Menu as |m|>
        <m.Trigger>ملف</m.Trigger>
        <m.Content>
          <m.Item>علامة تبويب جديدة</m.Item>
          <m.Sub as |s|>
            <s.Trigger>
              مشاركة
            </s.Trigger>
            <s.Content>
              <s.Item>البريد الإلكتروني</s.Item>
              <s.Item>الرسائل</s.Item>
            </s.Content>
          </m.Sub>
        </m.Content>
      </mb.Menu>
      <mb.Menu as |m|>
        <m.Trigger>تحرير</m.Trigger>
        <m.Content>
          <m.Item>تراجع</m.Item>
          <m.Item>إعادة</m.Item>
        </m.Content>
      </mb.Menu>
    </Menubar>
  </div>
</template>
