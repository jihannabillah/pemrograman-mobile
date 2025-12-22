import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/todo_model.dart';

class StorageService {
  static const String _todoKey = 'todos';

  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Future<List<Todo>> loadTodos() async {
    try {
      print('🔄 Loading todos from SharedPreferences...');
      final prefs = await SharedPreferences.getInstance();
      
      // Debug: Print semua keys yang ada
      print('🔑 All keys in SharedPreferences: ${prefs.getKeys()}');
      
      final String? todosString = prefs.getString(_todoKey);
      
      print('📖 Raw data from storage: $todosString');
      
      if (todosString == null || todosString.isEmpty) {
        print('📭 No todos found in storage');
        return [];
      }
      
      // Pastikan JSON valid
      if (todosString.trim().isEmpty) {
        print('⚠️ Empty JSON string');
        return [];
      }
      
      try {
        final List<dynamic> todosJson = jsonDecode(todosString);
        print('📊 Parsed JSON array length: ${todosJson.length}');
        
        final List<Todo> loadedTodos = [];
        
        for (int i = 0; i < todosJson.length; i++) {
          try {
            final todoJson = todosJson[i];
            if (todoJson is Map<String, dynamic>) {
              loadedTodos.add(Todo.fromJson(todoJson));
              print('✅ Loaded todo $i: ${todoJson['title']}');
            } else {
              print('⚠️ Invalid todo format at index $i: $todoJson');
            }
          } catch (e) {
            print('❌ Error parsing todo at index $i: $e');
          }
        }
        
        print('🎉 Successfully loaded ${loadedTodos.length} todos');
        return loadedTodos;
      } catch (e) {
        print('❌ JSON decode error: $e');
        print('❌ Problematic JSON string: $todosString');
        return [];
      }
    } catch (e) {
      print('❌ Error loading todos: $e');
      return [];
    }
  }

  Future<bool> saveTodos(List<Todo> todos) async {
    try {
      print('💾 Saving ${todos.length} todos to SharedPreferences...');
      final prefs = await SharedPreferences.getInstance();
      
      // Debug sebelum save
      print('🔍 Before save - Keys: ${prefs.getKeys()}');
      
      // Convert todos to JSON
      final List<Map<String, dynamic>> todosJson = 
          todos.map((todo) => todo.toJson()).toList();
      
      print('📝 JSON to save: $todosJson');
      
      // Convert to JSON string
      final String todosString = jsonEncode(todosJson);
      
      // Save to SharedPreferences
      final bool success = await prefs.setString(_todoKey, todosString);
      
      if (success) {
        print('✅ Todos saved successfully');
        
        // Immediate verification
        final String? savedString = prefs.getString(_todoKey);
        print('🔍 Immediate verification - Saved data length: ${savedString?.length}');
        print('🔍 Immediate verification - Data: $savedString');
        
        // Test reload immediately
        final testReload = await loadTodos();
        print('🔍 Test reload - Loaded ${testReload.length} todos');
        
      } else {
        print('❌ Failed to save todos');
      }
      
      return success;
    } catch (e) {
      print('❌ Error saving todos: $e');
      return false;
    }
  }

  Future<void> debugStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? todosString = prefs.getString(_todoKey);
      
      print('\n=== 🧪 DEBUG STORAGE ===');
      print('🔑 Storage Key: $_todoKey');
      print('📁 All keys: ${prefs.getKeys()}');
      print('📊 Data exists: ${todosString != null}');
      print('📏 Data length: ${todosString?.length ?? 0}');
      
      if (todosString != null) {
        print('📄 Raw data: $todosString');
        
        try {
          final List<dynamic> parsed = jsonDecode(todosString);
          print('🔄 Parsed todos count: ${parsed.length}');
          for (int i = 0; i < parsed.length; i++) {
            final todo = parsed[i];
            if (todo is Map) {
              print('   Todo $i: ${todo['title']} (ID: ${todo['id']})');
            } else {
              print('   Todo $i: INVALID FORMAT - $todo');
            }
          }
        } catch (e) {
          print('❌ JSON Parse Error: $e');
        }
      } else {
        print('📭 No data found for key: $_todoKey');
      }
      print('=== DEBUG COMPLETE ===\n');
    } catch (e) {
      print('❌ Debug storage error: $e');
    }
  }

  Future<void> clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_todoKey);
    print('🗑️ Storage cleared - Key: $_todoKey removed');
  }

  // Method untuk test storage functionality
  Future<void> testStorageFunctionality() async {
    print('\n=== 🧪 STORAGE FUNCTIONALITY TEST ===');
    
    // Test data
    final testTodos = [
      Todo(
        id: 'test-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Test Todo 1',
        createdAt: DateTime.now(),
      ),
      Todo(
        id: 'test-${DateTime.now().millisecondsSinceEpoch + 1}',
        title: 'Test Todo 2', 
        isCompleted: true,
        createdAt: DateTime.now(),
      ),
    ];
    
    print('1. Testing save...');
    final saveResult = await saveTodos(testTodos);
    print('   Save result: $saveResult');
    
    print('2. Testing immediate load...');
    final loadResult = await loadTodos();
    print('   Load result: ${loadResult.length} todos');
    
    print('3. Testing debug info...');
    await debugStorage();
    
    print('=== TEST COMPLETE ===\n');
  }
}