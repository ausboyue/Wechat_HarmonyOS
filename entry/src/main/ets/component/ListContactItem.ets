@Preview
@Component
export default struct ListContactItem {
  private head: string | PixelMap | Resource = ""
  private name: string = ""

  build() {
    Row() {
      Image(this.head)
        .width(46)
        .height(46)
        .borderRadius(4)
        .margin({ left: 20, right: 15 })
        .objectFit(ImageFit.Cover)

      Text(this.name)
        .fontSize(19)
        .fontWeight(500)
        .width("100%")
        .layoutWeight(1)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ right: 30 })
        .fontColor(Color.Black)
    }
    .backgroundColor(Color.White)
    .width("100%")
    .height(60)
  }
}