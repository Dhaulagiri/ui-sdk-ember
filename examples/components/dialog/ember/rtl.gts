import { Dialog } from "ember-ui-sdk/dialog"

<template>
  <div dir="rtl">
    <Dialog as |d|>
      <d.Trigger>تعديل الملف الشخصي</d.Trigger>
      <d.Backdrop />
      <d.Content>
        <div data-slot="stack">
          <d.Title>تعديل الملف الشخصي</d.Title>
          <d.Description>أجرِ التغييرات على ملفك الشخصي هنا.</d.Description>
        </div>
        <label data-slot="label">
          الاسم
          <input value="بيدرو دوارتي" />
        </label>
        <div data-slot="row">
          <d.Close>إلغاء</d.Close>
          <d.Close data-variant="solid" @value="save">حفظ</d.Close>
        </div>
      </d.Content>
    </Dialog>
  </div>
</template>
