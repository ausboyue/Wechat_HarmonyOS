import router from '@ohos.router';
import Toolbar from '../../component/Toolbar';
import ListChatContentLeftItem from '../../component/ListChatContentLeftItem';
import ListChatContentRightItem from '../../component/ListChatContentRightItem';
import window from '@ohos.window';
import WindowManager from '../../utils/WindowManager';
import ChatFunctionBar from './ChatFuntionBar';
import { ChatContentItemData } from './ChatContentItemData';
import ChatPageParam from './ChatPageParam';
import { Toast } from '../../utils/Toast';
import SpeechRecognizerManager from '../../utils/SpeechRecognizerManager';
import { AudioCaptureManager, RecordFile } from '../../utils/AudioCapturerManager';
import { componentUtils } from '@kit.ArkUI';
import { vibrator } from '@kit.SensorServiceKit';
import { PermissionUtils } from '../../utils/PermissionUtils';

enum WXInputType {
  /**
   * 语音输入
   */
  voice = 0,
  /**
   * 文本输入
   */
  keyboard = 1
}

enum MessageType {
  /**
   * 声音
   */
  voice = 0,
  /**
   * 文本
   */
  text = 1
}

// 消息
class ChatMessage {
  /**
   * 消息类型：【录音、文本】
   */
  type: MessageType
  /**
   * 内容 [录音-文件路径，文本-内容]
   */
  content: string
  /**
   * 消息时间
   */
  time: string
  /**
   * 声音的持续时间 单位毫秒
   */
  duration?: number
  /**
   * 录音转的文字
   */
  translateText?: string
  /**
   * 是否显示转好的文字
   */
  isShowTranslateText: boolean = false

  constructor(type: MessageType, content: string, duration?: number, translateText?: string) {
    this.type = type
    this.content = content
    const date = new Date()
    this.time = `${date.getHours().toString().padStart(2, '0')}:${date.getMinutes().toString().padStart(2, '0')}`
    this.duration = duration
    this.translateText = translateText
  }
}

enum PressCancelVoicePostText {
  // 没有长按
  none = 0,
  //   长按 没有选中“取消发送”或者"转语音"
  pressing = 1,
  //   取消发送
  cancelVoice = 2,
  //   转文字
  postText = 3
}

/**
 * 长按时，手指的坐标
 */
interface ScreenOffset {
  x: number
  y: number
  width: number
  height: number
}

