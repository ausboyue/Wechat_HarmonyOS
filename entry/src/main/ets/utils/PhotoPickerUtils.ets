import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';
import { BusinessError } from '@kit.BasicServicesKit';
import { camera, cameraPicker } from '@kit.CameraKit';
import { PermissionUtils } from './PermissionUtils';

/**
 *  相机相册访问工具
 * @author www.icheny.cn
 */
export class PhotoPickerUtils {
  static async openGallery(onSuccess: (uri: string) => void, onFailed: (error: string) => void) {
    try {

      const granted = await PermissionUtils.request(['ohos.permission.WRITE_MEDIA', 'ohos.permission.READ_MEDIA'])
      if (!granted) {
        setTimeout(() => {
          AlertDialog.show({
            title: '温馨提示',
            message: '您已拒绝授予存储权限，是否允许前往设置中心授予权限？',
            autoCancel: false,
            alignment: DialogAlignment.Center,
            primaryButton: {
              value: '拒绝',
              action: () => {
                onFailed("用户拒绝授予存储权限");
              }
            },
            secondaryButton: {
              fontColor: Color.Red,
              value: '允许',
              action: () => {
                PermissionUtils.openPermissionSettingsPage()
                onFailed("用户需要前往设置中心授予存储权限");
              }
            }
          })
        }, 100)
        return
      }
      let PhotoSelectOptions = new picker.PhotoSelectOptions()
      PhotoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE
      PhotoSelectOptions.maxSelectNumber = 1
      let photoPicker = new picker.PhotoViewPicker()
      photoPicker.select(PhotoSelectOptions)
        .then(async res => {
          if (res.photoUris.length < 1) {
            onFailed("用户取消")
            return
          }
          const uri = res.photoUris[0]
          const newFile = await PhotoPickerUtils.copyFileToCache(uri)
          if (newFile.length < 1) {
            onFailed("图片获取失败")
            res
          }
          onSuccess(newFile)
        })
        .catch((err: BusinessError) => {
          onFailed(err.message)
          console.error('PhotoViewPicker.select failed with err: ' + JSON.stringify(err))
        })
    } catch (error) {
      let err: BusinessError = error as BusinessError
      console.error('PhotoViewPicker failed with err: ' + JSON.stringify(err))
      onFailed(err.message)
    }
  }

  static async openCamera(onSuccess: (uri: string) => void, onFailed: (error: string) => void) {
    try {
      const granted = await PermissionUtils.request(['ohos.permission.CAMERA'])
      if (!granted) {
        setTimeout(() => {
          AlertDialog.show({
            title: '温馨提示',
            message: '您已拒绝授予相机权限，是否允许前往设置中心授予权限？',
            autoCancel: false,
            alignment: DialogAlignment.Center,
            primaryButton: {
              value: '拒绝',
              action: () => {
                onFailed("用户拒绝授予相机权限");
              }
            },
            secondaryButton: {
              fontColor: Color.Red,
              value: '允许',
              action: () => {
                PermissionUtils.openPermissionSettingsPage()
                onFailed("用户需要前往设置中心授予相机权限");
              }
            }
          })
        }, 100)
        return
      }

      let pickerProfile: cameraPicker.PickerProfile = {
        cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
      }
      let pickerResult: cameraPicker.PickerResult =
        await cameraPicker.pick(getContext(), [cameraPicker.PickerMediaType.PHOTO, cameraPicker.PickerMediaType.VIDEO],
          pickerProfile)
      if (pickerResult) {
        if (pickerResult.resultUri) {
          onSuccess(pickerResult.resultUri)
        } else {
          onFailed("用户取消")
        }
      } else {
        onFailed("相机不可用")
      }
    } catch (error) {
      let err = error as BusinessError
      console.error(`the pick call failed. error code: ${err.code}`)
      onFailed(err.message)
    }
  }

  /**
   * file开头路径文件外部APP不能直接进行访问，需拷贝到APP目录下的沙箱文件中目录才能访问读取
   */
  static async copyFileToCache(uri: string): Promise<string> {
    try {
      const index = uri.lastIndexOf('.')
      let fileType = index < 0 ? '.jpg' : uri.substring(index)
      if (fileType.length < 1) {
        fileType = '.jpg'
      }
      let dir = getContext().cacheDir + '/pictures'
      if (!fs.accessSync(dir)) {
        fs.mkdirSync(dir)
      }
      let newPath = dir + `/${new Date().getTime()}${fileType}`
      // 将文件拷贝到应用沙箱目录
      const file = fs.openSync(uri, fs.OpenMode.READ_ONLY)
      await fs.copyFile(file.fd, newPath)
      return `file://${newPath}`
    } catch (err) {
      console.info(`PhotoViewPicker:open file failed with error message: ${err.message}, error code: ${err.code}`)
    }
    return ""
  }
}