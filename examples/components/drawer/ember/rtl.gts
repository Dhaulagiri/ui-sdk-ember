import { Drawer } from "ember-ui-sdk/drawer"

const links = ["الرئيسية", "الطلبات", "المنتجات", "العملاء", "الإعدادات"]

<template>
  <div dir="rtl">
    <Drawer @side="start" as |d|>
      <d.Trigger>القائمة</d.Trigger>
      <d.Backdrop />
      <d.Content>
        <div data-slot="stack">
          <d.Title>القائمة</d.Title>
          <d.Description>اسحبها نحو حافتها لإغلاقها.</d.Description>
        </div>
        <nav aria-label="الأقسام">
          <ul>
            {{#each links key="@identity" as |link|}}
              <li>
                <a href="https://example.com">
                  {{link}}
                </a>
              </li>
            {{/each}}
          </ul>
        </nav>
        <d.Close data-variant="solid">إغلاق</d.Close>
      </d.Content>
    </Drawer>
  </div>
</template>
