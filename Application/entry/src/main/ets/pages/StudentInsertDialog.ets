import { t_student } from '../model/t_student'
import { range } from '../util/Util'
@CustomDialog
@Preview
export struct StudentInsertDialog {
  //这个是自定义对话框必须有的,将来通过这个controller我们可以控制这个对话框打开、关闭
  controller: CustomDialogController
  //获取用户的姓名
  private name: string = ''
  //获取用户的年龄
  private age: number = 18
  //将数据库与对话框进行解耦 由调用者进行传参操作
  private confirm: (name:string, age:number) => void

  build() {
    Column({ space: 15 }) {
      Row() {
        Text('姓名')
          .width('20%')
        TextInput()
          .width('80%')
          .onChange(value=>{
            this.name = value
          })
      }
      .width('80%')
      .justifyContent(FlexAlign.SpaceAround)

      Row() {
        Text('年龄')
          .width('20%')
        //TextPicker是文本选择器：也就是那个可滚动选择的组件
        //range:设置选区范围 我用了一个range函数来生成了从16岁到60岁这样一个整数数组
        //又因为range里面要的是字符串数据，所以就.map(i => String(i))
        //selected:它选中的一个初始值（索引） 16对应索引0  selected: 2 指代的是18
        TextPicker({ range: range(16, 60).map(i => String(i)), selected: 2 })
          .width('80%')
          .onChange(value=>{
            this.age = Number(value)
          })
      }
      .width('80%')

      Row() {
        Button('确定')
          .onClick(() => {
            // database.collection(t_student).upsert(学生对象)
            this.confirm(this.name, this.age)
            this.controller.close()
          })
        Button('取消')
          .onClick(() => {
            this.controller.close()
          })
          .backgroundColor(0xcccccc)
      }
      .width('80%')
      .justifyContent(FlexAlign.SpaceAround)
    }
    .justifyContent(FlexAlign.SpaceAround)
    .width('80%')
    .height('55%')
    .margin({ top: 15 })
  }
}