import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../theme/index.dart';

KeyboardActionsConfig buildConfig(BuildContext context, List<FocusNode> nodes) {
  return KeyboardActionsConfig(
    nextFocus: false,
    keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
    keyboardBarColor: Colors.grey[200],
    actions: nodes.map(
      (_actNode) {
        return KeyboardActionsItem(
          focusNode: _actNode,
          toolbarButtons: [
            //button 2
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "DONE",
                    style: TextStyle(color: AppTheme.color100),
                  ),
                ),
              );
            }
          ],
        );
      },
    ).toList(),
  );
}
