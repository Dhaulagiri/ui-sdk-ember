import { Button } from "ember-ui-sdk/button"
import { ChevronRight } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <div data-slot="row" dir="rtl">
    <Button>
      متابعة
      {{icon ChevronRight}}
    </Button>
    <Button>إلغاء</Button>
  </div>
</template>
