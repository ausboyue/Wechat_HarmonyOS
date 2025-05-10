import promptAction from '@ohos.promptAction';
import Log from './Log';

type Msg = string | Resource | number | boolean

export class Toast {
  static show(msg: Msg) {
    Toast.showTime(msg, 2000)
  }

  static showLong(msg: Msg) {
    Toast.showTime(msg, 4000)
  }

  static showTime(msg: Msg, duration: number = 4000) {
    try {
      promptAction.showToast({
        message: (typeof msg === "number" || typeof msg === "boolean") ?
          String(msg) as string : msg,
        duration: duration,
        bottom: "center",
      })
    } catch (error) {
      Log.e(`Toast -->  Catch error! The error code is ${error.code}, The error message is ${error.message}`)
    }
  }
}

