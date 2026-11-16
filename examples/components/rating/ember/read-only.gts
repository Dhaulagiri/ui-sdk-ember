import { Rating } from "ember-ui-sdk/rating"
import { Star } from "lucide"
import { icon } from "../../../shared/ember/icon"

const label = (value: number, max: number) => `Rated ${value} out of ${max}`

<template>
  <Rating @value={{4.2}} @readOnly={{true}} @getValueLabel={{label}} as |r|>
    <r.Item as |i|>{{icon Star}}</r.Item>
  </Rating>
</template>
