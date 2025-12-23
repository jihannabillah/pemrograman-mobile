class Validators {
  // Required field validator
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null 
          ? '$fieldName is required'
          : 'This field is required';
    }
    return null;
  }

  // Email validator
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  // Minimum length validator
  static String? minLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.length < minLength) {
      return fieldName != null
          ? '$fieldName must be at least $minLength characters'
          : 'Must be at least $minLength characters';
    }
    return null;
  }

  // Maximum length validator
  static String? maxLength(String? value, int maxLength, {String? fieldName}) {
    if (value != null && value.length > maxLength) {
      return fieldName != null
          ? '$fieldName must not exceed $maxLength characters'
          : 'Must not exceed $maxLength characters';
    }
    return null;
  }

  // Number validator
  static String? number(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return fieldName != null
          ? '$fieldName is required'
          : 'This field is required';
    }
    
    final parsedNumber = double.tryParse(value);
    if (parsedNumber == null) {
      return 'Please enter a valid number';
    }
    
    return null;
  }

  // Positive number validator - SUDAH DIPERBAIKI
  static String? positiveNumber(String? value, {String? fieldName}) {
    // Validasi apakah number (panggil method number())
    final numberValidation = number(value, fieldName: fieldName);
    if (numberValidation != null) return numberValidation;
    
    // Parse ke double
    final parsedNumber = double.tryParse(value!);
    if (parsedNumber == null) {
      return 'Please enter a valid number';
    }
    
    // Cek apakah positif
    if (parsedNumber < 0) {
      return fieldName != null
          ? '$fieldName must be positive'
          : 'Value must be positive';
    }
    
    return null;
  }

  // Date validator (not in past)
  static String? futureDate(DateTime? date, {String? fieldName}) {
    if (date == null) {
      return fieldName != null
          ? '$fieldName is required'
          : 'Date is required';
    }
    
    final now = DateTime.now();
    if (date.isBefore(now)) {
      return fieldName != null
          ? '$fieldName cannot be in the past'
          : 'Date cannot be in the past';
    }
    
    return null;
  }

  // Password validator
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    
    return null;
  }

  // Confirm password validator
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  // URL validator
  static String? url(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }
    
    try {
      Uri.parse(value);
      return null;
    } catch (_) {
      return fieldName != null
          ? 'Please enter a valid $fieldName URL'
          : 'Please enter a valid URL';
    }
  }
}