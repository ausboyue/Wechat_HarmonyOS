import window from '@ohos.window';


export default class StatusBarManager {

  /**
   * 沉浸式状态栏颜色和状态栏icon
   * 一般推荐这个方案，但这个目前仅是api先支持，部分系统还未跟进支持(目前大多数设备无效)
   * 在Ability或Component中使用都可
   */
  static async immerseColor(color?: string, light?: boolean) {
    // 获取当前应用窗口
    let windowClass: window.Window = await window.getLastWindow(getContext())
    // 将状态栏和导航栏的背景色设置为跟应用窗口相同的颜色
    await windowClass.setWindowSystemBarProperties({
      navigationBarColor: color,
      statusBarColor: color,
      navigationBarContentColor: color,
      statusBarContentColor: color,
      isStatusBarLightIcon: light,
      isNavigationBarLightIcon: light
    })
  }

  /**
   * 沉浸式全屏(全屏屏幕，且显示状态栏、导航栏)
   * 仅在Ability使用(Ability全局，且初始化状态栏和导航栏的高度)，建议在 Ability --> onWindowStageCreate 中执行
   */
  static async immerseFullScreen(windowStage: window.WindowStage) {
    let windowClass: window.Window = await windowStage.getMainWindow()
    // 获取状态栏和导航栏的高度
    windowClass.on("avoidAreaChange", ({ type, area }) => {
      if (type == window.AvoidAreaType.TYPE_SYSTEM) {
        // 将状态栏和导航栏的高度保存在AppStorage中
        AppStorage.SetOrCreate<number>("topHeight", area.topRect.height);
        AppStorage.SetOrCreate<number>("bottomHeight", area.bottomRect.height);
      }
    })
    // 设置窗口布局为沉浸式布局
    windowClass.setWindowLayoutFullScreen(true)
    windowClass.setWindowSystemBarEnable(["status", "navigation"])
    // 设置状态栏和导航栏的背景为透明
    windowClass.setWindowSystemBarProperties({
      navigationBarColor: "#00000000",
      statusBarColor: "#00000000",
      navigationBarContentColor: "#00000000",
      statusBarContentColor: "#00000000"
    })
  }

  /**
   * 完全全屏（全铺屏幕，且隐藏状态栏、导航栏）
   * 在Ability或Component中使用都可
   */
  static async fullScreen() {
    let windowClass = await window.getLastWindow(getContext())
    //设置导航栏，状态栏不可见
    await windowClass.setWindowSystemBarEnable([])
  }
}

