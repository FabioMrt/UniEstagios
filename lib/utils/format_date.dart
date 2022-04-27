import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String? formatDate(BuildContext context, DateTime? date) => date == null
    ? ''
    : DateFormat.yMd(Localizations.localeOf(context).languageCode).format(date);

String? formatDateToText(BuildContext context, DateTime? date) => date == null
    ? ''
    : DateFormat.yMMMMd(Localizations.localeOf(context).languageCode)
        .format(date);
