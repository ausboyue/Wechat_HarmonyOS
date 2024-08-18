import window from '@ohos.window';

export const STATUS_BAR_HEIGHT = "statusBarHeight"

export const NAV_BAR_HEIGHT = "navBarHeight"

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
   * 异步方法：适合动态监听状态栏，导航栏并做相应调整的方式。这种方案比较麻烦，但是用户体验和性能更好。
   * 仅在Ability使用(Ability全局，且初始化状态栏和导航栏的高度)，建议在 Ability --> onWindowStageCreate 中执行
   */
  static async immerseFullScreenAsync(windowStage: window.WindowStage) {
    let windowClass: window.Window = await windowStage.getMainWindow()
    // 获取状态栏和导航栏的高度
    windowClass.on("avoidAreaChange", async data => {
      if (data.type == window.AvoidAreaType.TYPE_SYSTEM) {
        // 将状态栏和导航栏的高度保存在AppStorage中
        AppStorage.setOrCreate<number>(STATUS_BAR_HEIGHT, data.area.topRect.height);
        AppStorage.setOrCreate<number>(NAV_BAR_HEIGHT, data.area.bottomRect.height);
      }
      if (data.type == window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
        // 底部导航栏指示器的高度保存在AppStorage中，这里直接覆盖底部三键导航栏的高度，因为两者显示是互斥的
        AppStorage.setOrCreate<number>(NAV_BAR_HEIGHT, data.area.bottomRect.height);
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
   * 沉浸式全屏(全屏屏幕，且显示状态栏、导航栏)
   * 同步方法：适合一次性定性设置沉浸式状态栏，不会动态调整。此方案大多数场景够用了，用户不会频繁显示|隐藏导航栏。
   * 仅在Ability使用(Ability全局，且初始化状态栏和导航栏的高度)，建议在 Ability --> onWindowStageCreate 中执行
   */
  static immerseFullScreenSync(windowStage: window.WindowStage) {
    // 同步获取一个主窗口实例
    let windowClass: window.Window = windowStage.getMainWindowSync()
    let area = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
    // 获取状态栏和导航栏的高度并保存在AppStorage中
    AppStorage.setOrCreate<number>(STATUS_BAR_HEIGHT, area.topRect.height);
    AppStorage.setOrCreate<number>(NAV_BAR_HEIGHT, area.bottomRect.height);

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

