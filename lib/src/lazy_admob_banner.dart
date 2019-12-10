import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'admob_banner_size.dart';

class LazyAdmobBanner extends StatelessWidget {

  LazyAdmobBanner({
    Key key,
    this.adUnitId,
    this.adSize = AdmobBannerSize.BANNER,
  }) : super(key: key);

  final String adUnitId;
  final AdmobBannerSize adSize;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        initialData: false,
        future: lazyLoad(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
          return Container(
            width: adSize.width.toDouble(),
            height: adSize.height.toDouble(),
            child: !snapshot.data ?  Container() : _buildLazyAdBannerWidget(context),
          );
        },
      );
  }

  Widget _buildLazyAdBannerWidget(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        key: UniqueKey(),
        viewType: 'admob_flutter/banner',
        creationParams: <String, dynamic>{
          'adUnitId': adUnitId,
          'adSize': adSize.toMap,
        },
        creationParamsCodec: StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'admob_flutter/banner',
        creationParams: <String, dynamic>{
          'adUnitId': adUnitId,
          'adSize': adSize.toMap,
        },
        creationParamsCodec: StandardMessageCodec(),
      );
    } else {
      return Text('$defaultTargetPlatform is not yet supported by the plugin');
    }
  }

  Future<bool> lazyLoad(){
    return Future.delayed(Duration(milliseconds: 1000)).then((_){
      return true;
    });
  }
  
}
