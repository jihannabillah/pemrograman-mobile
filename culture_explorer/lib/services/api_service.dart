import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // REAL API CALL - memenuhi syarat Pak Nasukha
  static const String _countriesApi = "https://restcountries.com/v3.1/region/asia";
  
  // Method untuk fetch REAL data dari internet
  Future<List<dynamic>> fetchCountriesFromApi() async {
    print('📡 Fetching REAL data from: $_countriesApi');
    
    try {
      final response = await http.get(
        Uri.parse(_countriesApi),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        print('✅ API Success! Data received');
        final data = json.decode(response.body);
        
        // Log untuk debugging
        print('📊 Data sample: ${data[0]['name']['common']}');
        print('📊 Total countries: ${data.length}');
        
        return data;
      } else {
        print('❌ API Error: ${response.statusCode}');
        throw Exception('Failed to load data from API');
      }
    } on SocketException {
      print('❌ No internet connection');
      throw Exception('No Internet Connection');
    } on HttpException {
      print('❌ HTTP Error');
      throw Exception('HTTP Error');
    } on FormatException {
      print('❌ Invalid data format');
      throw Exception('Invalid data format');
    } catch (e) {
      print('❌ Unknown error: $e');
      throw Exception('Failed to load data: $e');
    }
  }
  
  // Mock data untuk heritage (untuk UI yang lebih aesthetic)
  Future<List<Map<String, dynamic>>> getMockHeritageData() async {
    // Simulasi API call delay
    await Future.delayed(Duration(milliseconds: 500));
    
    return [
      {
        "id": 1,
        "name": "Borobudur Temple",
        "country": "Indonesia",
        "description": "The world's largest Buddhist temple, built in the 9th century during the Sailendra dynasty. A UNESCO World Heritage Site.",
        "imageUrl": "https://images.unsplash.com/photo-1620549146260-938c38c31c13?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjN8fGJvcm9idWR1cnxlbnwwfHwwfHx8MA%3D%3D",
        "category": "Cultural",
        "rating": 4.8,
        "yearInscribed": 1991,
        "location": "Magelang, Central Java",
        "popular": true
      },
      {
        "id": 2,
        "name": "Taj Mahal",
        "country": "India",
        "description": "An ivory-white marble mausoleum on the right bank of the river Yamuna in Agra. Built by Mughal emperor Shah Jahan.",
        "imageUrl": "https://images.unsplash.com/photo-1564507592333-c60657eea523?w=800&auto=format&fit=crop",
        "category": "Cultural",
        "rating": 4.9,
        "yearInscribed": 1983,
        "location": "Agra, Uttar Pradesh",
        "popular": true
      },
      {
        "id": 3,
        "name": "Angkor Wat",
        "country": "Cambodia",
        "description": "The largest religious monument in the world by land area. Originally constructed as a Hindu temple dedicated to Vishnu.",
        "imageUrl": "https://images.unsplash.com/photo-1528181304800-259b08848526?w=800&auto=format&fit=crop",
        "category": "Cultural",
        "rating": 4.7,
        "yearInscribed": 1992,
        "location": "Siem Reap Province",
        "popular": true
      },
      {
        "id": 4,
        "name": "Great Wall of China",
        "country": "China",
        "description": "Series of fortifications made of stone, brick, tamped earth, wood, and other materials, generally built along an east-to-west line.",
        "imageUrl": "https://images.unsplash.com/photo-1508804185872-d7badad00f7d?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Z3JlYXQlMjB3YWxsJTIwb2YlMjBjaGluYXxlbnwwfHwwfHx8MA%3D%3D",
        "category": "Cultural",
        "rating": 4.9,
        "yearInscribed": 1987,
        "location": "Northern China",
        "popular": true
      },
      {
        "id": 5,
        "name": "Bagan Temple Complex",
        "country": "Myanmar",
        "description": "An ancient city and a UNESCO World Heritage Site located in the Mandalay Region of Myanmar.",
        "imageUrl": "https://images.unsplash.com/photo-1650708857460-94c6aa55b3c8?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjJ8fGJhZ2FuJTIwdGVtcGxlJTIwbXlhbm1hcnxlbnwwfHwwfHx8MA%3D%3D",
        "category": "Cultural",
        "rating": 4.6,
        "yearInscribed": 2019,
        "location": "Mandalay Region",
        "popular": false
      },
      {
        "id": 6,
        "name": "Mount Fuji",
        "country": "Japan",
        "description": "Japan's tallest mountain, standing at 3,776 meters. An active stratovolcano that last erupted in 1707–1708.",
        "imageUrl": "https://images.unsplash.com/photo-1528164344705-47542687000d?w=800&auto=format&fit=crop",
        "category": "Natural",
        "rating": 4.8,
        "yearInscribed": 2013,
        "location": "Chūbu region",
        "popular": true
      },
      {
        "id": 7,
        "name": "Ha Long Bay",
        "country": "Vietnam",
        "description": "A UNESCO World Heritage Site and popular travel destination in Quảng Ninh Province, Vietnam.",
        "imageUrl": "https://images.unsplash.com/photo-1528127269322-539801943592?w=800&auto=format&fit=crop",
        "category": "Natural",
        "rating": 4.7,
        "yearInscribed": 1994,
        "location": "Quảng Ninh Province",
        "popular": true
      },
      {
        "id": 8,
        "name": "Prambanan Temple",
        "country": "Indonesia",
        "description": "A 9th-century Hindu temple compound in Special Region of Yogyakarta, dedicated to the Trimūrti.",
        "imageUrl": "https://images.unsplash.com/photo-1566559631170-a462eb20c432?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8cHJhbWJhbmFufGVufDB8fDB8fHww",
        "category": "Cultural",
        "rating": 4.5,
        "yearInscribed": 1991,
        "location": "Yogyakarta",
        "popular": false
      }
    ];
  }
}