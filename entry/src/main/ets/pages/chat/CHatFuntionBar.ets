@Entry
@Component
@Preview
export default struct ChatFunctionBar {
  build() {
    Grid() {
      GridItem() {
        this.createMenu($r("app.media.ic_voice"), "相册")
      }

      GridItem() {
        this.createMenu($r("app.media.ic_voice"), "拍摄")
      }

      GridItem() {
        this.createMenu($r("app.media.ic_voice"), "语音通话")
      }

      GridItem() {
        this.createMenu($r("app.media.ic_voice"), "位置")
      }

      GridItem() {
        this.createMenu($r("app.media.ic_voice"), "红包")
      }

      GridItem() {
        Text('位置').fontSize(16)
        this.createMenu($r("app.media.ic_voice"), "语音输入")
      }

      GridItem() {
        this.createMenu($r("app.media.ic_voice"), "我的收藏")
      }

      GridItem() {
        this.createMenu($r("app.media.ic_voice"), "群工具")
      }

    }
    .maxCount(4)
    .layoutDirection(GridDirection.Row)
    .rowsTemplate('1fr 1fr')
    .columnsTemplate('1fr 1fr 1fr 1fr')
    .height(230)
  }

  @Builder createMenu(iconSrc: Resource, menuName: string) {
    Column() {
      Image(iconSrc)
        .width(26)
        .height(26)
        .objectFit(ImageFit.Fill)
        .margin({ bottom: 3 })
      // 文本
      Text(menuName)
        .fontSize(16)
    }
    .backgroundColor(Color.White)
    .justifyContent(FlexAlign.Center)
    .width(80)
    .height(80)
  }
}