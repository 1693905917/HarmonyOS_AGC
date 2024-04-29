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
  //定义动态偏移量
  private dataOffset:number=0
  //按年龄搜索
  @State searchAge: string = ''
  //存储显示搜索框
  @State showSearch:boolean=false
  //记录起始坐标就好
  private startY: number = 0
  //获取第一条记录的索引
  private startIndex: number = 0

  //2.初始化数据库放在aboutToAppear
  async aboutToAppear(){
    this.database=cloud.database({
      zoneName:'test',
      objectTypeInfo:schema
    })
    //首次这个页面要显示的时候,就要调用一次search
    this.search('','','',this.dataOffset)
  }
  /**
   * search:通用查询方法
   */
  //offset:偏移量： 每页起始偏移位置，比如说第一页从0开始，那第二页，每页10条的话就从10开始
  //limit：每页限制只查10条
  async search(id: string, name: string, age: string, offset: number, limit: number = 10) {
    try {
      const query = this.database.collection(t_student).query()
      if (id.length > 0) {
        // equalTo相当于where id=?
        query.equalTo("id", Number(id))
      }
      if (name.length > 0) {
        //contains相当于 where name like ?
        query.contains("name", name)
      }
      if (age.length > 0) {
        // equalTo相当于where age=?
        query.equalTo("age", Number(age))
      }
      query.limit(limit, offset)
      query.orderByAsc("id")
      const list: t_student[] = await query.get()
      // this.studentList.push(...list)：查询结果放在数组里，注意，我们这回不是一次性的查询所有的学生记录了
      //而是第一次查前10条放在这个数组里,那第二次呢，查了11-20条也要加到这个数组里
      //所以它不是一个替换的动作,它不断地往这个数组里追加的动作
      this.studentList.push(...list)
      hilog.info(0, 'Student Query', `${list.map(s => s.id)}`)
    } catch (e) {
      hilog.error(0, 'Student Query', JSON.stringify(e))
    }
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
      //搜索框组件
      if(this.showSearch){
        Search()
          .searchButton("搜索")
          .onChange(value=>{
            //将用户的值获取到
            this.searchAge=value
          })
          .onSubmit(()=>{
            //根据用户给的年龄查询要重新初始化
            this.studentList=[]
            this.dataOffset=0
            this.search('','',this.searchAge,this.dataOffset)
          })
      }
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
      //List里面有一个onReachEnd事件:当你滑动到底部时就会触发onReachEnd事件
      .onReachEnd(()=>{
        //注意：在滑动时查询第n页就是这个偏移量是不一样的，所以偏移量要是动态的
        this.dataOffset+=10;
        this.search('','','',this.dataOffset)
      })
      //这里就要给List组件加一个叫做onTouch触屏事件,在onTouch触屏事件中它就会传过来一个event对象
      .onTouch(event=>{ //event存储的是触屏发生时的一些信息
        //event中哪些重要信息呢？
        //event.type它就表示我们触屏的事件类型:1.Down:表示按下去,手指已经触摸到屏幕了  2.Up:手指松开了，从屏幕离开  3.Move:当我们触摸屏幕之后滑动的过程
        //event.touches就是触点，它是一个数组,之所以是个数组是因为可以多点触控，比如一根手指，那数组里就一个元素，如果是多根手指触碰了屏幕那么数组里就会有多个元素
        switch (event.type) {
          //在按下时，记录起始坐标的Y
          case TouchType.Down:
            this.startY = event.touches[0].y
            break;
        //在滑动时，随时记录结束坐标的Y
          case TouchType.Move:
            const endY = event.touches[0].y
            //当两者距离》25就触发对应的事件
            if (endY - this.startY >= 35 && this.startIndex===0) {
              this.showSearch = true
            } else if (this.startY - endY >= 25) {
              this.showSearch = false
            }
            break;
        }
      })
      .onScrollIndex((start,end)=>{ //start:第一条记录它的索引值,end:最后一条记录它的索引值
        this.startIndex=start
      })

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