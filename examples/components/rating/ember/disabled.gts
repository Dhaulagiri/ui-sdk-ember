import { Rating } from "ember-ui-sdk/rating"
import { Star } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <Rating aria-label="Rating" @defaultValue={{2}} @disabled={{true}} as |r|>
    <r.Item as |i|>{{icon Star}}</r.Item>
  </Rating>
</template>
