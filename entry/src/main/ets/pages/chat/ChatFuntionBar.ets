@Entry
@Component
@Preview
export default struct ChatFunctionBar {
  build() {
    Grid() {
      GridItem() {
        this.createMenu($r("app.media.ic_camera"), "相册")
      }

      GridItem() {
        this.createMenu($r("app.media.ic_shoot"), "拍摄")
      }

      GridItem() {
        this.createMenu($r("app.media.ic_voice_call"), "语音通话")
      }

      GridItem() {
        this.createMenu($r("app.media.ic_location"), "位置")
      }

      GridItem() {
        this.createMenu($r("app.media.ic_red_pkg"), "红包")
      }
      GridItem() {
        this.createMenu($r("app.media.ic_translation"), "转账")
      }

      GridItem() {
        Text('位置').fontSize(16)
        this.createMenu($r("app.media.ic_voice_input"), "语音输入")
      }

      GridItem() {
        this.createMenu($r("app.media.ic_my_collection"), "我的收藏")
      }

      GridItem() {
        this.createMenu($r("app.media.ic_voice"), "群工具")
      }

    }
    .maxCount(4)
    .layoutDirection(GridDirection.Row)
    .rowsTemplate('1fr 1fr')
    .columnsTemplate('1fr 1fr 1fr 1fr')
    .height(250)
    .backgroundColor("#f9f9f9")
    .padding({ top: 20, bottom: 20 })
  }

  @Builder createMenu(iconSrc: Resource, menuName: string) {
    Column() {
      Image(iconSrc)
        .width(60)
        .height(60)
        .objectFit(ImageFit.Fill)
        .margin({ bottom: 5 })
        .padding(13)
        .borderRadius(15)
        .backgroundColor(Color.White)
      // 文本
      Text(menuName)
        .fontColor(Color.Gray)
        .fontSize(14)
    }
    .borderRadius(20)
    .justifyContent(FlexAlign.Center)
    .width(70)
    .height(70)
  }
}