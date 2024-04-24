import cloud, { AuthUser } from '@hw-agconnect/cloud'
import hilog from '@ohos.hilog'
import router from '@ohos.router'
import picker from '@ohos.file.picker'

@Entry
@Component
struct PersonSet {
  //存储图片地址
  @State photoUrl: string = ''
  //存储用户名称
  @State displayName: string = ''
  //从AppStorage中获取用户信息
  @StorageLink('user') user: AuthUser = null

  //在用户界面渲染之前，获取到AGC中的用户信息，所以要调用生命周期的aboutToAppear方法
  aboutToAppear() {
    //获取用户信息有两种方法
    //第一种:
    //cloud.auth().getCurrentUser()
    //第二种：我们在MyLoginCustom页面中可以将用户信息存储到AppStorage中
    this.displayName = this.user.getDisplayName()
    this.photoUrl = this.user.getPhotoUrl()
  }

  build() {
    Row() {
      Column({ space: 10 }) {
        //如果用户有头像就用用户给的
        Image(this.photoUrl ? this.photoUrl : $r('app.media.user_dark')).width(70).height(70)
          .onClick(async () => {
            //this.photoUrl='https://img.zcool.cn/community/01a6095f110b9fa8012066219b67d4.png@1280w_1l_2o_100sh.png'
            try { //1.从相册中选中照片
              //如何获取手机相册中的图片？
              // ArkTS提供的一个叫picker对象，这是ArkTS自带的,PhotoViewPicker().select()作用是从相册中挑选照片
              const options = new picker.PhotoSelectOptions
              //挑选的是照片
              options.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE
              //就挑选一张照片
              options.maxSelectNumber = 1
              //可以从result拿到你选中的照片
              const result = await new picker.PhotoViewPicker().select(options)
              hilog.info(0, 'Upload', `Picker Success ${result.photoUris[0]}`)
              //2.调用AGC云存储API上传照片
              // cloud.storage()代表的就是我们的云存储对象  upload():上传方法
              await cloud.storage().upload({
                //result.photoUris[]：获取选中照片的本地路径,photoUris[]是个数组，而我们又只有一个照片，所以就result.photoUris[0]
                localPath: result.photoUris[0],
                //cloudPath：你AGC云存储下的创建好的文件路径/给你的上传的文件重新取个名字（名字必须唯一）
                cloudPath: `test/${this.user.getUid()}.jpg`
              })
              hilog.info(0, 'Upload', `Picker Success`)
              //3.获取上传照片的公用网络地址
              //获取云存储给予的公网下载地址:getDownloadURL方法是传递的云路径地址 返回的是对应照片的公网地址
              const url = await cloud.storage().getDownloadURL(`test/${this.user.getUid()}.jpg`)
              this.photoUrl = `${url}&ts=${new Date().getTime()}`
              hilog.info(0, 'Upload', `url:${url}`)
            } catch (e) {
              hilog.error(0, 'Upload', JSON.stringify(e))
            }
          })
        //如果用户有名称就用用户给的
        TextInput({ placeholder: '请设置名称', text: this.displayName }).width('50%')
          .onChange(value => {
            this.displayName = value
          })
        Button('保存')
          .onClick(async () => {
            //使用user的updateProfile进行用户信息更新操作
            try {
              await this.user.updateProfile({
                displayName: this.displayName,
                photoUrl: this.photoUrl
              })
              hilog.info(0, 'updateProfile', 'Success')
            } catch (e) {
              hilog.error(0, 'updateProfile', JSON.stringify(e))
            }
          })
        Button('登出')
          .onClick(async () => {
            try {
              //调用AGC的signOut方法即可登出
              await cloud.auth().signOut()
              hilog.info(0, 'SignOut', 'Success')
              //登出成功后调整到MyLoginCustom页面
              router.replaceUrl({ url: 'pages/MyLoginCustom' })
            } catch (e) {
              hilog.error(0, 'SignOut', JSON.stringify(e))
            }
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}