import {
  BarcodeFormat,
  MultiFormatWriter,
  BitMatrix,
  EncodeHintType,
  MultiFormatReader,
  DecodeHintType,
  RGBLuminanceSource,
  BinaryBitmap,
  HybridBinarizer
} from '@ohos/zxing';
import image from '@ohos.multimedia.image';

export default class QRCode {
  constructor() {

  }

  async encode(content: string, params: {
    width: number,
    height: number,

    format?: BarcodeFormat
  }): Promise<image.PixelMap> {
    const {width,height,format=BarcodeFormat.QR_CODE} = params
    const encodeHintTypeMap = new Map();
    // 设置二维码空白的宽度
    encodeHintTypeMap.set(EncodeHintType.MARGIN, 0);
    const writer: MultiFormatWriter = new MultiFormatWriter();
    let matrix: BitMatrix = writer.encode(content, format, width, height, encodeHintTypeMap);
    const PixelData = this.getMatrixPixelData(matrix, matrix.getWidth(), matrix.getHeight())
    return await image.createPixelMap(PixelData.buffer, {
      size: {
        width, height
      }
    })
  }

  async decode(image: image.PixelMap, params: {
    width: number,
    height: number,
    format?: BarcodeFormat
  }): Promise<string> {
    const {width,height,format=BarcodeFormat.QR_CODE} = params
    let num=image.getPixelBytesNumber()
    let arrayBuffer:ArrayBuffer=new ArrayBuffer(num);
    await image.readPixelsToBuffer(arrayBuffer)
    const int32Array=new Int32Array(arrayBuffer)
    const luminanceSource=new RGBLuminanceSource(int32Array,width,height)
    const binaryBitmap=new BinaryBitmap(new HybridBinarizer(luminanceSource))
    const reader=new MultiFormatReader()
    const hints=new Map();

    hints.set(DecodeHintType.POSSIBLE_FORMATS,[format]);
    reader.setHints(hints);
    let result=reader.decode(binaryBitmap);
    let text=result.getText();
    return text;
  }

  getMatrixPixelData(matrix, width, height) {
    const BLACK = 0xFF000000;
    const WHITE = 0xFFFFFFFF;
    const pixels = new Uint32Array(width * height);
    for (let y = 0; y < height; y++) {
      let offset = y * width;
      for (let x = 0; x < width; x++) {
        pixels[offset + x] = matrix.get(x, y) ? BLACK : WHITE;
      }
    }
    return pixels;
  }

}