@Preview
@Component
export default struct ListChatContentRightItem {
  data: ChatContentItemData = {
    self: false,
    headSrc: $r("app.media.ic_user_head1"),
    content: "哈哈，太牛逼了，很有创意，受教了。。。",
  }

  build() {
    Row() {
      Column() {
        Text(this.data.content)
          .fontColor(Color.Black)
          .fontWeight(500)
          .fontSize(18)
          .padding(13.5)
          .borderRadius(4)
          .backgroundColor("#a9ea7a")
      }
      .margin({ left: 80 })
      .alignItems(HorizontalAlign.End)
      .layoutWeight(1)

      Path()
        .commands(`M0 0 L${vp2px(10)} ${vp2px(7)} 0 ${vp2px(14)} Z`)
        .fill('rgb(169,234,122)')
        .margin({
          top:18
        })
        .strokeWidth(0)

      Image(this.data.headSrc)
        .width(48)
        .height(48)
        .borderRadius(4)
        .margin({ left: 8, right: 20 })
        .objectFit(ImageFit.Cover)

    }.alignItems(VerticalAlign.Top)
  }
}

export interface ChatContentItemData {
  self?: boolean
  headSrc?: Resource
  content?: string
}