@Entry
@Component
export default struct ChatPage {
  private name?: string = "微信"
  private controller: TextAreaController = new TextAreaController()
  private scroller: Scroller = new Scroller()
  @State private chatText: string = ''
  private keyboardHeight: number = 0
  @State private funcBarHeight: number = 0;
  @State private showFuncBar: boolean = false;
  @State private dataList: ChatContentItemData[] = [
    {
      name: "鲁班",
      headSrc: $r("app.media.ic_user_head2"),
      msgType: 0,
      self: true,
      msg: "现在几点了？"
    },
    {
      name: "王昭君",
      headSrc: $r("app.media.ic_user_head3"),
      msgType: 0,
      self: false,
      msg: "10点，怎么了？"
    },
    {
      name: "鲁班",
      headSrc: $r("app.media.ic_user_head2"),
      msgType: 1,
      self: true,
      msg: "",
      img: $r("app.media.ic_its_over")
    },
    {
      name: "鲁班",
      headSrc: $r("app.media.ic_user_head2"),
      msgType: 0,
      self: true,
      msg: "我要迟到了！！！",
    }
    ,
    {
      name: "王昭君",
      headSrc: $r("app.media.ic_user_head3"),
      msgType: 1,
      self: false,
      msg: "",
      img: $r("app.media.ic_hahaha")
    }
    ,
    {
      name: "王昭君",
      headSrc: $r("app.media.ic_user_head3"),
      msgType: 0,
      self: false,
      msg: "那赶紧粗发吧，哈哈哈哈哈哈哈",
    }
    ,
    {
      name: "鲁班",
      headSrc: $r("app.media.ic_user_head2"),
      msgType: 0,
      self: true,
      msg: "嗯嗯，不说了，这就飞奔过去。。。",
    }
  ]
  // 输入框内容
  @State
  textValue: string = ""
  // 输入状态 语音或者文字
  @State
  inputType: WXInputType = WXInputType.keyboard
  // 语音识别的文字
  @State
  voiceToText: string = ""
  // 消息
  @State
  chatList: ChatMessage[] = []
  // 按住说话 录音模态
  @State
  showTalkContainer: boolean = false
  // 长按状态
  @State
  pressCancelVoicePostText: PressCancelVoicePostText = PressCancelVoicePostText.none
  //用来配置 CanvasRenderingContext2D 对象的参数，包括是否开启抗锯齿，true表明开启抗锯齿。
  settings: RenderingContextSettings = new RenderingContextSettings(true)
  //用来创建CanvasRenderingContext2D对象，通过在canvas中调用CanvasRenderingContext2D对象来绘制。
  context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  // 声明波纹定时器id
  voiceTimeId: number = -1
  // 底部录音气泡的坐标
  bubbleScreenOffset: ScreenOffset = {
    x: 0,
    y: 0,
    width: 0,
    height: 0
  }
  // 录音文件名称
  recordFileName: string = ""
  // 发送文本消息
  sendTextMessage = () => {
    if (!this.textValue.trim()) {
      return
    }
    const chat = new ChatMessage(MessageType.text, this.textValue.trim())
    this.chatList.push(chat)
    this.textValue = ""
  }
  // 按住说话 持续触发
  onPressTalk = async (event: TouchEvent) => {
    if (event.type === TouchType.Down) {
      // 手指按下时触发
      this.pressCancelVoicePostText = PressCancelVoicePostText.pressing
      // 按下
      this.showTalkContainer = true
      // 震动反馈
      this.startVibration()

      //  开始录音
      this.onStartRecord()

      // 实时语音识别
      this.onStartSpeechRecognize()

    } else if (event.type === TouchType.Move) {
      // 手指移动时持续触发
      this.pressCancelVoicePostText = PressCancelVoicePostText.pressing
      // 获取当前手指的坐标
      const x = event.touches[0].displayX
      const y = event.touches[0].displayY
      // 判断是否碰到了 “X”
      let isTouchX = x <= this.bubbleScreenOffset.width / 2 && y < this.bubbleScreenOffset.y
      // 判断是否碰到了 "文"
      let isTouchText = x > this.bubbleScreenOffset.width / 2 && y < this.bubbleScreenOffset.y
      if (isTouchX) {
        // 取消发送
        this.pressCancelVoicePostText = PressCancelVoicePostText.cancelVoice
      } else if (isTouchText) {
        // 转换文字
        this.pressCancelVoicePostText = PressCancelVoicePostText.postText
      }
    } else if (event.type === TouchType.Up) {
      // 松开手
      this.showTalkContainer = false
      // 停止录音 res 为录音文件信息，包括录音路径、时长等信息
      const res = await this.stopRecord()
      // 结束AI语音识别
      SpeechRecognizerManager.release()

      if (this.pressCancelVoicePostText === PressCancelVoicePostText.postText) {
        // 转换文字
        this.postText()
      } else if (this.pressCancelVoicePostText === PressCancelVoicePostText.cancelVoice) {
        // 取消发送
        this.voiceToText = ''
      } else {
        // 发送录音
        this.postVoice(res)
      }
    }
  }

  async aboutToAppear() {
    this.name = (router.getParams() as ChatPageParam).name
    await window.getLastWindow(getContext(this)).then(currentWindow => {
      currentWindow.on('keyboardHeightChange', (height) => {
        this.keyboardHeight = height;
      })
    })
  }

  onBackPress() {
    return this.keyboardHeight > 0
  }

