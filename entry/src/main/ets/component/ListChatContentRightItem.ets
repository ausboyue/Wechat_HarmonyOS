import { ChatContentItemData } from '../pages/chat/ChatContentItemData'
import AudioRendererManager from '../utils/AudioRendererManager'

@Preview
@Component
export default struct ListChatContentRightItem {
  data?: ChatContentItemData

  build() {
    Row() {
      Column() {
        if (this.data?.msgType == 0) {
          Text(this.data?.msg)
            .fontColor(Color.Black)
            .fontWeight(500)
            .fontSize(18)
            .padding({
              left: 14,
              right: 14,
              top: 10,
              bottom: 10
            })
            .borderRadius(4)
            .backgroundColor("#a9ea7a")
        } else if (this.data?.msgType === 2) {
          Row() {
            Text(this.data?.msg)
              .fontColor(Color.Black)
              .fontSize(18)
              .fontWeight(500)

            Image(this.data?.img)
              .width(28)
              .width(28)
              .margin({ left: 1 })
              .objectFit(ImageFit.Auto)
          }
          .padding({
            left: 14,
            right: 14,
            top: 10,
            bottom: 10
          })
          .borderRadius(4)
          .backgroundColor("#a9ea7a")
          .onClick(this.playVoice)

        } else {
          Image(this.data?.img)
            .width(150)
            .borderRadius(4)
            .objectFit(ImageFit.Auto)
            .backgroundColor("#a9ea7a")
        }
      }
      .margin({ left: 80 })
      .alignItems(HorizontalAlign.End)
      .layoutWeight(1)

      Path()
        .commands(`M0 0 L${vp2px(10)} ${vp2px(7)} 0 ${vp2px(14)} Z`)
        .fill('rgb(169,234,122)')
        .margin({
          top: 18
        })
        .strokeWidth(0)

      Image(this.data?.headSrc)
        .width(48)
        .height(48)
        .borderRadius(4)
        .margin({ left: 8, right: 20 })
        .objectFit(ImageFit.Cover)

    }.alignItems(VerticalAlign.Top)
  }

  playVoice = async () => {
    if (this.data?.voicePath) {
      AudioRendererManager.doPlay(this.data?.voicePath)
    }
  }

  aboutToDisappear(): void {
    AudioRendererManager.release()
  }
}


