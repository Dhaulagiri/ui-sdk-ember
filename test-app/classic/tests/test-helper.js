import Application from "test-app/app"
import config from "test-app/config/environment"
import { setApplication } from "@ember/test-helpers"
import { start, setupEmberOnerrorValidation } from "ember-qunit"
import { loadTests } from "ember-qunit/test-loader"
import * as QUnit from "qunit"
import { setup } from "qunit-dom"

setApplication(Application.create(config.APP))
setup(QUnit.assert)
loadTests()
setupEmberOnerrorValidation()
start()
