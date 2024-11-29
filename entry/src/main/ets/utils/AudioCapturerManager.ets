// 导入音频处理模块
import { audio } from '@kit.AudioKit';
// 导入文件系统模块
import fs from '@ohos.file.fs';

// 定义一个接口来描述录音文件的信息
export interface RecordFile {
  recordFilePath: string, // 录音文件的路径
  startRecordTime: number, // 开始录音的时间戳
  endRecordTime: number // 结束录音的时间戳
}

// 定义一个管理音频录制的类
export class AudioCaptureManager {
  // 静态属性，用于存储当前的音频捕获器实例
  static audioCapturer: audio.AudioCapturer | null = null;
  // 静态私有属性，用于存储录音文件的路径
  private static recordFilePath: string = "";
  // 静态私有属性，用于存储开始录音的时间戳
  private static startRecordTime: number = 0;
  // 静态私有属性，用于存储结束录音的时间戳
  private static endRecordTime: number = 0;

  // 静态异步方法，用于创建音频捕获器实例
  static async createAudioCapturer() {
    if (AudioCaptureManager.audioCapturer) {
      return AudioCaptureManager.audioCapturer
    }
    // 设置音频流信息配置
    let audioStreamInfo: audio.AudioStreamInfo = {
      samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_16000, // 设置采样率为16kHz
      channels: audio.AudioChannel.CHANNEL_1, // 设置单声道
      sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE, // 设置样本格式为16位小端
      encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW // 设置编码类型为原始数据
    };

    // 设置音频捕获信息配置
    let audioCapturerInfo: audio.AudioCapturerInfo = {
      source: audio.SourceType.SOURCE_TYPE_MIC, // 设置麦克风为音频来源
      capturerFlags: 0 // 捕获器标志，此处为默认值
    };

    // 创建音频捕获选项对象
    let audioCapturerOptions: audio.AudioCapturerOptions = {
      streamInfo: audioStreamInfo, // 使用上面定义的音频流信息
      capturerInfo: audioCapturerInfo // 使用上面定义的音频捕获信息
    };

    // 创建音频捕获器实例
    AudioCaptureManager.audioCapturer = await audio.createAudioCapturer(audioCapturerOptions);

    // 返回创建的音频捕获器实例
    return AudioCaptureManager.audioCapturer;
  }

  // 静态异步方法，用于启动录音过程
  static async startRecord(fileName: string) {
    await AudioCaptureManager.createAudioCapturer()
    // 记录开始录音的时间戳
    AudioCaptureManager.startRecordTime = Date.now();
    try {
      // 初始化缓冲区大小
      let bufferSize: number = 0;

      // 定义一个内部类来设置写入文件时的选项
      class Options {
        offset?: number; // 文件写入位置偏移量
        length?: number; // 写入数据的长度
      }

      // 获取应用的文件目录路径
      let path = getContext().filesDir;

      // 设置录音文件的完整路径
      let filePath = `${path}/${fileName}.wav`;
      AudioCaptureManager.recordFilePath = filePath;

      // 打开或创建录音文件
      let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);

      // 定义一个读取数据的回调函数
      let readDataCallback = (buffer: ArrayBuffer) => {
        // 创建一个写入文件的选项对象
        let options: Options = {
          offset: bufferSize, // 文件当前位置偏移量
          length: buffer.byteLength // 数据长度
        };
        // 将数据写入文件
        fs.writeSync(file.fd, buffer, options);
        // 更新缓冲区大小
        bufferSize += buffer.byteLength;
      };

      // 给音频捕获器实例注册读取数据的事件监听器
      AudioCaptureManager.audioCapturer?.on('readData', readDataCallback);

      // 开始录音
      AudioCaptureManager.audioCapturer?.start();

      // 返回录音文件的路径
      return filePath;
    } catch (e) {
      // 如果出现异常，返回空字符串
      return "";
    }
  }

  // 静态异步方法，用于停止录音过程
  static async stopRecord() {
    // 停止音频捕获器的工作
    AudioCaptureManager.audioCapturer?.stop();
    // 释放音频捕获器的资源
    AudioCaptureManager.audioCapturer?.release();
    // 清除音频捕获器实例
    AudioCaptureManager.audioCapturer = null;
    // 记录结束录音的时间戳
    AudioCaptureManager.endRecordTime = Date.now();

    // 创建并返回一个包含录音文件信息的对象
    const recordFile: RecordFile = {
      recordFilePath: AudioCaptureManager.recordFilePath,
      startRecordTime: AudioCaptureManager.startRecordTime,
      endRecordTime: AudioCaptureManager.endRecordTime,
    };

    // 返回记录文件信息
    return recordFile;
  }
}