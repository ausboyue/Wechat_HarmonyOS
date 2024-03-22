import router from '@ohos.router'
import prompt from '@ohos.promptAction'
import { STATUS_BAR_HEIGHT } from '../utils/StatusBarManager'

@Preview
@Component
export default struct WechatToolbar {
  private title: string = "发现"
  @StorageLink(STATUS_BAR_HEIGHT) statusBarHeight: number = 0

  build() {
    Column() {
      // 在界面顶部放置一个与状态栏同高度的组件，用于占位，可避免界面内容与状态栏内容重叠
      Row().height(px2vp(this.statusBarHeight))

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
  }
}