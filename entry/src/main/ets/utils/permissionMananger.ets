// 导入必要的模块，包括权限管理相关的功能
import { abilityAccessCtrl, bundleManager, common, Permissions } from '@kit.AbilityKit';

export class PermissionManager {
  // 静态方法用于检查给定的权限是否已经被授予
  static checkPermission(permissions: Permissions[]): boolean {
    // 创建一个访问令牌管理器实例
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    // 初始化tokenID为0，稍后将获取真实的tokenID
    let tokenID: number = 0;

    // 获取本应用的包信息
    const bundleInfo =
      bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);

    // 设置tokenID为应用的访问令牌ID
    tokenID = bundleInfo.appInfo.accessTokenId;

    // 如果没有传入任何权限，则返回false表示没有权限
    if (permissions.length === 0) {
      return false;
    } else {
      // 检查所有请求的权限是否都被授予
      return permissions.every(permission =>
      abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED ===
      atManager.checkAccessTokenSync(tokenID, permission)
      );
    }
  }

  // 异步静态方法用于请求用户授权指定的权限
  static async requestPermission(permissions: Permissions[]): Promise<boolean> {
    // 创建一个访问令牌管理器实例
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();

    // 获取上下文（这里假设getContext是一个可以获取到UI能力上下文的方法）
    let context: Context = getContext() as common.UIAbilityContext;

    // 请求用户授权指定的权限
    const result = await atManager.requestPermissionsFromUser(context, permissions);

    // 检查请求结果是否成功（authResults数组中每个元素都应该是0，表示成功）
    return !!result.authResults.length && result.authResults.every(authResults => authResults === 0);
  }
}