  // 开始录音
  onStartRecord = () => {
    // 文件名  唯一
    this.recordFileName = Date.now().toString()
    AudioCaptureManager.startRecord(this.recordFileName)
  }
  // 结束录音
  stopRecord = async () => {
    // res 记录录音文件的路径、时长等信息  这里返回是为了实现 发送录音消息
    const res = await AudioCaptureManager.stopRecord()
    return res
  }
  // 生成声音消息
  postVoice = (res: RecordFile) => {
    // 录音时长  录音结束时间-开始录音时间
    const duration = Math.ceil((res.endRecordTime - res.startRecordTime) / 1000)
    //   生成消息文件
    const voiceChat = new ChatMessage(MessageType.voice, res.recordFilePath, duration)
    //   插入到消息数组中
    this.chatList.push(voiceChat)
    this.dataList.push({
      name: "鲁班",
      headSrc: $r("app.media.ic_user_head2"),
      msgType: 2,
      voicePath: res.recordFilePath,
      self: true,
      msg: `${duration}"`,
      img: $r("app.media.ic_voice_msg_right")
    })
    this.scroller.scrollToIndex(this.dataList.length)
  }
  // 开启ai实时转换声音
  onStartSpeechRecognize = () => {
    // 如果你是完整的一句话，我把它拼接到 this.voiceToText 如果不是，实时显示
    // 缓存一段句子的变量
    let sentence = ""
    SpeechRecognizerManager.init((res) => {
      // console.log("res", JSON.stringify(res))
      //   isFinal  这一句话 你结束了没有
      //   isLast 这一段语音你结束了没有
      // this.voiceToText = res.result
      if (res.isFinal) {
        sentence += res.result
        this.voiceToText = sentence
      } else {
        this.voiceToText = sentence + res.result
      }

    })
  }
  // 生成文字消息
  postText = () => {
    //   生成消息文件
    const TextChat = new ChatMessage(MessageType.text, this.voiceToText)
    //   插入到消息数组中
    this.chatList.push(TextChat)
  }

