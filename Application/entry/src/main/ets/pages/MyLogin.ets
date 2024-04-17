import { Login } from '@hw-agconnect/auth-component/src/main/ets/components/Login/Login'
import { AuthMode } from '@hw-agconnect/auth-component/src/main/ets/common/AuthModeEnum'
import { AuthUser } from '@hw-agconnect/cloud/src/main/ets/auth/Auth'
import router from '@ohos.router'

@Entry
@Component
struct MyLogin {

  build() {
    Row() {
      Column() {
        //Login是我们AGC认证组件提供好的认证登录模板
        Login({
          //modes参数是数组形式所以可以支持多种认证模式，也就是你的认证模式：有两种：手机认证或者邮箱认证
          modes:[AuthMode.PHONE_VERIFY_CODE],
          //onSuccess是个函数回调，就表示你认证一旦成功以后要做什么事情
          onSuccess:(user:AuthUser)=>{  //user:AuthUser :它会传过来一个认证成功后的用户信息
            user.getUid()         //获取用户唯一标识
            user.getPhone()       //使用手机认证 获取手机号
            user.getEmail()       //使用邮箱认证 获取邮箱
            user.getUserExtra()   //获取用户创建时间和最近一次登录时间
            user.getDisplayName() //获取名称
            user.getPhotoUrl()    //获取头像
            //获取令牌  相当于你第一次认证成功了以后，那么后续的一些请求他就会把这个令牌携带在请求头里发给服务器
            //以后就用这个令牌作为认证的凭据
            user.getToken(false)

            //updateProfile被方法调用的时候，我们可以指定这个用户的photoUrl（头像地址）、displayName（名称）
            //也就是说你得先调这个updateProfile方法之后，那么昵称和头像才有值
            user.updateProfile({photoUrl:'',displayName:''})
            //就是用来更新密码的,当然更新密码之前,你得提供一个你是通过手机验证码去更新密码还是通过邮件验证码去更新密码
            //也就是说，在更新密码之前还要做一次验证  verifyCode:收到的验证码  providerType:是手机验证还是邮箱验证  password：你要更新的那个新密码
            user.updatePassword({password:'',providerType:'phone',verifyCode:''})
            //认证成功了，我们希望跳转到一个新页面去
            router.pushUrl({url:'pages/MyWelcome'})
          }
        }) { //而这个花括号是绘制 如何启动Login认证登录模板的组件
          //这里不需要给Button('登录')添加onClick点击事件，因为LOGIN组件里已经包括了单击事件
          Button('登录')  //通过点击《登录》按钮挑出Login模板登录认证的对话框
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}