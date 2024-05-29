import 'package:flutter/material.dart';

class UI {
  static final Icon loginIcon = _defaultIcon(Icons.person_outlined);
  static final IconData passwordIconData = Icons.lock_outlined;
  static final IconData viewPassIconData = Icons.remove_red_eye_outlined;
  static final Icon refreshIcon = _defaultIcon(Icons.refresh);
  static final Icon cameraIcon = _defaultIcon(Icons.camera_alt_outlined);
  static final Icon mailIcon = _defaultIcon(Icons.mail_outline);
  static final Icon mapIcon = _defaultIcon(Icons.map);
  static final Icon cutCloudIcon = _defaultIcon(Icons.cloud_off);
  static final Icon logoutIcon = _defaultIcon(Icons.exit_to_app);
  static final Icon muralIcon = _defaultIcon(Icons.photo_outlined);
  static final Icon calendarIcon = _defaultIcon(Icons.calendar_today_outlined);
  static final Icon arrowIcon = _defaultIcon(Icons.keyboard_arrow_right);
  static final Icon arrowBackIcon = _defaultIcon(Icons.keyboard_arrow_left);
  static final Icon tableChartIcon = _defaultIcon(Icons.table_chart);
  static final Icon updateIcon = _defaultIcon(Icons.update);
  static final Icon removeIcon = _defaultIcon(Icons.remove_circle_outline);
  static final Icon alarmClockIcon = _defaultIcon(Icons.access_alarms_rounded);
  static final Icon scheduleIcon = _defaultIcon(Icons.schedule);
  static final Icon ringIcon = _defaultIcon(Icons.phonelink_ring);
  static final Icon shareLocationIcon = _defaultIcon(Icons.share_location);

  static const Color primaryBlue = Colors.blue;

  static final BorderRadius defaultTextFieldRadius =
      BorderRadius.circular(30.0);
  static final Color? lightGrey = Colors.grey[400];
  static final Color? darkGrey = Colors.grey[700];

  static Icon _defaultIcon(IconData icon) {
    return Icon(
      icon,
    );
  }

  static ButtonStyle primaryButtonStyle(BuildContext context) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).colorScheme.primary),
    );
  }

  static TextStyle primaryButtonTextStyle(BuildContext context) {
    return new TextStyle(
      color: Theme.of(context).brightness == Brightness.dark
          ? Color(0xff062e6f)
          : Colors.white,
      fontSize: 15.0,
      fontWeight: FontWeight.w700,
    );
  }

  static PreferredSizeWidget defaultAppBar(
      {String title = "", VoidCallback? action, String tooltip = ""}) {
    return AppBar(
      centerTitle: true,
      forceMaterialTransparency: true,
      title: new Text(
        title,
        style: TextStyle(),
      ),
      actions: <Widget>[
        Padding(
            padding: EdgeInsets.all(10.0),
            child: IconButton(
                icon: const Icon(Icons.refresh, color: Colors.black),
                tooltip: tooltip,
                onPressed: action))
      ],
    );
  }

  static InputDecoration textFieldOutlined(String hint, BuildContext context,
      [IconButton? suffixIcon = null]) {
    return InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        label: Text(hint),
        labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.7)),
        floatingLabelStyle: TextStyle(),
        counterText: "",
        suffixIconColor: Theme.of(context).colorScheme.outline,
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.06),
        suffixIcon: suffixIcon);
  }
}