  build() {
    Column() {
      Toolbar({ title: this.name })
      List({ space: 20, initialIndex: this.dataList.length, scroller: this.scroller }) {
        ForEach(this.dataList, (item: ChatContentItemData) => {
          ListItem() {
            if (item.self) {
              ListChatContentRightItem({ data: item })
            } else {
              ListChatContentLeftItem({ data: item })
            }
          }
        })
        ListItem() {
          Row().height(px2vp(20))
        }
      }
      .width("100%")
      .height(0)
      // .divider({ strokeWidth: 0.8, color: '#f0f0f0', startMargin: 90, endMargin: 0 }) // 每行之间的分界线
      .layoutWeight(1)

      Row() {

        if (this.inputType == WXInputType.keyboard) {
          Image($r("app.media.ic_use_voice"))
            .width(33)
            .height(33)
            .borderRadius(4)
            .margin({ left: 15, right: 15 })
            .objectFit(ImageFit.Cover)
            .onClick(async () => {
              const result = await PermissionUtils.request(["ohos.permission.MICROPHONE"])
              if (!result) {
                Toast.show("请先授权麦克风权限")
              }
              this.inputType = WXInputType.voice
              this.showFuncBarWithAnim(false)
            })

          TextArea({ text: $$this.chatText, placeholder: '', controller: this.controller })
            .placeholderFont({ size: 20, weight: 400 })
            .caretColor(Color.Green)
            .placeholderColor(Color.Grey)
            .layoutWeight(1)
            .padding({ left: 8, right: 8 })
            .fontSize(20)
            .fontColor(Color.Black)
            .borderRadius(8)// 设置stateStyles，解决点击编辑框会变色的问题
            .stateStyles({
              normal: {.backgroundColor(Color.White)
              },
              pressed: {.backgroundColor(Color.White)
              },
              clicked: {.backgroundColor(Color.White)
              },
              focused: {.backgroundColor(Color.White)
              }
            })
          // .onSubmit(() => {
          //   prompt.showToast({ message: this.chatText })
          // })
        } else {
          Image($r("app.media.ic_use_keyboard"))
            .width(33)
            .height(33)
            .borderRadius(4)
            .margin({ left: 15, right: 15 })
            .objectFit(ImageFit.Cover)
            .onClick(() => {
              this.inputType = WXInputType.keyboard
            })

          Button("按住 说话")
            .fontColor(Color.Black)
            .layoutWeight(1)
            .type(ButtonType.Normal)
            .borderRadius(8)
            .backgroundColor(Color.White)
            .fontSize(18)
            .bindContentCover($$this.showTalkContainer, this.buildRecordVoiceView,
              { modalTransition: ModalTransition.NONE })
            .onTouch(this.onPressTalk)
        }


        Image($r("app.media.ic_emoji_pack"))
          .width(33)
          .height(33)
          .borderRadius(4)
          .margin({ left: 15, right: 5 })
          .objectFit(ImageFit.Cover)
          .onClick(unDevTip)


        Text("发送")
          .fontColor(Color.White)
          .width(65)
          .textAlign(TextAlign.Center)
          .height(36)
          .backgroundColor("#58BE6A")
          .fontSize(18)
          .visibility(this.chatText.length == 0 ? Visibility.None : Visibility.Visible)
          .borderRadius(6)
          .margin({ left: 10, right: 10 })
          .onClick(() => {
            this.sendTextMsg()
          })

        Image($r("app.media.ic_add"))
          .width(33)
          .height(33)
          .borderRadius(4)
          .visibility(this.chatText.length == 0 ? Visibility.Visible : Visibility.None)
          .margin({ left: 15, right: 8 })
          .objectFit(ImageFit.Cover)
          .onClick(() => {
            if (!this.showFuncBar) {
              this.inputType = WXInputType.keyboard
            }
            this.showFuncBarWithAnim(!this.showFuncBar)
          })

      }
      .padding({ top: 10, bottom: 10 })
      .alignItems(VerticalAlign.Bottom)
      .backgroundColor("#f9f9f9")

      Divider()
        .vertical(false)
        .color("#f0f0f0")
        .strokeWidth(1)
        .lineCap(LineCapStyle.Round)

      ChatFunctionBar()
        .height(this.funcBarHeight)

    }
    .width("100%")
    .height("100%")
    .backgroundColor("#f1f1f1")
    .padding({ bottom: WindowManager.navBarHeight })
  }

  private sendTextMsg() {
    this.dataList.push({
      name: "鲁班",
      headSrc: $r("app.media.ic_user_head2"),
      msgType: 0,
      self: true,
      msg: this.chatText,
    })
    this.scroller.scrollToIndex(this.dataList.length)
    this.chatText = ""
  }

  private showFuncBarWithAnim(show: boolean) {
    animateTo({ duration: 400, curve: Curve.Ease }, () => {
      if (show) {
        this.funcBarHeight = 250;
      } else {
        this.funcBarHeight = 0;
      }
      this.showFuncBar = show;
    })
  }

