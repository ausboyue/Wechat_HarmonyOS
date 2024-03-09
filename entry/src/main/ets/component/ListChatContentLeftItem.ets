@Preview
@Component
export default struct ListChatContentLeftItem {
  data: ChatContentItemData = {
    self: false,
    headSrc: $r("app.media.ic_user_head2"),
    content: "ArkTS是鸿蒙生态的应用开发语言。它在保持TypeScript（简称TS）基本语法风格的基础上，进一步通过规范强化静态检查和分析，使得在程序运行之前的开发期能检测更多错误，提升代码健壮性，并实现更好的运行性能。",
  }

  build() {
    Row() {
      Image(this.data.headSrc)
        .width(48)
        .height(48)
        .borderRadius(4)
        .margin({ left: 20, right: 8 })
        .objectFit(ImageFit.Cover)

      Path()
        .commands(`M${vp2px(10)} 0 L0 ${vp2px(7)} ${vp2px(10)} ${vp2px(14)} Z`)
        .fill('rgb(255,255,255)')
        .margin({
          top:19
        })
        .strokeWidth(0)

      Row() {
        Text(this.data.content)
          .fontColor(Color.Black)
          .fontSize(18)
          .padding(13.5)
          .fontWeight(500)
          .borderRadius(4)
          .backgroundColor(Color.White)
      }
      .margin({ right: 80 })
      .layoutWeight(1)

    }.alignItems(VerticalAlign.Top)
  }
}

export interface ChatContentItemData {
  self?: boolean
  headSrc?: Resource
  content?: string
}