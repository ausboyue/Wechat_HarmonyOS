import router from '@ohos.router'
import ListChatItem, { ChatItemData } from '../../component/ListChatItem'
import WechatToolbar from '../../component/WechatToolbar'

@Preview
@Component
export default struct Home {
  @State chatList: ChatItemData[] = [
    {
    headSrc: $r("app.media.ic_user_head2"),
    nickname: "老婆",
    content: "今晚给你做了好吃的，早点下班哦😊",
    time: "17:21"
  },
    {
      headSrc: $r("app.media.ic_user_head3"),
      nickname: "游戏好友",
      content: "我今天又拿了五杀，牛逼不？",
      time: "15:38"
    },
    { headSrc: $r("app.media.ic_user_head4"),
      nickname: "同事小李",
      content: "领导，报给写好了，请过目",
      time: "14:12"
    },
    { headSrc: $r("app.media.ic_user_head5"),
      nickname: "HR小孙",
      content: "这个岗位还需要招两个人",
      time: "12:08"
    },
    { headSrc: $r("app.media.ic_user_head6"),
      nickname: "客户小潘",
      content: "这是我们公司的报价，希望您能考虑下",
      time: "昨天" },
    { headSrc: $r("app.media.ic_user_head7"),
      nickname: "老弟",
      content: "好的，哥",
      time: "周一" }
  ]

  build() {
    Column() {
      WechatToolbar({ title: "微信(5)" })

      List() {
        ForEach(this.chatList, (item: ChatItemData, index: number) => {
          ListItem() {
            ListChatItem({ data: item })
          }
          .onClick(() => {
            router.pushUrl({ url: 'pages/chat/ChatPage',
              params: {name:item.nickname}
            })
          })
        })
        ListItem() {
          Divider().color('#0000').strokeWidth(0)
        }
      }
      .divider({ strokeWidth: 0.8, color: '#f0f0f0', startMargin: 90, endMargin: 0 }) // 每行之间的分界线
      .backgroundColor(Color.White)
      .width("100%")
      .height("100%")

    }
    .width("100%")
    .height("100%")
    .backgroundColor("#f0f0f0")
  }
}
