let myHandler = async function (event, context, callback, logger) {
  logger.info(JSON.stringify(event));

  // do something here

  const obj=JSON.parse(event.body)
  const name=obj.name
  //context存储的数据有环境变量,而context它有一个叫env(environment)对象,env就包含了当前云函数在运行时的所有的环境变量，包括它系统提供的环境变量和我们将来可以自定义的环境变量
  //假设我们自定义的环境变量叫age
  const age=context.env.age

  callback({
    code: 200,
    message: `Hello ${name},age=${age}`
  });
};

export { myHandler };

