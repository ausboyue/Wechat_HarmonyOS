import home from './home/Home'
import contact from './contact/Contact'
import discovery from './discovery/Discovery'
import mine from './mine/Mine'
import WindowManager from '../utils/WindowManager'

@Entry
@Component
struct Index {
  @State private currentIndex: number = 0
  private tabController: TabsController = new TabsController()
  private tabTitles: string[] = ["微信", "通信录", "发现", "我"]
  private tabTextColors: string[] = ["#040404", "#57be6a"]
  private tabTipCounts: number[] = [5, 0, 8, 0]

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, controller: this.tabController }) {
        // 微信（首页）
        TabContent() {
          home()
        }
        .tabBar(this.createTabMenu(0))
        // 通讯录
        TabContent() {
          contact()
        }
        .tabBar(this.createTabMenu(1))
        // 发现
        TabContent() {
          discovery()
        }
        .tabBar(this.createTabMenu(2))
        // 我的
        TabContent() {
          mine()
        }
        .tabBar(this.createTabMenu(3))
      }
      .width("100%")
      .height("100%")
      .barHeight(65)
      .backgroundColor("#f4f4f4")
      .vertical(false)
      .layoutWeight(1)
      .padding({bottom:WindowManager.navBarHeight})
      .onChange((index: number) => {
        this.currentIndex = index
      })

    }
    .width('100%')
    .height('100%')
  }

  @Builder createTabMenu(index: number) {

    Stack({ alignContent: Alignment.Center }) {

      // 数字右标
      Badge({
        count: this.tabTipCounts[index],
        maxCount: 99,
        position: BadgePosition.RightTop,
        style: { color: 0xFFFFFF, fontSize: 13, badgeSize: 20, badgeColor: Color.Red }
      }) {
        Column() {
          /**
           * Contain  图片按比例缩放以适应容器边界，可能会出现空白区域
           Cover  图片按比例缩放以填充容器，可能会被裁剪
           Auto  默认值，图片大小保持原始大小
           Fill  图片拉伸以填充容器，可能会出现失真
           ScaleDown  图片按比例缩小以适应容器边界，但是不会放大图片
           None  不进行任何缩放操作，即使图片溢出容器也不会被裁剪或缩放
           */
          // icon图标
          Image(this.currentIndex === index ? `/images/main_page_index${index}_pre.png` : `/images/main_page_index${index}_nor.png`)
            .width(29.714)
            .height(26)
            .objectFit(ImageFit.Fill)
            .margin({ bottom: 3 })
          // 文本
          Text(this.tabTitles[index])
            .fontColor(this.tabTextColors[this.currentIndex === index?1:0])
            .fontSize(14)
        }
        .backgroundColor(Color.Transparent)
        .justifyContent(FlexAlign.Center)
      }
      .width(42)
      .height(40)
    }
    .width("100%")
    .height("100%")
  }
}