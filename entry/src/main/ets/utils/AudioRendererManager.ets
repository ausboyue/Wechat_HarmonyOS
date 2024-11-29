import { audio } from '@kit.AudioKit';
import { fileIo } from '@kit.CoreFileKit';


class Options {
  offset?: number;
  length?: number;
}


class AudioRendererManager {
  /**
   * 音频播放实例
   */
  private static audioRender: audio.AudioRenderer | null = null

  /** 执行播放 */
  static async doPlay(fileName: string) {
    await AudioRendererManager.ready(fileName)
    AudioRendererManager.start()
  }

  /**
   * 初始化准备
   */
  private static async ready(fileName: string) {

    try {
      let bufferSize: number = 0;
      let audioStreamInfo: audio.AudioStreamInfo = {
        samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_16000, // 采样率
        channels: audio.AudioChannel.CHANNEL_1, // 通道
        sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE, // 采样格式
        encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW // 编码格式
      }
      let audioRendererInfo: audio.AudioRendererInfo = {
        usage: audio.StreamUsage.STREAM_USAGE_MUSIC, // 音频流使用类型
        rendererFlags: 0 // 音频渲染器标志
      }
      let audioRendererOptions: audio.AudioRendererOptions = {
        streamInfo: audioStreamInfo,
        rendererInfo: audioRendererInfo
      }
      let path = getContext().filesDir;
      // let filePath = `${path}/${fileName}.wav`;
      let file: fileIo.File = fileIo.openSync(fileName, fileIo.OpenMode.READ_ONLY);
      const fileSize = fileIo.statSync(file.path).size
      let writeDataCallback = (buffer: ArrayBuffer) => {
        let options: Options = {
          offset: bufferSize,
          length: buffer.byteLength
        }
        fileIo.readSync(file.fd, buffer, options);
        bufferSize += buffer.byteLength;
        //   自动停止
        if (bufferSize >= fileSize) {
          AudioRendererManager.stop()
            .then(() => {
              AudioRendererManager.release()
            })
        }
      }
      AudioRendererManager.audioRender = await audio.createAudioRenderer(audioRendererOptions)
      AudioRendererManager.audioRender.on("writeData", writeDataCallback)
    } catch (e) {
      console.log("e", e.message, e.code)
    }
  }

  /** 播放 */
  static async start() {
    // 当且仅当状态为prepared、paused和stopped之一时才能启动渲染
    await AudioRendererManager.audioRender?.start();
  }

  /** 暂停播放*/
  static async pause() {
    await AudioRendererManager.audioRender?.pause()
  }

  /** 结束播放 */
  static async stop() {
    await AudioRendererManager.audioRender?.stop()
  }

  /** 释放资源 */
  static async release() {
    await AudioRendererManager.audioRender?.release()
  }
}

export default AudioRendererManager