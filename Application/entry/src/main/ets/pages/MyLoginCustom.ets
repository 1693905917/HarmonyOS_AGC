import cloud, { VerifyCodeAction } from '@hw-agconnect/cloud'
import hilog from '@ohos.hilog'
import router from '@ohos.router'

@Entry
@Component
struct MyLoginCustom {
  //倒计时
  @State countDown:number =10
  //存储定时器ID
  intervalId:number =0
  //动态显示“获取验证码”按键的状态
  @State verifyCodeButtonText:string='获取验证码'
  //“获取验证码”按钮的可用与不可用设置
  @State verifyCodeButtonEnable:boolean =true
  //记录手机号
  @State phoneNumber:string =''
  //记录验证码
  @State verifyCode:string =''
  build() {
    Row() {
      Column({ space: 10 }) {
        Text('登录').fontSize(40).fontWeight(FontWeight.Bold)
        Divider()
        TextInput({ placeholder: '请输入手机号' })
          .onChange(value=>{
            //获取用户输入的手机号
            this.phoneNumber=value
          }).width('80%').type(InputType.Number)
        Row({ space: 10 }) {
          TextInput({ placeholder: '请输入验证码' }).width('55%').type(InputType.Number)
            .onChange( value=>{
              this.verifyCode=value
            })
          Button(this.verifyCodeButtonText).enabled(this.verifyCodeButtonEnable)
            .enabled(this.phoneNumber.length==11)
            .onClick( async()=>{
              this.wait()
              this.sending()
            })
        }.width('80%').justifyContent(FlexAlign.SpaceBetween)
        Button('登录')
          .enabled(this.phoneNumber.length==11 && this.verifyCode.length==6)
          .onClick(async()=>{
            this.login()
          })
      }
      .width('100%')
    }
    .height('100%')
  }

  wait(){
    //通过setInterval开启一个定时器 该定时器是ms为单位，1000ms=1s
    //一秒执行一次
    this.verifyCodeButtonText=`${this.countDown} s`
    this.verifyCodeButtonEnable=false
    this.intervalId=setInterval(()=>{
      this.verifyCodeButtonText=`${this.countDown} s`
      //判断countDown在减到<0以后获取初始状态
      if(this.countDown<0){
        //我们就要清除定时器，clearInterval需要一个参数，对应开启定时器的ID，而ID来自setInterval的返回值
        clearInterval(this.intervalId)
        this.countDown=10
        this.intervalId=0
        this.verifyCodeButtonText='获取验证码'
        this.verifyCodeButtonEnable=true
        return
      }
      this.countDown--
    },1000)
  }

  async sending(){
    //发送验证码
    try {
      await cloud.auth().requestVerifyCode({
        verifyCodeType: {
          kind: 'phone',
          phoneNumber: this.phoneNumber,
          countryCode: '86'
        },
        action: VerifyCodeAction.REGISTER_LOGIN,
        lang: 'zh_CN',
        sendInterval: 10
      })
      hilog.info(0,'VerifyCode','Success')
    } catch (e) {
      //弹窗  title：弹窗标题   message：弹窗要呈现的内容
      AlertDialog.show({title:'错误',message:'验证码发送失败'})
      hilog.error(0,'VerifyCode',JSON.stringify(e))
    }
  }

  async login(){
    try { //signIn:登录
      const result= await cloud.auth().signIn({
        credentialInfo: {
          kind: 'phone',
          countryCode: '86',
          phoneNumber: this.phoneNumber,
          verifyCode: this.verifyCode
        }
      })
      const user= result.getUser()
      //登录成功调整页面
      router.replaceUrl({url:'pages/MyWelcome'})
      hilog.info(0,'Login','Success')
    } catch (e) {
      AlertDialog.show({title:'错误',message:'登录失败'})
      hilog.error(0,'Login',JSON.stringify(e))
    }
  }
}