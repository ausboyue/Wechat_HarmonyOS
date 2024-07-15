import { ChatContentItemData } from '../pages/chat/ChatContentItemData'

@Preview
@Component
export default struct ListChatContentLeftItem {
  private data?: ChatContentItemData

  build() {
    Row() {
      Image(this.data?.headSrc)
        .width(48)
        .height(48)
        .borderRadius(4)
        .margin({ left: 20, right: 8 })
        .objectFit(ImageFit.Cover)

      Path()
        .commands(`M${vp2px(10)} 0 L0 ${vp2px(7)} ${vp2px(10)} ${vp2px(14)} Z`)
        .fill('rgb(255,255,255)')
        .margin({
          top: 19
        })
        .strokeWidth(0)

      Row() {
        if (this.data?.msgType == 0) {
          Text(this.data?.msg)
            .fontColor(Color.Black)
            .fontSize(18)
            .padding(13.5)
            .fontWeight(500)
            .borderRadius(4)
            .backgroundColor(Color.White)
        } else {
          Image(this.data?.img)
            .width(150)
            .borderRadius(4)
            .objectFit(ImageFit.Auto)
            .backgroundColor(Color.White)
        }
      }
      .margin({ right: 80 })
      .layoutWeight(1)

    }.alignItems(VerticalAlign.Top)
  }
}

