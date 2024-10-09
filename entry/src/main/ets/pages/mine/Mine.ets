import router from '@ohos.router'
import ListMenuItem from '../../component/ListMenuItem'
import { PhotoPickerUtils } from '../../utils/PhotoPickerUtils'
import WindowManager from '../../utils/WindowManager'
import { ToastUtils } from '../../utils/ToastUtils'

@Preview
@Component
export default struct Mine {
  @State imgPath: string = ""

  build() {
    Column() {

      Row() {
        Image(this.imgPath ? this.imgPath : $r('app.media.ic_user_head1'))
          .width(70)
          .height(70)
          .margin({ left: 25, right: 10 })
          .borderRadius(8)
          .onClick(() => {
            PhotoPickerUtils.openGallery(
              uri => {
                this.imgPath = uri;
              }, errMsg => {
              ToastUtils.show(errMsg)
            })
          })

        Column() {
          Text("亚瑟王")
            .fontColor(Color.Black)
            .fontSize(26)
            .fontWeight(700)

          Text("微信号：wx_023021")
            .fontColor(Color.Grey)
            .fontSize(16)
            .margin({ top: 15 })

          Text('+ 状态')
            .fontColor(Color.Grey)
            .margin({ top: 20 })
            .padding({ left: 8, right: 8 })
            .height(25)
            .fontSize(15)
            .borderRadius(20)
            .height(26)
            .textAlign(TextAlign.Center)
            .borderWidth(0.7)
            .borderColor('#666')
            .backgroundColor(Color.White)
        }
        .margin({ top: 40 })
        .alignItems(HorizontalAlign.Start)

        Blank()
        Image($r('app.media.ic_qrcode'))
          .width(16)
          .height(16)
          .margin({ top: 38, right: 20 })


        Image($r("app.media.ic_more"))
          .width(9)
          .height(16.364)
          .margin({ top: 38, right: 15 })

      }.width("100%")
      .height(203)
      .backgroundColor(Color.White)
      .padding({ top: WindowManager.statusBarHeight })
      .onClick(() => {
        router.pushUrl({ url: 'pages/qrcode/MyQrCodePage' })
      })

      Divider()
        .vertical(false)
        .color("#f3f3f3")
        .strokeWidth(10)
        .lineCap(LineCapStyle.Round)
      ListMenuItem({
        title: "服务",
        iconSrc: $r('app.media.ic_service')
      })
        .onClick(unDevTip)
      Divider()
        .vertical(false)
        .color("#f3f3f3")
        .strokeWidth(10)
        .lineCap(LineCapStyle.Round)
      ListMenuItem({
        title: "收藏",
        iconSrc: $r("app.media.ic_collect")
      })
        .onClick(unDevTip)

      Divider()
        .vertical(false)
        .color("#f3f3f3")
        .strokeWidth(1)
        .lineCap(LineCapStyle.Round)
      ListMenuItem({
        title: "朋友圈",
        iconSrc: $r('app.media.ic_moment_pic')
      })
        .onClick(unDevTip)
      Divider()
        .vertical(false)
        .color("#f3f3f3")
        .strokeWidth(1)
        .lineCap(LineCapStyle.Round)
      ListMenuItem({
        title: "卡包",
        iconSrc: $r('app.media.ic_card_pkg')
      }).onClick(unDevTip)
      Divider()
        .vertical(false)
        .color("#f3f3f3")
        .strokeWidth(1)
        .lineCap(LineCapStyle.Round)
      ListMenuItem({
        title: "表情",
        iconSrc: $r('app.media.ic_face_icon')
      }).onClick(unDevTip)
      Divider()
        .vertical(false)
        .color("#f3f3f3")
        .strokeWidth(10)
        .lineCap(LineCapStyle.Round)
      ListMenuItem({
        title: "设置",
        iconSrc: $r('app.media.ic_setting')
      })
        .onClick(unDevTip)
    }
    .width("100%")
    .height("100%")
    .backgroundColor("#f0f0f0")

  }
}

const unDevTip = () => {
  ToastUtils.show("二级页面正在开发中...")
}
