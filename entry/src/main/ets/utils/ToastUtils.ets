import { promptAction } from '@kit.ArkUI';

export class ToastUtils {
  static show(msg: string) {
    ToastUtils.showTime(msg, 2000)
  }

  static showLong(msg: string) {
    ToastUtils.showTime(msg, 4000)
  }

  static showTime(msg: string, duration: number = 4000) {
    try {
      promptAction.showToast({
        message: msg,
        duration: duration,
        bottom: "center",
      })
    } catch (error) {
      console.error(`showToast args error code is ${error.code}, message is ${error.message}`);
    }
  }
}

