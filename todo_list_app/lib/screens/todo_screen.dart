import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import '../services/storage_service.dart';
import '../widgets/todo_card.dart';
import '../widgets/add_todo_dialog.dart';
import '../widgets/empty_state.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final StorageService _storageService = StorageService();
  List<Todo> _todos = [];
  List<Todo> _filteredTodos = [];
  TodoFilter _currentFilter = TodoFilter.all;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await _storageService.debugStorage();
      await _loadTodos();
    } catch (e) {
      print('❌ App initialization error: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadTodos() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    
    try {
      final todos = await _storageService.loadTodos();
      setState(() {
        _todos = todos;
        _applyFilter();
        _isLoading = false;
      });
      
      print('📊 Loaded ${_todos.length} todos, filtered: ${_filteredTodos.length}');
    } catch (e) {
      print('❌ Error in _loadTodos: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveTodos() async {
    try {
      final success = await _storageService.saveTodos(_todos);
      if (!success) {
        print('⚠️ Save operation may have failed');
        setState(() {
          _hasError = true;
        });
      } else {
        setState(() {
          _hasError = false; // Reset error jika save berhasil
        });
      }
    } catch (e) {
      print('❌ Error in _saveTodos: $e');
      setState(() {
        _hasError = true;
      });
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Gagal menyimpan data!'),
          backgroundColor: Colors.red.shade600,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _applyFilter() {
    setState(() {
      switch (_currentFilter) {
        case TodoFilter.all:
          _filteredTodos = List.from(_todos);
          break;
        case TodoFilter.completed:
          _filteredTodos = _todos.where((todo) => todo.isCompleted).toList();
          break;
        case TodoFilter.pending:
          _filteredTodos = _todos.where((todo) => !todo.isCompleted).toList();
          break;
      }
      
      // ✅ PERBAIKAN: Cek dulu sebelum sort
      if (_filteredTodos.isNotEmpty) {
        _filteredTodos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
    });
  }

  void _addTodo() async {
    final title = await showDialog<String>(
      context: context,
      builder: (context) => const AddTodoDialog(),
    );

    if (title != null && title.isNotEmpty) {
      final newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.trim(),
        createdAt: DateTime.now(),
      );

      setState(() {
        _todos.insert(0, newTodo);
        _applyFilter();
      });

      await _saveTodos();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Todo berhasil ditambahkan! ✅'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _editTodo(int index) async {
    // ✅ PERBAIKAN: Validasi index
    if (index < 0 || index >= _filteredTodos.length) return;
    
    final originalIndex = _todos.indexWhere((todo) => todo.id == _filteredTodos[index].id);
    if (originalIndex == -1) return;
    
    final todo = _todos[originalIndex];

    final newTitle = await showDialog<String>(
      context: context,
      builder: (context) => AddTodoDialog(
        initialTitle: todo.title,
        isEditing: true,
      ),
    );

    if (newTitle != null && newTitle.isNotEmpty) {
      setState(() {
        _todos[originalIndex] = todo.copyWith(
          title: newTitle.trim(),
          updatedAt: DateTime.now(),
        );
        _applyFilter();
      });

      await _saveTodos();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Todo berhasil diupdate! ✏️'),
          backgroundColor: Colors.blue.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _toggleTodo(int index) {
    // ✅ PERBAIKAN: Validasi index
    if (index < 0 || index >= _filteredTodos.length) return;
    
    final originalIndex = _todos.indexWhere((todo) => todo.id == _filteredTodos[index].id);
    if (originalIndex == -1) return;
    
    setState(() {
      _todos[originalIndex] = _todos[originalIndex].copyWith(
        isCompleted: !_todos[originalIndex].isCompleted,
        updatedAt: DateTime.now(),
      );
      _applyFilter();
    });
    _saveTodos();
  }

  void _deleteTodo(int index) {
    // ✅ PERBAIKAN: Validasi index
    if (index < 0 || index >= _filteredTodos.length) return;
    
    final todoToDelete = _filteredTodos[index];
    final todoTitle = todoToDelete.title;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Todo'),
        content: Text('Yakin ingin menghapus "$todoTitle"?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _todos.removeWhere((todo) => todo.id == todoToDelete.id);
                _applyFilter();
              });
              _saveTodos();
              Navigator.pop(context);
              
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Todo berhasil dihapus! 🗑️'),
                  backgroundColor: Colors.orange.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _setFilter(TodoFilter filter) {
    setState(() {
      _currentFilter = filter;
      _applyFilter();
    });
  }

  String _getStats() {
    final total = _todos.length;
    final completed = _todos.where((todo) => todo.isCompleted).length;
    final pending = total - completed;
    
    return 'Total: $total • Selesai: $completed • Belum: $pending';
  }

  void _testStorage() async {
    print('🧪 Testing storage...');
    await _storageService.debugStorage();
    
    final testTodo = Todo(
      id: 'test-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Test Todo',
      createdAt: DateTime.now(),
    );
    
    final success = await _storageService.saveTodos([testTodo]);
    print('Test save result: $success');
    
    await _loadTodos();
  }

  void _clearAllData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Semua Data'),
        content: const Text('Yakin ingin menghapus semua todo? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await _storageService.clearStorage();
              setState(() {
                _todos = [];
                _filteredTodos = [];
                _hasError = false;
              });
              Navigator.pop(context);
              
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Semua data telah dihapus!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text(
              'Hapus Semua',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'My Todo List 📝',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
        actions: [
          if (_todos.isNotEmpty) ...[
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Statistik Todo'),
                    content: Text(_getStats()),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Tutup'),
                      ),
                    ],
                  ),
                );
              },
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'debug') _testStorage();
                if (value == 'clear') _clearAllData();
                if (value == 'reload') _loadTodos();
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'debug',
                  child: Row(
                    children: [
                      Icon(Icons.bug_report, size: 20),
                      SizedBox(width: 8),
                      Text('Debug Storage'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'reload',
                  child: Row(
                    children: [
                      Icon(Icons.refresh, size: 20),
                      SizedBox(width: 8),
                      Text('Reload Data'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'clear',
                  child: Row(
                    children: [
                      Icon(Icons.delete_forever, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Hapus Semua', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat todos...'),
                ],
              ),
            )
          : _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text(
                        'Terjadi Error',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text('Gagal memuat data dari penyimpanan'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadTodos,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    if (_todos.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Filter:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: [
                                _buildFilterChip('Semua', TodoFilter.all),
                                _buildFilterChip('Selesai', TodoFilter.completed),
                                _buildFilterChip('Belum Selesai', TodoFilter.pending),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getStats(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            if (_hasError) ...[
                              const SizedBox(height: 8),
                              Text(
                                '⚠️ Ada masalah penyimpanan',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                    
                    Expanded(
                      child: _filteredTodos.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              padding: const EdgeInsets.only(bottom: 80),
                              itemCount: _filteredTodos.length,
                              itemBuilder: (context, index) {
                                return TodoCard(
                                  todo: _filteredTodos[index],
                                  index: index,
                                  onToggle: () => _toggleTodo(index),
                                  onEdit: () => _editTodo(index),
                                  onDelete: () => _deleteTodo(index),
                                );
                              },
                            ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTodo,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Todo'),
      ),
    );
  }

  Widget _buildFilterChip(String label, TodoFilter filter) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: _currentFilter == filter ? Colors.white : Colors.deepPurple,
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: _currentFilter == filter,
      onSelected: (bool selected) => _setFilter(filter),
      backgroundColor: Colors.grey.shade200,
      selectedColor: Colors.deepPurple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildEmptyState() {
    if (_todos.isEmpty) {
      return const EmptyState(
        message: 'Belum ada todo',
        icon: Icons.checklist_rounded,
        color: Colors.deepPurple,
      );
    } else {
      return const EmptyState(
        message: 'Tidak ada todo yang sesuai filter',
        icon: Icons.search_off_rounded,
        color: Colors.orange,
      );
    }
  }
}

enum TodoFilter { all, completed, pending }