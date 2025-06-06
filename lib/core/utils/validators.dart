// lib/core/utils/validators.dart
class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    return null;
  }

  // Phone number validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegex = RegExp(r'^[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[^\d]'), ''))) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }

    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Price validation
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }

    final price = double.tryParse(value);
    if (price == null || price < 0) {
      return 'Please enter a valid price';
    }

    return null;
  }

  // Quantity validation
  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quantity is required';
    }

    final quantity = int.tryParse(value);
    if (quantity == null || quantity < 1) {
      return 'Please enter a valid quantity';
    }

    return null;
  }

  // Address validation
  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }

    if (value.length < 10) {
      return 'Please enter a complete address';
    }

    return null;
  }

  // Rating validation
  static String? validateRating(String? value) {
    if (value == null || value.isEmpty) {
      return 'Rating is required';
    }

    final rating = int.tryParse(value);
    if (rating == null || rating < 1 || rating > 5) {
      return 'Rating must be between 1 and 5';
    }

    return null;
  }

  // Vehicle number validation
  static String? validateVehicleNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vehicle number is required';
    }

    if (value.length < 3) {
      return 'Please enter a valid vehicle number';
    }

    return null;
  }

  // Store hours validation
  static String? validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Time is required';
    }

    final timeRegex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
    if (!timeRegex.hasMatch(value)) {
      return 'Please enter time in HH:MM format';
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Credit card validation (if implementing payment)
  static String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card number is required';
    }

    final cardNumber = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cardNumber.length < 13 || cardNumber.length > 19) {
      return 'Please enter a valid card number';
    }

    return null;
  }

  // CVV validation
  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }

    if (value.length < 3 || value.length > 4) {
      return 'Please enter a valid CVV';
    }

    return null;
  }
}
