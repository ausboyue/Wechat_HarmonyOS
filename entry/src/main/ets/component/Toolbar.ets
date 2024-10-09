import router from '@ohos.router'
import WindowManager from '../utils/WindowManager'
import { ToastUtils } from '../utils/ToastUtils'

@Preview
@Component
export default struct Toolbar {
  private title: string = "发现"
  private backSrc: string | PixelMap | Resource = $r("app.media.ic_back_black")
  private subTitle: string = "更多"
  private subIconSrc: string | PixelMap | Resource = $r("app.media.ic_toolbar_more")

  build() {
    Column() {
      Row() {
        Image(this.backSrc)
          .width(22)
          .height(22)
          .margin({ left: 15 })
          .onClick(() => {
            router.back()
          })

        Text(this.title)
          .fontColor(Color.Black)
          .fontSize(19)
          .fontWeight(500)

        if (this.subIconSrc === null) {
          Text(this.subTitle)
            .fontColor(Color.Black)
            .fontSize(16)
            .margin({ right: 15 })
            .fontWeight(400)
            .onClick(unDevTip)
        } else {
          Image(this.subIconSrc)
            .width(25)
            .height(25)
            .margin({ right: 15 })
            .onClick(unDevTip)
        }

      }
      .height(53)
      .width("100%")
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .expandSafeArea([SafeAreaType.KEYBOARD])
    .backgroundColor("#f1f1f1")
    .zIndex(999)
    .padding({ top: WindowManager.statusBarHeight })
  }
}

const unDevTip = () => {
  ToastUtils.show("功能正在开发中...")
}