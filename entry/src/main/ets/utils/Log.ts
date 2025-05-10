import { hilog } from '@kit.PerformanceAnalysisKit'

class Log {
  private _domain: number
  private _loggable: boolean = true
  private _tag: string = 'Logger'

  constructor() {
    this._domain = 0xFF00
  }

  set tag(tag) {
    if (tag) {
      // It is recommended to set it when the app starts
      this._tag = tag
    }
  }

  set loggable(loggable) {
    this._loggable = loggable
  }

  d(format: string, ...args: any[]): void {
    this.dt(this._tag, format, args)
  }

  dt(tag: string = this._tag, format: string, ...args: any[]): void {
    if (this._loggable) {
      hilog.debug(this._domain, tag, format, args)
    }
  }

  i(format: string, ...args: any[]): void {
    this.it(this._tag, format, args)
  }

  it(tag: string = this._tag, format: string, ...args: any[]): void {
    if (this._loggable) {
      hilog.info(this._domain, tag, format, args)
    }
  }

  w(format: string, ...args: any[]): void {
    this.wt(this._tag, format, args)
  }

  wt(tag: string = this._tag, format: string, ...args: any[]): void {
    if (this._loggable) {
      hilog.warn(this._domain, tag, format, args)
    }
  }

  e(format: string, ...args: any[]): void {
    this.et(this._tag, format, args)
  }

  et(tag: string = this._tag, format: string, ...args: any[]): void {
    if (this._loggable) {
      hilog.error(this._domain, tag, format, args)
    }
  }
}

export default new Log()