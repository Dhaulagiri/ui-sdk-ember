import { AlertDialog } from "ember-ui-sdk/alert-dialog"

<template>
  <div dir="rtl">
    <AlertDialog as |d|>
      <d.Trigger>حذف الحساب</d.Trigger>
      <d.Backdrop />
      <d.Content>
        <div data-slot="stack">
          <d.Title>هل أنت متأكد تمامًا؟</d.Title>
          <d.Description>
            لا يمكن التراجع عن هذا الإجراء. سيؤدي إلى حذف حسابك نهائيًا.
          </d.Description>
        </div>
        <div data-slot="row">
          <d.Close>إلغاء</d.Close>
          <d.Close data-variant="solid" @value="confirm">متابعة</d.Close>
        </div>
      </d.Content>
    </AlertDialog>
  </div>
</template>
