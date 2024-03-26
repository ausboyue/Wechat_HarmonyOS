import { BarcodeFormat } from '@ohos/zxing';
import QRCode from '../../util/QRCode';

@Entry
@Component
struct QrCodePage {
  @State qrcodeContent: string = ''
  @State pixelMap: PixelMap = undefined
  qrcode = new QRCode()

  async encode() {
    this.pixelMap = await this.qrcode.encode("我是二维码内容", {
      width: 300,
      height: 300,
      format: BarcodeFormat.QR_CODE
    })
  }

  async decode() {
    try {
      this.qrcodeContent = await this.qrcode.decode(this.pixelMap, {
        width: 300,
        height: 300,
        format: BarcodeFormat.QR_CODE
      })
    } catch (err) {
    }
  }

  build() {
    Row() {
      Column() {
        Text("二维码测试")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Image(this.pixelMap).width(300).height(300).margin(30)
        Button('生成一维码').fontSize(25).width(300).margin(20).onClick(() => {
          this.encode();
        })
        Button('解析一维码').fontSize(25).width(300).margin(20).onClick(() => {
          this.decode();
        })
        Text("解析内容：")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Text(this.qrcodeContent)
          .fontSize(20)
      }
      .width('100%')
    }
    .height('100%')
  }
}