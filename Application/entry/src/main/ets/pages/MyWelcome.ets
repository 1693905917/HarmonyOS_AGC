@Entry
@Component
struct MyWelcome {
  @State message: string = '欢迎登录成功'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}