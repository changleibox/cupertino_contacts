/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/page/contact_detail_page.dart';
import 'package:cupertinocontacts/presenter/presenter.dart';

class ContactDetailPresenter extends Presenter<ContactDetailPage> {
  final remarksInfo = MultiEditableContactInfo(name: '备注');
}
