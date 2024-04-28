import cloud, { Database } from '@hw-agconnect/cloud'
// @ts-ignore
import schema from  '../../resources/rawfile/schema.json'
import { t_student } from '../model/t_student'
import hilog from '@ohos.hilog'

@Entry
@Component
struct StudentPage {
  @State studentList:t_student[] =[]
  //1.声明一个database变量来接收
  private database:Database =null
  //2.初始化数据库放在aboutToAppear
  async aboutToAppear(){
    this.database=cloud.database({
      zoneName:'test',
      objectTypeInfo:schema
    })
    //collection():选择你要操作的是哪张表
    this.studentList=await this.database.collection(t_student)
      .query()
      .orderByAsc('id')//根据哪个字段进行排序
      .get()
  }


  build() {
    Column({space:26}) {
      Row() {
        Text(`编号`)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('white')
          .textAlign(TextAlign.Center)
          .width('33%')
        Text(`姓名`)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('white')
          .textAlign(TextAlign.Center)
          .width('34%')
        Text(`年龄`)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('white')
          .textAlign(TextAlign.Center)
          .width('33%')
      }
      .width('100%')
      .height(36)
      .backgroundColor('black')

      List({ space:52 }) {
        ForEach(this.studentList, (stu: t_student) => {
          ListItem() {
            Row() {
              Text(`${stu.getId()}`)
                .fontSize(18)
                .textAlign(TextAlign.Center)
                .width('33%')
              Text(stu.getName())
                .fontSize(18)
                .textAlign(TextAlign.Center)
                .width('34%')
              Text(`${stu.getAge()}`)
                .fontSize(18)
                .textAlign(TextAlign.Center)
                .width('33%')
            }
            .width('100%')
          }
        })
      }
      .width('100%')
      .height('82%')

      Divider()
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
  }
  // @State studentList:t_student[] =[]
  // //1.声明一个database变量来接收
  // private database:Database =null
  // //2.初始化数据库放在aboutToAppear
  // async aboutToAppear(){
  //   this.database=cloud.database({
  //     zoneName:'test',
  //     objectTypeInfo:schema
  //   })
  //   //collection():选择你要操作的是哪张表
  //   this.studentList=await this.database.collection(t_student)
  //     .query()
  //     .orderByAsc('id')//根据哪个字段进行排序
  //     .get()
  // }
  //
  // build() {
  //   Row() {
  //     Column({space:10}) {
  //       ForEach(this.studentList,(stu:t_student)=>{
  //         Row(){
  //           Text(`${stu.getId()}`).fontSize(18)
  //           Text(stu.getName()).fontSize(18)
  //           Text(`${stu.getAge()}`).fontSize(18)
  //         }.width('100%').justifyContent(FlexAlign.SpaceAround)
  //       })
  //     }
  //     .width('100%')
  //   }
  //   .height('100%')
  // }
}