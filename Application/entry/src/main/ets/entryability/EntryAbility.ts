import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';
import Window from '@ohos.window';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
//第一步 引入initialize函数  从 oh-package.json5文件中的引入 "@hw-agconnect/hmcore": "^1.0.0",
import { initialize } from '@hw-agconnect/hmcore';
import buffer from '@ohos.buffer';

// @ts-ignore
import json from  '../../resources/rawfile/agconnect-services.json'

export default class EntryAbility extends UIAbility {
  onCreate() {
    try {
      initialize(this.context, json);
    } catch (e) {
      hilog.error(0x0000,'AGConnectError',JSON.stringify(e))
    }
    let AtManager = abilityAccessCtrl.createAtManager();
    AtManager.requestPermissionsFromUser(this.context, ['ohos.permission.READ_MEDIA', 'ohos.permission.MEDIA_LOCATION']).then((data) => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'request permissions from user success' + data);
    }).catch((err) => {
      hilog.error(0x0000, 'testTag', 'Failed to request permissions from user. Cause: %{public}s', JSON.stringify(err) ?? '');
    });
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: Window.WindowStage) {
    // const context = this.context
    // //第一步：利用resourceManager.getRawFileContent方法去await异步读取了agconnect-services.json文件，而读取到的结果类型是Uint8Array：二进制数组类型
    // const value = await context.resourceManager.getRawFileContent("agconnect-services.json");
    // //将结果的二进制数组类型转换成字符串类型
    // let json: string = buffer.from(value).toString("utf8");
    //this.context:传递的是UIAbility的上下文对象  json是从agconnect-services.json文件中传递进来的，所以上三行代码就是为了解析agconnect-services.json文件的配置文件信息
    //initialize(this.context, json);
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/MyLoginCustom', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
