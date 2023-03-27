import 'package:flutter/material.dart';
import 'package:ins_flutter/constant/string.dart';

Future<void> showChoiceImageDialog(
  BuildContext context,
  String titleDialog,
  VoidCallback onTapGallery,
  VoidCallback onTapCamera,
) {
  final myColor = Theme.of(context);
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            titleDialog,
            style: TextStyle(
              color: myColor.primaryColor,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Divider(
                  height: 1,
                  color: myColor.primaryColor,
                ),
                ListTile(
                  onTap: onTapGallery,
                  title: const Text(
                    ConstantStrings.pickImageGallery,
                  ),
                  leading: Icon(
                    Icons.photo,
                    color: myColor.primaryColor,
                  ),
                ),
                Divider(
                  height: 1,
                  color: myColor.primaryColor,
                ),
                ListTile(
                  onTap: onTapCamera,
                  title: const Text(
                    ConstantStrings.pickImageCamera,
                  ),
                  leading: Icon(
                    Icons.camera_alt,
                    color: myColor.primaryColor,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  title: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: myColor.primaryColor,
                    ),
                    child: Text(
                      ConstantStrings.cancel,
                      style: TextStyle(
                        color: myColor.cardColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
