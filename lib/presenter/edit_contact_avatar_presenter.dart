/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/page/edit_contact_avatar_page.dart';
import 'package:cupertinocontacts/presenter/presenter.dart';
import 'package:flutter/cupertino.dart';

class EditContactAvatarPresenter extends Presenter<EditContactAvatarPage> {
  onCancelPressed() {
    Navigator.maybePop(context);
  }

  onDonePressed() {}
}
