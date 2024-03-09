@Preview
@Component
export default struct ListChatItem {
  data: ChatItemData = { headSrc: $r("app.media.ic_user_head1"),
    nickname: "同事小李",
    content: "领导，报给写好了，请过目",
    time: "14:12"
  }

  build() {
    Row() {
      Image(this.data.headSrc)
        .width(60)
        .height(60)
        .margin({ right: 15 })
        .objectFit(ImageFit.Cover)
        .borderRadius(6)
        .borderWidth(2)
        .borderColor("#f0f0f0")
      Column() {
        Text(this.data.nickname)
          .fontColor(Color.Black)
          .fontSize(19)
          .fontWeight(500)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width("100%")

        Text(this.data.content)
          .fontColor(Color.Gray)
          .fontSize(15)
          .width("100%")
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 7 })

      }.layoutWeight(1)
      .margin({ right: 30 })
      .alignItems(HorizontalAlign.Start)

      Text(this.data.time)
        .fontColor(Color.Gray)
        .fontSize(14)
        .alignSelf(ItemAlign.Start)
        .margin({ top: 15, right: 6 })
    }
    .width("100%")
    .height(80)
    .backgroundColor(Color.White)
    .padding({ left: 15, right: 15 })
  }
}

export interface ChatItemData {
  headSrc?: Resource
  nickname?: string
  content?: string
  time?: string
}