import prompt from '@ohos.promptAction';
import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import window from '@ohos.window';
import { ToastUtils } from '../../utils/ToastUtils';
import WindowManager from '../../utils/WindowManager';

@Entry
@Component
export default struct SearchPage {
  private context = getContext(this) as common.UIAbilityContext;
  private controller: TextInputController = new TextInputController()
  private keyboardHeight: number = 0
  @State private searchText: string = ''

  async aboutToAppear() {
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
      Row() {
        Stack() {
          TextInput({ text: this.searchText, placeholder: '搜索', controller: this.controller })
            .placeholderFont({ size: 20, weight: 400 })
            .caretColor(Color.Green)
            .placeholderColor(Color.Grey)
            .width('100%')
            .height("100%")
            .padding({ left: 40, right: 60 })
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
            .onChange((value: string) => {
              this.searchText = value
            })
            .onSubmit(() => {
              prompt.showToast({ message: this.searchText })
            })

          Row() {
            Image($r("app.media.ic_search"))
              .colorBlend(Color.Grey)
              .width(20)
              .height(20)
            if (this.searchText.length != 0) {
              Image($r('app.media.ic_delete'))
                .width(20)
                .height(20)
                .colorBlend(Color.Gray)
                .onClick(() => {
                  this.searchText = ""
                })
            } else {
              Image($r("app.media.ic_voice"))
                .width(23)
                .height(23)
            }
          }
          .width("100%")
          .padding({ left: 10, right: 10 })
          .hitTestBehavior(HitTestMode.None) // NOTE：父组件不消耗触摸事件
          .justifyContent(FlexAlign.SpaceBetween)

          // ,({ placeholder: "搜索", controller: this.controller })
          //   .height("100%")
          //   .textFont({ size: 20, weight: 400 })
          //   .placeholderFont({ size: 20, weight: 400 })
          //   .backgroundColor(Color.White)
          //   .placeholderColor(Color.Grey)
          //   .margin({ left: 20, right: 65 })
          //   .alignRules({
          //     top: { anchor: "__container__", align: VerticalAlign.Top },
          //     left: { anchor: "__container__", align: HorizontalAlign.Start }
          //   })
          //   .id("search")
          //   .onSubmit((value: string) => {
          //     if (value !== null && "" !== value) {
          //       prompt.showToast({ message: value })
          //     }
          //   })
          //   .borderRadius(8)
        }
        .margin({ left: 20 })
        .layoutWeight(1)

        Text("取消")
          .fontColor("#5f6c8a")
          .width(70)
          .height("100%")
          .fontWeight(400)
          .textAlign(TextAlign.Center)
          .fontSize(19)// .alignRules({
            //   top: { anchor: "__container__", align: VerticalAlign.Top },
            //   right: { anchor: "__container__", align: HorizontalAlign.End }
            // })
            // .id("cancel")
          .onClick(() => {
            if ("1" === router.getLength()) {
              // app退出，一般不会走这里
              this.context.terminateSelf()
            } else {
              router.back()
            }
          })
      }
      .width("100%")
      .height(40)
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 10 })


      Text("搜索指定内容")
        .fontColor(Color.Gray)
        .margin({ left: 25, top: 25 })
        .fontSize(15)

      Divider()
        .margin({ left: 25, right: 25, top: 12 })
        .height(0.6)
        .color("#e6e6e6")

      Row() {
        Text("朋友圈")
          .width("25%")
          .fontColor("#5f6c8a")
          .fontSize(17)
          .fontWeight(500)
          .onClick(unDevTip)
          .textAlign(TextAlign.Center)

        Text("公众号")
          .width("25%")
          .fontColor("#5f6c8a")
          .fontSize(17)
          .fontWeight(500)
          .textAlign(TextAlign.Center)
          .onClick(unDevTip)

        Text("小程序")
          .width("25%")
          .fontColor("#5f6c8a")
          .fontSize(17)
          .fontWeight(500)
          .textAlign(TextAlign.Center)
          .onClick(unDevTip)

        Text("视频号")
          .width("25%")
          .fontWeight(500)
          .fontColor("#5f6c8a")
          .fontSize(17)
          .textAlign(TextAlign.Center)
          .onClick(unDevTip)
      }
      .margin({ top: 12 })

      Blank()

      Text("页面设置")
        .fontColor("#5f6c8a")
        .fontSize(17)
        .fontWeight(500)
        .onClick(unDevTip)
        .alignSelf(ItemAlign.Center)
        .margin({ bottom: 80 })

    }
    .width("100%")
    .height("100%")
    .alignItems(HorizontalAlign.Start)
    .backgroundColor("#f3f3f3")
    .padding({ top: WindowManager.statusBarHeight, bottom: WindowManager.navBarHeight })
    .onKeyEvent((event: KeyEvent) => {
      if (event.type === KeyType.Up) {
        prompt.showToast({
          message: "按了返回键"
        });
      }
      event.stopPropagation()
    })
  }
}

const unDevTip = () => {
  ToastUtils.show("功能正在开发中...")
}