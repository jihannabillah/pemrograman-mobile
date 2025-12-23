import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/travel_provider.dart';
import '../models/travel_plan.dart';
import '../models/heritage.dart';
import '../constants.dart';

class AddEditScreen extends StatefulWidget {
  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _countryController;
  late TextEditingController _notesController;
  late TextEditingController _budgetController;
  
  late DateTime _selectedDate;
  late String _selectedStatus;
  int? _editingId;
  String? _currentImageUrl; // Tambahkan ini untuk menampung URL gambar

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(Duration(days: 30));
    _selectedStatus = 'planned';
    
    _nameController = TextEditingController();
    _countryController = TextEditingController();
    _notesController = TextEditingController();
    _budgetController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args != null && args is Map) {
        if (args['mode'] == 'edit' && args['plan'] != null) {
          final plan = args['plan'] as TravelPlan;
          
          setState(() {
            _editingId = plan.id;
            _nameController.text = plan.heritageName;
            _countryController.text = plan.heritageCountry;
            _notesController.text = plan.notes;
            _budgetController.text = plan.budget.toStringAsFixed(0);
            _selectedDate = plan.planDate;
            _selectedStatus = plan.status;
            _currentImageUrl = plan.heritageImage; // Simpan URL gambar yang sudah ada
          });
          
        } else if (args['mode'] == 'add' && args['heritage'] != null) {
          final heritage = args['heritage'] as Heritage;
          
          setState(() {
            _nameController.text = heritage.name;
            _countryController.text = heritage.country;
            _notesController.text = 'Plan to visit ${heritage.name}';
            _budgetController.text = '1000';
            _currentImageUrl = heritage.imageUrl; // Simpan URL gambar dari objek heritage
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countryController.dispose();
    _notesController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _savePlan() async {
    if (!_formKey.currentState!.validate()) return;

    final travelProvider = Provider.of<TravelProvider>(context, listen: false);
    
    // Pastikan URL gambar tidak null, gunakan placeholder jika kosong
    final String finalImage = _currentImageUrl ?? 'https://images.unsplash.com/photo-1548013146-72479768bada';

    final plan = TravelPlan(
      id: _editingId,
      heritageName: _nameController.text,
      heritageCountry: _countryController.text,
      heritageImage: finalImage, // Menggunakan URL gambar yang benar
      planDate: _selectedDate,
      notes: _notesController.text,
      status: _selectedStatus,
      budget: double.tryParse(_budgetController.text) ?? 0,
    );

    bool success;
    if (_editingId != null) {
      success = await travelProvider.updateTravelPlan(plan);
    } else {
      success = await travelProvider.addTravelPlan(plan);
    }

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_editingId != null ? 'Plan updated!' : 'Plan added!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  // ... (Tetap gunakan fungsi _selectDate, build, _buildStatusChip, dan _showDeleteDialog yang lama)
  // Saya hanya menyertakan bagian yang krusial diperbaiki di atas agar respons ringkas.
  // Pastikan Anda tidak menghapus sisa widget build-nya.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingId != null ? 'Edit Travel Plan' : 'Add Travel Plan'),
        actions: [
          if (_editingId != null)
            IconButton(icon: Icon(Icons.delete), onPressed: () => _showDeleteDialog(context)),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_nameController, 'Heritage Site', 'Enter name'),
              SizedBox(height: 20),
              _buildTextField(_countryController, 'Country', 'Enter country'),
              SizedBox(height: 20),
              _buildDatePicker(),
              SizedBox(height: 20),
              _buildStatusSelector(),
              SizedBox(height: 20),
              _buildTextField(_budgetController, 'Budget (\$)', '0', isNumber: true),
              SizedBox(height: 20),
              _buildTextField(_notesController, 'Notes', 'Extra notes...', maxLines: 3),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _savePlan,
                  child: Text('Save Plan'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, {bool isNumber = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          maxLines: maxLines,
          decoration: InputDecoration(hintText: hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          validator: (v) => v == null || v.isEmpty ? 'Required field' : null,
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(Icons.calendar_today),
            SizedBox(width: 12),
            Text(DateFormat('dd MMMM yyyy').format(_selectedDate)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSelector() {
    return Wrap(
      spacing: 8,
      children: ['planned', 'visited', 'cancelled'].map((s) => _buildStatusChip(s, Icons.check)).toList(),
    );
  }

  Widget _buildStatusChip(String status, IconData icon) {
    final isSelected = _selectedStatus == status;
    return ChoiceChip(
      label: Text(status.toUpperCase()),
      selected: isSelected,
      onSelected: (v) => setState(() => _selectedStatus = status),
    );
  }

  void _showDeleteDialog(BuildContext context) {
     // Implementasi dialog delete seperti sebelumnya
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }
}