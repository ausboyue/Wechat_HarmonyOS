
@Component
export  struct SoundRecordComponent{
  build() {
    // Column() {
    //   //   1 中心的提示   显示波浪线
    //   Row() {
    //     if (this.pressCancelVoicePostText !== PressCancelVoicePostText.postText) {
    //       // 声纹
    //       this.vocalPrint()
    //
    //     } else {
    //       Scroll() {
    //         // 显示录音的文字
    //         Text(this.voiceToText)
    //           .fontSize(12)
    //           .fontColor("#666")
    //       }
    //       .width("100%")
    //       .height("100%")
    //     }
    //
    //     Text()
    //       .width(10)
    //       .height(10)
    //       .backgroundColor(this.pressCancelVoicePostText === PressCancelVoicePostText.cancelVoice ? Color.Red :
    //         "#95EC6A")
    //       .position({
    //         bottom: -5,
    //         left: "50%"
    //       })
    //       .translate({
    //         x: "-50%"
    //       })
    //       .rotate({
    //         angle: 45
    //       })
    //   }
    //   .width("50%")
    //   .height(80)
    //   .backgroundColor(this.pressCancelVoicePostText === PressCancelVoicePostText.cancelVoice ? Color.Red : "#95EC6A")
    //   .position({
    //     top: "40%",
    //     left: "50%"
    //   })
    //   .translate({
    //     x: "-50%"
    //   })
    //   .borderRadius(10)
    //   .justifyContent(FlexAlign.Center)
    //   .alignItems(VerticalAlign.Center)
    //
    //   //   2 取消和转文字
    //   Row() {
    //     Row() {
    //       Text("X")
    //         .fontSize(20)
    //         .width(60)
    //         .height(60)
    //         .borderRadius(30)
    //         .fontColor(this.pressCancelVoicePostText === PressCancelVoicePostText.cancelVoice ? "#000" : "#ccc")
    //         .backgroundColor(this.pressCancelVoicePostText === PressCancelVoicePostText.cancelVoice ? "#fff" : "#333")
    //         .textAlign(TextAlign.Center)
    //         .align(Alignment.Center)
    //         .fontColor("#ccc")
    //         .id("aabb")
    //         .rotate({ angle: -20 })
    //         .onAppear(() => {
    //           let modePosition: componentUtils.ComponentInfo = componentUtils.getRectangleById("aabb");
    //           this.xScreenOffset.x = px2vp(modePosition.screenOffset.x)
    //           this.xScreenOffset.y = px2vp(modePosition.screenOffset.y)
    //           this.xScreenOffset.width = px2vp(modePosition.size.width)
    //           this.xScreenOffset.height = px2vp(modePosition.size.height)
    //         })
    //     }
    //
    //     Row() {
    //       Text("文")
    //         .fontSize(20)
    //         .width(60)
    //         .height(60)
    //         .borderRadius(30)
    //         .fontColor(this.pressCancelVoicePostText === PressCancelVoicePostText.postText ? "#000" : "#ccc")
    //         .backgroundColor(this.pressCancelVoicePostText === PressCancelVoicePostText.postText ? "#fff" : "#333")
    //         .textAlign(TextAlign.Center)
    //         .align(Alignment.Center)
    //         .id("ddee")
    //         .rotate({ angle: 20 })
    //         .onAppear(() => {
    //           let modePosition: componentUtils.ComponentInfo = componentUtils.getRectangleById("ddee");
    //           // px单位
    //           this.TextScreenOffset.x = px2vp(modePosition.screenOffset.x)
    //           this.TextScreenOffset.y = px2vp(modePosition.screenOffset.y)
    //           this.TextScreenOffset.width = px2vp(modePosition.size.width)
    //           this.TextScreenOffset.height = px2vp(modePosition.size.height)
    //         })
    //
    //     }
    //
    //     // 3  松开发送
    //     Text(this.pressCancelVoicePostText === PressCancelVoicePostText.cancelVoice ? '取消发送' :
    //       (this.pressCancelVoicePostText === PressCancelVoicePostText.postText ? '转换文字' : "松开发送"))
    //       .fontColor("#fff")
    //       .width("100%")
    //       .position({
    //         bottom: 0,
    //         left: 0
    //       })
    //       .textAlign(TextAlign.Center)
    //   }
    //   .width("100%")
    //   .position({
    //     bottom: "23%"
    //   })
    //   .justifyContent(FlexAlign.SpaceBetween)
    //   .padding({
    //     left: 60, right: 60
    //   })
    //
    //   //   4 底部白色大球
    //   Row() {
    //
    //   }
    //   .width(600)
    //   .height(600)
    //   .backgroundColor("#fff")
    //   .position({
    //     bottom: 0,
    //     left: "50%"
    //   })
    //   .translate({
    //     x: "-50%",
    //     y: "70%"
    //   })
    //   .borderRadius("50%")
    //
    // }
    // .width("100%")
    // .height("100%")
    // .backgroundColor("rgba(0,0,0,0.5)")
  }
}