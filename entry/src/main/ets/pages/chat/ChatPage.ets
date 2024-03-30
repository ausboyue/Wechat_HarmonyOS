import router from '@ohos.router';
import prompt from '@ohos.promptAction';
import Toolbar from '../../component/Toolbar';
import ListChatContentLeftItem from '../../component/ListChatContentLeftItem';
import ListChatContentRightItem from '../../component/ListChatContentRightItem';
import window from '@ohos.window';
import { NAV_BAR_HEIGHT } from '../../utils/StatusBarManager';
import ChatFunctionBar from './ChatFuntionBar';

@Entry
@Component
export default struct ChatPage {
  private name?: string = "微信"
  private controller: TextAreaController = new TextAreaController()
  @State private chatText: string = ''
  @State private showFunctionBar: boolean = false
  private keyboardHeight: number = 0
  @StorageLink(NAV_BAR_HEIGHT) navBarHeight: number = 0

  async aboutToAppear() {
    this.name = router.getParams()['name']
    await window.getLastWindow(getContext(this)).then(currentWindow => {
      currentWindow.on('keyboardHeightChange', (height) => {
        this.keyboardHeight = height;
      })
    })
  }

  onBackPress() {
    return this.keyboardHeight > 0
  }

  build() {
    Column() {
      Toolbar({ title: this.name })
      List({ space: 20, initialIndex: 5 }) {
        ListItem() {
          ListChatContentLeftItem()
        }

        ListItem() {
          ListChatContentRightItem()
        }

        ListItem() {
          ListChatContentLeftItem()
        }

        ListItem() {
          ListChatContentRightItem()
        }

        ListItem() {
          ListChatContentLeftItem()
        }

        ListItem() {
          ListChatContentRightItem().margin({ bottom: 15 })
        }

      }
      .width("100%")
      .height(0)
      // .divider({ strokeWidth: 0.8, color: '#f0f0f0', startMargin: 90, endMargin: 0 }) // 每行之间的分界线
      .layoutWeight(1)

      Row() {
        Image($r("app.media.ic_use_voice"))
          .width(33)
          .height(33)
          .borderRadius(4)
          .margin({ left: 15, right: 15 })
          .objectFit(ImageFit.Cover)
          .onClick(unDevTip)

        TextArea({ text: this.chatText, placeholder: '', controller: this.controller })
          .placeholderFont({ size: 20, weight: 400 })
          .caretColor(Color.Green)
          .placeholderColor(Color.Grey)
          .layoutWeight(1)
          .padding({ left: 8, right: 8 })
          .fontSize(20)
          .fontColor(Color.Black)
          .borderRadius(8)
            // 设置stateStyles，解决点击编辑框会变色的问题
          .stateStyles({
            normal: {.backgroundColor(Color.White)
            },
            pressed: {.backgroundColor(Color.White)
            },
            clicked: {.backgroundColor(Color.White)
            },
            focused: {.backgroundColor(Color.White)
            } })
          .onChange((value: string) => {
            this.chatText = value
          })
        // .onSubmit(() => {
        //   prompt.showToast({ message: this.chatText })
        // })

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
            prompt.showToast({ message: this.chatText })
          })

        Image($r("app.media.ic_add"))
          .width(33)
          .height(33)
          .borderRadius(4)
          .visibility(this.chatText.length == 0 ? Visibility.Visible : Visibility.None)
          .margin({ left: 15, right: 8 })
          .objectFit(ImageFit.Cover)
          .onClick(() => {
            this.showFunctionBar = !this.showFunctionBar
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

      ChatFunctionBar().visibility(this.showFunctionBar ? Visibility.Visible : Visibility.None)

      // 在界面底部放置一个与导航栏同高度的组件，用于占位，可避免界面内容与状态栏内容重叠
      Row().height(px2vp(this.navBarHeight))

    }
    .width("100%")
    .height("100%")
    .backgroundColor("#f1f1f1")
  }
}

const unDevTip = () => {
  prompt.showToast({ message: "功能正在开发中...", duration: 2000 })
}