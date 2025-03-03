class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer une adresse e-mail';
    }
    
    // Simple regex for email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Veuillez entrer une adresse e-mail valide';
    }
    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un mot de passe';
    }
    
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un nom';
    }
    
    if (value.length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }
    
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer $fieldName';
    }
    
    return null;
  }

  static String? validatePlateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un numéro de plaque d\'immatriculation';
    }
    
    // Simple regex for plate number validation (can be customized based on country format)
    final plateRegex = RegExp(r'^[A-Z0-9-]{2,10}$');
    if (!plateRegex.hasMatch(value)) {
      return 'Veuillez entrer un numéro de plaque d\'immatriculation valide';
    }
    
    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un montant';
    }
    
    final doubleValue = double.tryParse(value.replaceAll(',', '.'));
    if (doubleValue == null) {
      return 'Veuillez entrer un montant valide';
    }
    
    if (doubleValue <= 0) {
      return 'Le montant doit être supérieur à 0';
    }
    
    return null;
  }
}
