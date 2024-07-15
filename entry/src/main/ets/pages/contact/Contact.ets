import prompt from '@ohos.promptAction'
import router from '@ohos.router'
import ListContactItem from '../../component/ListContactItem'
import WechatToolbar from '../../component/WechatToolbar'
import DataItem, { ContactItem } from './DataItem'

@Preview
@Component
export default struct Contact {
  private scroller: Scroller = new Scroller()
  private dataList: DataItem[] = [
    {
      title: '',
      contactList: [
        { name: "新的朋友", head: $r("app.media.ic_new_friend") },
        { name: "群聊", head: $r("app.media.ic_group_chat") },
        { name: "标签", head: $r("app.media.ic_tag") },
        { name: "公众号", head: $r("app.media.ic_official_account") }
      ]
    },
    {
      title: 'A',
      contactList: [
        { name: "ArdWard", head: $r("app.media.ic_user_head2") },
        { name: "阿联酋", head: $r("app.media.ic_user_head3") },
        { name: "艾森宝", head: $r("app.media.ic_user_head6") }
      ]
    },
    {
      title: 'B',
      contactList: [
        { name: "宝贝", head: $r("app.media.ic_user_head2") },
        { name: "博士伦", head: $r("app.media.ic_user_head3") },
        { name: "白雪公主", head: $r("app.media.ic_user_head6") }
      ]
    },
    {
      title: 'C',
      contactList: [
        { name: "陈先进", head: $r("app.media.ic_user_head7") },
        { name: "蔡伦", head: $r("app.media.ic_user_head5") },
        { name: "褚卫娟", head: $r("app.media.ic_user_head1") }
      ]
    },
    {
      title: 'D',
      contactList: [
        { name: "达芬奇", head: $r("app.media.ic_user_head3") },
        { name: "丁春秋", head: $r("app.media.ic_user_head4") },
        { name: "邓浩", head: $r("app.media.ic_user_head5") }
      ]
    },
    {
      title: 'S',
      contactList: [
        { name: "石破天", head: $r("app.media.ic_user_head3") },
        { name: "宋浩杰", head: $r("app.media.ic_user_head5") }
      ]
    },
    {
      title: 'Z',
      contactList: [
        { name: "猪八戒", head: $r("app.media.ic_user_head3") },
        { name: "张宇恒", head: $r("app.media.ic_user_head4") },
        { name: "周大年", head: $r("app.media.ic_user_head5") }
      ]
    }
  ];
  private letterList: string[] =
    ['↑', '☆', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U',
      'V', 'W', 'X', 'Y', 'Z', '#']

  @Builder
  itemHead(title: string) {
    Text(title)
      .fontSize(14)
      .visibility("" === title ? Visibility.None : Visibility.Visible)
      .backgroundColor("#EDEDED")
      .height(36)
      .width("100%")
      .padding({ left: 20 })
  }

  build() {
    Stack({ alignContent: Alignment.End }) {

      Column() {
        // 标题栏
        WechatToolbar({ title: "通讯录" })
        // 通讯录列表
        List({ scroller: this.scroller }) {
          // 遍历循环大组标签
          ForEach(this.dataList, (item: DataItem) => {
            // 大组标签
            ListItemGroup({ header: this.itemHead(item.title) }) {
              // 遍历循环大组内的联系人列表
              ForEach(item.contactList, (contact: ContactItem) => {
                // // 小组联系人列表
                ListItem() {
                  ListContactItem({ head: contact.head, name: contact.name })
                }
                .onClick(() => {
                  router.pushUrl({
                    url: 'pages/chat/ChatPage',
                    params: { name: contact.name }
                  })
                })
              })
            }
            .divider({
              strokeWidth: 0.8,
              color: '#f0f0f0',
              startMargin: 85,
              endMargin: 0
            }) // 每行之间的分界线
          })
        }
        .width('100%')
        .height(0)
        .layoutWeight(1)
        .backgroundColor(Color.White)
      }
      .width("100%")
      .height("100%")

      AlphabetIndexer({ arrayValue: this.letterList, selected: 0 })
        .color(Color.Black)
        .font({ size: 14 })
        .selectedFont({ size: 14 })
        .selectedColor(Color.Black)
        .selectedBackgroundColor(Color.Transparent)
        .usingPopup(true)
        .popupColor(Color.Red)
        .popupBackground("#57be6a")
        .popupFont({ size: 32, weight: FontWeight.Bolder })
        .itemSize(20)
        .alignStyle(IndexerAlign.Right)
        .margin({ top: 80 })
        .onSelect((index: number) => {
          let letter = this.letterList[index]
          let target: number = 0
          for (const item of this.dataList) {
            if (letter === item.title) {
              this.scroller.scrollToIndex(target)
              prompt.showToast({ message: "" + target })
              break
            }
            target++
          }
        })

    }.width("100%")
    .height("100%")

  }
}
