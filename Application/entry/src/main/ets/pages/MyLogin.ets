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