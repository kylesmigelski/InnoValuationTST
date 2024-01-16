import 'package:flutter/material.dart';

//parameters are a little weird here. But basically we've got a default for size,
//but if you want size to be something different when calling this function,
// you would have to write "size: x" where x is an int
ButtonStyle bigButtonStyle1(BuildContext context, {int size = 22}) {
  return ElevatedButton.styleFrom(
      side: BorderSide(width: 1, color: Theme
          .of(context)
          .colorScheme
          .primary),
      minimumSize: const Size(250, 40)
  );
}
