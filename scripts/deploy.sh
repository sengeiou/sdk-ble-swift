pod trunk register carter@xyo.network 'Deploy' --description='Deploy Script'
pod lib lint
pod --allow-warnings trunk push XyBleSdk.podspec
