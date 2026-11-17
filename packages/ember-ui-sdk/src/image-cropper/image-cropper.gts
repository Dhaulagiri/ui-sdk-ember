import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import {
  imageCropper,
  type ImageCrop,
  type ImageCropperController,
  type ImageCropperCropChangeDetails,
  type ImageCropperCropCommitDetails,
  type ImageCropperMode,
  type ImageCropperShape,
} from "@ui-sdk/core/image-cropper"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import ImageCropperFlip from "./image-cropper-flip.gts"
import ImageCropperGrid from "./image-cropper-grid.gts"
import ImageCropperHandle from "./image-cropper-handle.gts"
import ImageCropperImage from "./image-cropper-image.gts"
import ImageCropperRotate from "./image-cropper-rotate.gts"
import ImageCropperSelection from "./image-cropper-selection.gts"
import ImageCropperViewport from "./image-cropper-viewport.gts"
import ImageCropperZoom from "./image-cropper-zoom.gts"

/** The root: a group around the image and its controls, busy until the image loads. Pass `@crop` with `@onCropChange` to control it. Yields its parts. */
class ImageCropper extends Component<{
  Element: HTMLDivElement
  Args: {
    /** The image's URL, like an object URL for a file someone picked. */
    src?: string
    /** The crop, in the image's own pixels, with its `rotation`, `flipX` and `flipY`. Pass it with `@onCropChange` to control the cropper. */
    crop?: ImageCrop
    /** The crop at first, when uncontrolled. Without one, a crop at `aspectRatio` in the middle: four fifths of the largest in a box, the largest in a frame. */
    defaultCrop?: ImageCrop
    /** `"box"` moves and resizes a selection over the image; `"frame"` pans and zooms the image under a still one. */
    mode?: ImageCropperMode
    /** Keeps the crop's width over its height, like `1` for a square. */
    aspectRatio?: number
    /** The selection's shape, as `data-shape`. Pass the same shape to `cropImage`. */
    shape?: ImageCropperShape
    /** The narrowest the crop gets, in image pixels. */
    minWidth?: number
    /** The shortest the crop gets, in image pixels. */
    minHeight?: number
    /** How far the crop magnifies the image, where 1 is the largest crop. */
    maxZoom?: number
    /** Stops every change. */
    disabled?: boolean
    /** Sets the crop from anywhere. Create one with `createImageCropperController()`. */
    controller?: ImageCropperController
    /** Logs every crop change with its reason. */
    debug?: boolean
    /** Runs while the crop changes: on every step of a drag, a key or the wheel. `details.cancel()` keeps the crop. */
    onCropChange?: (
      crop: Required<ImageCrop>,
      details: ImageCropperCropChangeDetails
    ) => void
    /** Runs once an interaction that changed the crop ends. For saving. */
    onCropCommit?: (
      crop: Required<ImageCrop>,
      details: ImageCropperCropCommitDetails
    ) => void
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, imageCropper)
  root = usePart(this, () => this.handle, "root")

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Viewport=(component ImageCropperViewport handle=this.handle)
        Image=(component ImageCropperImage handle=this.handle)
        Selection=(component ImageCropperSelection handle=this.handle)
        Grid=(component ImageCropperGrid handle=this.handle)
        Handle=(component ImageCropperHandle handle=this.handle)
        Zoom=(component ImageCropperZoom handle=this.handle)
        Rotate=(component ImageCropperRotate handle=this.handle)
        Flip=(component ImageCropperFlip handle=this.handle)
      )
      as |c|
    }}
      {{#if @render}}
        {{yield c}}
      {{else}}
        <div ...attributes {{this.root.modifier}}>{{yield c}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default ImageCropper
