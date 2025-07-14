// class authentication {
//   String httpStatus;
//   String message;
//   int code;
//   Data? data;
//   bool asyncRequest;

//   authentication({
//     required this.httpStatus,
//     required this.message,
//     required this.code,
//     required this.data,
//     required this.asyncRequest,
//   });

//   factory authentication.fromJson(Map<String, dynamic> json) {
//     return authentication(
//       httpStatus: json['httpStatus'],
//       message: json['message'],
//       code: json['code'],
//       data: json['data'] != null ? new Data.fromJson(json['data']) : null,
//       asyncRequest: json['asyncRequest'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {
//       'message': this.message,
//       'code': this.code,
//     };

//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }

//     return data;
//   }
// }

// class Data {
//   Data();

//   factory Data.fromJson(Map<String, dynamic> json) {
//     return Data();
//   }

//   Map<String, dynamic> toJson() {
//     return {};
//   }
// }
