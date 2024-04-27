import cloud, { Database } from '@hw-agconnect/cloud'
// @ts-ignore
import schema from  '../../resources/rawfile/schema.json'
import { t_student } from '../model/t_student'

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
    Row() {
      Column({space:10}) {
        ForEach(this.studentList,(stu:t_student)=>{
          Row(){
            Text(`${stu.getId()}`).fontSize(18)
            Text(stu.getName()).fontSize(18)
            Text(`${stu.getAge()}`).fontSize(18)
          }.width('100%').justifyContent(FlexAlign.SpaceAround)
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}