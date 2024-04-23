import cloud, { AuthUser } from '@hw-agconnect/cloud'
import hilog from '@ohos.hilog'
import router from '@ohos.router'

@Entry
@Component
struct PersonSet {
  //存储图片地址
  @State photoUrl:string=''
  //存储用户名称
  @State displayName:string=''
  //从AppStorage中获取用户信息
  @StorageLink('user') user:AuthUser=null

  //在用户界面渲染之前，获取到AGC中的用户信息，所以要调用生命周期的aboutToAppear方法
  aboutToAppear(){
    //获取用户信息有两种方法
    //第一种:
    //cloud.auth().getCurrentUser()
    //第二种：我们在MyLoginCustom页面中可以将用户信息存储到AppStorage中
    this.displayName=this.user.getDisplayName()
    this.photoUrl=this.user.getPhotoUrl()
  }

  build() {
    Row() {
      Column({space:10}) {
        //如果用户有头像就用用户给的
       Image(this.photoUrl?this.photoUrl:$r('app.media.user_dark')).width(70).height(70)
         .onClick(()=>{
           this.photoUrl='https://img.zcool.cn/community/01a6095f110b9fa8012066219b67d4.png@1280w_1l_2o_100sh.png'
         })
        //如果用户有名称就用用户给的
        TextInput({placeholder:'请设置名称',text:this.displayName}).width('50%')
          .onChange(value=>{
          this.displayName=value
          })
        Button('保存')
          .onClick(async ()=>{
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
          .onClick(async ()=>{
            try {
              //调用AGC的signOut方法即可登出
              await cloud.auth().signOut()
              hilog.info(0,'SignOut','Success')
              //登出成功后调整到MyLoginCustom页面
              router.replaceUrl({url:'pages/MyLoginCustom'})
            } catch (e) {
              hilog.error(0,'SignOut',JSON.stringify(e))
            }
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}