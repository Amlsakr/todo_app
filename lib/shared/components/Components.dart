
import 'package:flutter/material.dart';

Widget defaultFormField (
    {required TextEditingController controller,
      required String label,
      required IconData iconData,
      IconData? suffixIconData,
      required TextInputType type,
      VoidCallback  onSubmit(String value)?,
      VoidCallback onChange(String value)? ,
      VoidCallback? onTab,
     bool isClickable  = true,
      required String?   validate (String? value),
      bool isPassword = false,
      VoidCallback? suffixPressed

    }
    ) => TextFormField(
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(
      iconData,
    ),
    suffixIcon: IconButton(icon: Icon(suffixIconData),
      onPressed: suffixPressed,),
    border: OutlineInputBorder(),
  ),
  keyboardType: type,
  obscureText: isPassword,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  onTap: onTab,
  controller: controller,
  validator: validate ,
  enabled: isClickable,
);