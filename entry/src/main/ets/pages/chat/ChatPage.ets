import router from '@ohos.router';
import prompt from '@ohos.promptAction';
import Toolbar from '../../component/Toolbar';
import ListChatContentLeftItem from '../../component/ListChatContentLeftItem';
import ListChatContentRightItem from '../../component/ListChatContentRightItem';
import window from '@ohos.window';

@Entry
@Component
export default struct ChatPage {
  private name?: string = "微信"
  private controller: TextInputController = new TextInputController()
  @State private chatText: string = ''
  private keyboardHeight: number = 0

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
          ListChatContentRightItem()
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

        TextInput({ text: this.chatText, placeholder: '', controller: this.controller })
          .placeholderFont({ size: 20, weight: 400 })
          .caretColor(Color.Green)
          .placeholderColor(Color.Grey)
          .layoutWeight(1)
          .height(40)
          .padding({ left: 40, right: 60 })
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
          .onSubmit(() => {
            prompt.showToast({ message: this.chatText })
          })
        Image($r("app.media.ic_emoji_pack"))
          .width(33)
          .height(33)
          .borderRadius(4)
          .margin({ left: 15, right: 5 })
          .objectFit(ImageFit.Cover)
          .onClick(unDevTip)

        Image($r("app.media.ic_add"))
          .width(33)
          .height(33)
          .borderRadius(4)
          .margin({ left: 15, right: 5 })
          .objectFit(ImageFit.Cover)
          .onClick(unDevTip)

      }.height(55)
      .alignItems(VerticalAlign.Center)
      .backgroundColor("#f9f9f9")

    }
    .width("100%")
    .height("100%")
    .backgroundColor("#f1f1f1")
  }
}

const unDevTip = () => {
  prompt.showToast({ message: "功能正在开发中...", duration: 2000 })
}