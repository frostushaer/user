import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://xjwmobilemassage.com.au/app/api.php';

  Future<dynamic> signup({
    required String firstName,
    required String lastName,
    required String gender,
    required String countryCode,
    required String phone,
    required String email,
    required String password,
    String? refCode,
  }) async {
    return await _postRequest({
      'action': 'signup',
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
      'c_code': countryCode,
      'phone': phone,
      'email': email,
      'pssword': password,
      'ref_code': refCode ?? '',
    });
  }

  Future<dynamic> signin({
    required String email,
    required String password,
  }) async {
    return await _postRequest({
      'action': 'signin',
      'email': email,
      'pssword': password,
    });
  }

  Future<dynamic> forgetPasswordRequest(String email) async {
    return await _postRequest({
      'action': 'forget_password_request',
      'email': email,
    });
  }

  Future<dynamic> updateProfile({
    required String id,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    return await _postRequest({
      'action': 'update_profile',
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
    });
  }

  Future<dynamic> addBooking({
    required String service,
    required String practitioner,
    required String bdate,
    required String duration,
    required String timeslot,
    required String bookingFor,
    required String recipient,
    required String address,
    required String note,
    required String scharge,
    required String tfee,
    required String total,
    required String status,
    required String paymentStatus,
    required String transactionId,
    required String uid,
  }) async {
    return await _postRequest({
      'action': 'add_booking',
      'service': service,
      'practitioner': practitioner,
      'bdate': bdate,
      'duration': duration,
      'timeslot': timeslot,
      'booking_for': bookingFor,
      'recipient': recipient,
      'address': address,
      'note': note,
      'scharge': scharge,
      'tfee': tfee,
      'total': total,
      'status': status,
      'payment_status': paymentStatus,
      'transaction_id': transactionId,
      'uid': uid,
    });
  }

  Future<dynamic> getMyBookings(String uid) async {
    return await _postRequest({
      'action': 'get_mybooking_list',
      'uid': uid,
    });
  }

  Future<dynamic> _postRequest(Map<String, String> body) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: body,
      );

      return _handleResponse(response);
    } catch (error) {
      throw Exception('Failed to connect to the server: $error');
    }
  }

  Future<dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.body}');
    }
  }
}
