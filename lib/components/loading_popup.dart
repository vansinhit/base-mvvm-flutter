import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../generated/l10n.dart';
import '../resources/app_color.dart';

class LoadingPopup extends StatelessWidget {
  static const router = 'loading_popup';

  static Future show(BuildContext context) {
    return showDialog(
        context: context,
        routeSettings: RouteSettings(name: LoadingPopup.router),
        barrierDismissible: false,
        builder: (_) => LoadingPopup());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Container(
            height: 256,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: AppColor.hFFFFFF,
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SpinKitCircle(size: 70, color: AppColor.h4DC46E),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    S.of(context).message_loading,
                    style: TextStyle(color: AppColor.h434343, fontSize: 16),
                  ),
                )
              ],
            )));
  }
}
