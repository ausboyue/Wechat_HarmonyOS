import { abilityAccessCtrl, bundleManager, common, Permissions } from '@kit.AbilityKit';


/**
 * 权限管理工具
 * @author www.icheny.cn
 */
export class PermissionUtils {
  // 检查是否授权
  static check(permissions: Permissions[]): boolean {
    // 程序访问控制管理
    const atManager = abilityAccessCtrl.createAtManager();
    // 获取 bundle 信息
    const bundleInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
    // 提取 tokenID 标识
    const tokenID = bundleInfo.appInfo.accessTokenId
    // 校验应用是否被授予权限
    const authResults = permissions.map((item) => atManager.checkAccessTokenSync(tokenID, item))
    // 返回是否已授权结果
    return authResults.every(v => v === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)
  }

  // 动态申请授权（首次弹窗申请）
  static async request(permissions: Permissions[]): Promise<boolean> {
    if (PermissionUtils.check(permissions)) {
      return true
    }
    // 程序访问控制管理
    const atManager = abilityAccessCtrl.createAtManager();
    // 拉起弹框请求用户授权
    const grantStatus = await atManager.requestPermissionsFromUser(getContext(), permissions)
    // 获取请求权限的结果
    const isAuth = grantStatus.authResults.every(v => v === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)
    // 返回 Promise 授权结果
    return isAuth
  }

  // 打开系统设置的权限管理页（处理授权结果）
  static openPermissionSettingsPage() {
    // 获取上下文
    const context = getContext() as common.UIAbilityContext
    // 获取包信息
    const bundleInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
    // 打开系统设置页
    context.startAbility({
      bundleName: 'com.huawei.hmos.settings',
      abilityName: 'com.huawei.hmos.settings.MainAbility',
      uri: 'application_info_entry',
      parameters: {
        // 按照包名打开对应设置页
        pushParams: bundleInfo.name
      }
    })
  }
}