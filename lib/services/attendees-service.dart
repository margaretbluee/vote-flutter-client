import 'package:http/http.dart' as http;
import 'dart:convert';

class AttendeesService {
  static const String baseUrl = 'http://localhost:5000/api';

  // mark attendance as "yes"
  Future<Map<String, dynamic>> markAttendance(int userId) async {
    final url = Uri.parse('$baseUrl/attendees');

    //  request body
    final body = json.encode({
      'userId': userId,   // pass userId of the user marking attendance
      'attendance': 'yes', //set attendance to "yes"
    });

    // snd the POST request
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);  // Return the created attendee data
    } else if (response.statusCode == 400) {
      throw Exception('Attendance already marked or invalid data');
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception('Failed to mark attendance');
    }
  }

   // fetch attendees with "yes" response
  Future<List<Map<String, dynamic>>> getAttendeesByYes() async {
    final url = Uri.parse('http://localhost:5000/api/attendees/yes');

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch attendees with "yes"');
    }
  }


  Future<List<String>> fetchAttendees() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/attendees/names'));

      if (response.statusCode == 200) {

        List<dynamic> data = json.decode(response.body);
        return data.map((e) => e.toString()).toList();  // Convert to list of strings
      } else {
        throw Exception("Failed to load attendees");
      }
    } catch (e) {
      throw Exception("Failed to load attendees: $e");
    }
  }

  }