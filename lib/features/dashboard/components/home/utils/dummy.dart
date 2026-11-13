// ignore_for_file: constant_identifier_names

class SmsMessage {
  int? id;
  String? address;
  String? body;
  int? date;
  int? dateSent;
  bool? read;
  bool? seen;
  String? subject;
  int? subscriptionId;
  int? threadId;
  String? serviceCenterAddress;
}

class SmsColumn {
  static const String ADDRESS = 'address';
  static const String BODY = 'body';
  static const String DATE = 'date';
}

class OrderBy {
  final String column;
  final Sort sort;

  OrderBy(this.column, {this.sort = Sort.ASC});
}

enum Sort { ASC, DESC }

class SmsFilter {
  static SmsFilter where(String column) {
    // Implement your filter logic here
    return SmsFilter();
  }

  SmsFilter greaterThanOrEqualTo(String value) {
    // Implement your filter logic here
    return this;
  }
}
