import { speechRecognizer } from '@kit.CoreSpeechKit';
import { fileIo } from '@kit.CoreFileKit';


class SpeechRecognizerManager {
  /**
   * 语种信息
   * 语音模式：长
   */
  private static extraParam: Record<string, Object> = { "locate": "CN", "recognizerMode": "long" };
  private static initParamsInfo: speechRecognizer.CreateEngineParams = {
    /**
     * 地区信息
     * */
    language: 'zh-CN',
    /**
     * 离线模式：1
     */
    online: 1,
    extraParams: this.extraParam
  };
  /**
   * 引擎
   */
  private static asrEngine: speechRecognizer.SpeechRecognitionEngine | null = null
  /**
   * 录音结果
   */
  static speechResult: speechRecognizer.SpeechRecognitionResult | null = null
  /**
   * 会话ID
   */
  private static sessionId: string = "asr" + Date.now()

  /**
   * 创建引擎
   */
  private static async createEngine() {
    // 设置创建引擎参数
    SpeechRecognizerManager.asrEngine = await speechRecognizer.createEngine(SpeechRecognizerManager.initParamsInfo)
  }

  /**
   * 设置回调
   */
  private static setListener(callback: (srr: speechRecognizer.SpeechRecognitionResult) => void = () => {
  }) {
    // 创建回调对象
    let setListener: speechRecognizer.RecognitionListener = {
      // 开始识别成功回调
      onStart(sessionId: string, eventMessage: string) {
      },
      // 事件回调
      onEvent(sessionId: string, eventCode: number, eventMessage: string) {
      },
      // 识别结果回调，包括中间结果和最终结果
      onResult(sessionId: string, result: speechRecognizer.SpeechRecognitionResult) {
        SpeechRecognizerManager.speechResult = result
        callback && callback(result)
      },
      // 识别完成回调
      onComplete(sessionId: string, eventMessage: string) {
      },
      // 错误回调，错误码通过本方法返回
      // 如：返回错误码1002200006，识别引擎正忙，引擎正在识别中
      // 更多错误码请参考错误码参考
      onError(sessionId: string, errorCode: number, errorMessage: string) {
      },
    }
    // 设置回调
    SpeechRecognizerManager.asrEngine?.setListener(setListener);
  }

  /**
   * 开始监听
   * */
  static startListening() {
    // 设置开始识别的相关参数
    let recognizerParams: speechRecognizer.StartParams = {
      // 会话id
      sessionId: SpeechRecognizerManager.sessionId,
      // 音频配置信息。
      audioInfo: {
        // 音频类型。 当前仅支持“pcm”
        audioType: 'pcm',
        // 音频的采样率。 当前仅支持16000采样率
        sampleRate: 16000,
        // 音频返回的通道数信息。 当前仅支持通道1。
        soundChannel: 1,
        // 音频返回的采样位数。 当前仅支持16位
        sampleBit: 16
      },
      //   录音识别
      extraParams: {
        // 0 实时录音识别
        "recognitionMode": 0,
        //   最大支持音频时长
        maxAudioDuration: 60000
      }
    }
    // 调用开始识别方法
    SpeechRecognizerManager.asrEngine?.startListening(recognizerParams);
  };

  /**
   * 取消识别
   */
  static cancel() {
    SpeechRecognizerManager.asrEngine?.cancel(SpeechRecognizerManager.sessionId)
  }

  /**
   * 结束识别
   */
  static finish() {
    SpeechRecognizerManager.asrEngine?.finish(SpeechRecognizerManager.sessionId)
  }

  /**
   * 释放ai语音转文字引擎
   */
  static shutDown() {
    SpeechRecognizerManager.asrEngine?.shutdown()
  }

  /**
   * 停止并且释放资源
   */
  static async release() {
    SpeechRecognizerManager.cancel()
    SpeechRecognizerManager.shutDown()

  }

  /**
   * 初始化ai语音转文字引擎 实现一键开启语音识别
   */
  static async init(callback: (srr: speechRecognizer.SpeechRecognitionResult) => void = () => {
  }) {
    await SpeechRecognizerManager.createEngine()
    SpeechRecognizerManager.setListener(callback)
    SpeechRecognizerManager.startListening()
  }
}

export default SpeechRecognizerManager