import cloud from '@hw-agconnect/cloud'

@Entry
@Component
struct MyIndex {
  @State message: string = ''
  @State name: string = ''

  build() {
    Row() {
      Column() {
        TextInput({placeholder:'请输入姓名'})
          .onChange(value=>{
            this.name=value
          })
        Button('调用云函数')
          .fontSize(20)
          .onClick(async()=>{
          const result= await cloud.callFunction(
              {
                name:'hello', //你要调用哪个云函数，填写云函数名称
                version: '$latest',//你要调用该云函数的哪个版本,
                //你可以直接写版本的数字，但是我们严谨点，用$latest表示我要获取该云函数的最新版本
                params:{name:this.name} //可选参数，可以传递给输入参数event
              }
           )
            this.message=result.getValue().message;
          })
        Text(this.message)
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}