import { Resizable } from "ember-ui-sdk/resizable"

<template>
  <div dir="rtl">
    <Resizable as |r|>
      <r.Panel @defaultSize={{35}} @minSize={{20}}>
        <h3>الملفات</h3>
        <ul>
          <li>page.tsx</li>
          <li>layout.tsx</li>
          <li>globals.css</li>
        </ul>
      </r.Panel>
      <r.Handle aria-label="تغيير حجم الملفات" />
      <r.Panel @defaultSize={{65}} @minSize={{40}}>
        <Resizable @orientation="vertical" as |r2|>
          <r2.Panel @defaultSize={{60}} @minSize={{30}}>
            <h3>page.tsx</h3>
            <span data-slot="hint">حُفظ للتو</span>
          </r2.Panel>
          <r2.Handle aria-label="تغيير حجم المحرر" />
          <r2.Panel @defaultSize={{40}} @minSize={{30}}>
            <h3>الطرفية</h3>
            <span data-slot="hint">جاهز على المنفذ 3000</span>
          </r2.Panel>
        </Resizable>
      </r.Panel>
    </Resizable>
  </div>
</template>
