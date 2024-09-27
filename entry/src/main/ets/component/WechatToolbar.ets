import router from '@ohos.router'
import prompt from '@ohos.promptAction'
import WindowManager from '../utils/WindowManager'

@Preview
@Component
export default struct WechatToolbar {
  private title: string = "发现"

  build() {
    Column() {
      Stack() {
        Text(this.title)
          .fontColor(Color.Black)
          .fontSize(19)
          .fontWeight(500)

        Row() {
          Image($r("app.media.ic_search"))
            .width(22)
            .height(22)
            .margin({ right: 20 })
            .onClick(() => {
              router.pushUrl({ url: 'pages/search/SearchPage' })
            })
          Image($r('app.media.ic_add'))
            .width(25)
            .height(25)
            .margin({ right: 18 })
            .onClick(() => {
              prompt.showToast({ message: "功能正在开发中...", duration: 2000 })
              router.pushUrl({ url: 'pages/HardwareIndexPage' })
            })
        }
        .height("100%")
        .width("100%")
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.End)

      }
      .width("100%")
      .height(53)
    }.backgroundColor("#f0f0f0")
    .padding({ top: WindowManager.statusBarHeight })
  }
}