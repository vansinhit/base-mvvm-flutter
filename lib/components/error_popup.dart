import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../generated/l10n.dart';
import '../resources/app_color.dart';
import '../resources/app_drawable.dart';

class ErrorPopup extends StatelessWidget {
  static const router = 'error_popup';
  final String message;

  ErrorPopup(this.message);

  static void showErrorConnection(BuildContext context) async {
    final value = await Connectivity().checkConnectivity();

    if (value == null || value == ConnectivityResult.none) {
      ErrorPopup.show(context, S.of(context).message_error_lost_connect);
      return;
    }

    ErrorPopup.show(context, S.of(context).message_error_process_failed);
  }

  static Future show(BuildContext context, String message) {
    return showDialog(
        context: context,
        routeSettings: RouteSettings(name: ErrorPopup.router),
        barrierDismissible: true,
        builder: (_) => ErrorPopup(message));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: AppColor.hFFFFFF,
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                      child: Icon(Icons.close),
                      onTap: () {
                        Navigator.of(context).pop();
                      }),
                ),
                const SizedBox(height: 24),
                /*Text(S.of(context).lbl_title_error,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: AppColor.h000000)),
                const SizedBox(height: 8),*/
                Text(message ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: AppColor.h434343)),
              ],
            )));
  }
}