  @Builder
  buildRecordVoiceView() {
    Column() {
      // 中心波浪线
      Row() {
        if (this.pressCancelVoicePostText !== PressCancelVoicePostText.postText) {
          // 声纹
          this.vocalPrint()

        } else {
          Scroll() {
            // 显示录音的文字
            Text(this.voiceToText)
              .fontSize(12)
              .fontColor("#666")
          }
          .width("100%")
          .height("100%")
        }

        Text()
          .width(10)
          .height(10)
          .backgroundColor(this.pressCancelVoicePostText === PressCancelVoicePostText.cancelVoice ? Color.Red :
            "#95EC6A")
          .position({
            bottom: -5,
            left: "50%"
          })
          .translate({
            x: "-50%"
          })
          .rotate({
            angle: 45
          })
      }
      .width("50%")
      .height(80)
      .backgroundColor(this.pressCancelVoicePostText === PressCancelVoicePostText.cancelVoice ? Color.Red : "#95EC6A")
      .position({
        top: "40%",
        left: "50%"
      })
      .translate({
        x: "-50%"
      })
      .borderRadius(10)
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)

      // 取消和转文字
      Row() {
        // X
        Row() {
          Text("X")
            .fontSize(20)
            .width(80)
            .height(80)
            .borderRadius("50%")
            .fontColor(this.pressCancelVoicePostText === PressCancelVoicePostText.cancelVoice ? "#333" : Color.Gray)
            .backgroundColor(this.pressCancelVoicePostText === PressCancelVoicePostText.cancelVoice ? Color.White :
              "#333")
            .textAlign(TextAlign.Center)
            .align(Alignment.Center)
            .fontColor("#ccc")
            .id("cancel_record")
            .rotate({ angle: -15 })
        }

        // 文
        Row() {
          Text("文")
            .fontSize(20)
            .width(80)
            .height(80)
            .borderRadius("50%")
            .fontColor(this.pressCancelVoicePostText === PressCancelVoicePostText.postText ? "#333" : Color.Gray)
            .backgroundColor(this.pressCancelVoicePostText === PressCancelVoicePostText.postText ? Color.White : "#333")
            .textAlign(TextAlign.Center)
            .align(Alignment.Center)
            .id("translate_text")
            .rotate({ angle: 15 })
        }

        // 3  松开发送
        Text(this.pressCancelVoicePostText === PressCancelVoicePostText.cancelVoice ? '取消发送' :
          (this.pressCancelVoicePostText === PressCancelVoicePostText.postText ? '转换文字' : "松开发送"))
          .fontColor("#fff")
          .width("100%")
          .position({
            bottom: 0,
            left: 0
          })
          .textAlign(TextAlign.Center)
      }
      .width("100%")
      .position({
        bottom: "23%"
      })
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: 35, right: 35
      })


      Stack() {
        Text()
          .width(800)
          .height(800)
          .backgroundColor("#AAAAAA")
          .borderRadius("50%")// .position({ top: 0 ,left:"-50%"})
            // .position({ top: 0 ,left:"-50%"})
          .position({ top: 0, left: "50%" })
          .translate({
            x: "-50%",
          })

        Image($r("app.media.ic_voice_msg_left"))
          .width(33)
          .height(33)
          .objectFit(ImageFit.Cover)
      }
      .width("100%")
      .height(150)
      .alignContent(Alignment.Center)
      .position({
        bottom: 0
      })
      .id("bottom_bubble")
      .onAppear(() => {
        let modePosition: componentUtils.ComponentInfo = componentUtils.getRectangleById("bottom_bubble");
        this.bubbleScreenOffset.x = px2vp(modePosition.localOffset.x)
        this.bubbleScreenOffset.y = px2vp(modePosition.localOffset.y)
        this.bubbleScreenOffset.width = px2vp(modePosition.size.width)
        this.bubbleScreenOffset.height = px2vp(modePosition.size.height)
      })

    }
    .width("100%")
    .height("100%")
    .backgroundColor("#9F000000")
  }

  /**
   * 录音中的 动态声纹波浪
   */
  @Builder
  vocalPrint() {
    Canvas(this.context)
      .onDisAppear(() => {
        clearInterval(this.voiceTimeId)
      })
      .width('80%')
      .height('80%')
      .onReady(() => {
        clearInterval(this.voiceTimeId)
        this.voiceTimeId = setInterval(() => {
          this.context.clearRect(0, 0, 200, 200)
          for (let index = 0; index < 35; index++) {
            const random = Math.floor(Math.random() * 20)
            let height = 5 + random
            this.context.fillRect(10 + index * 5, 32 - height / 2, 2, height);
          }
        }, 100)
      })
  }

  private async startVibration() {
    try {
      // 触发马达振动
      vibrator.startVibration({
        type: 'time',
        duration: 100,
      }, {
        id: 0,
        usage: 'touch'
      }, () => {
      })
    } catch (err) {
    }
  }
}


const unDevTip = () => {
  Toast.show("功能正在开发中...")
}

