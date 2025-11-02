import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      // Common
      'app_name': 'Rawaa App',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'confirm': 'Confirm',
      'yes': 'Yes',
      'no': 'No',

      // Authentication
      'welcome_back': 'Welcome Back',
      'login': 'Login',
      'register': 'Register',
      'registration': 'Registration',
      'name': 'Name',
      'phone_number': 'Phone Number',
      'username': 'Username',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'email': 'Email',
      'address': 'Address',

      // Registration
      'enter_your_name': 'Enter your name',
      'enter_phone_number': 'Enter phone number',
      'enter_username': 'Enter username',
      'enter_password': 'Enter password',
      'enter_address': 'Enter address',
      'send_otp': 'Send OTP',
      'verify_otp': 'Verify OTP',
      'resend': 'Resend',
      'verification_code': 'Verification Code',
      'enter_otp': 'Enter OTP code',
      'complete_registration': 'Complete Registration',

      // Location
      'current_location': 'Current Location',
      'get_location': 'Getting location...',
      'refresh_location': 'Refresh Location',
      'allow_location': 'Allow Location',
      'select_location': 'Select Location',
      'confirm_location': 'Confirm this location',

      // Dashboard
      'categories': 'Categorys',
      'products': 'Products',

      'active_projects': 'Active Projects',
      'overdue': 'Overdue',
      'pending': 'Pending',
      'meetings': 'Meetings',
      'your_projects': 'Your Projects',
      'view_all': 'View All',
      'recent_activity': 'Recent Activity',

      // Categories
      'add_new_category': 'Add New Category',
      'category_image': 'Category Image',
      'tap_to_select_image': 'Tap to select image',
      'arabic_title': 'Arabic Title',
      'french_title': 'French Title',
      'english_title': 'English Title',
      'enter_arabic_title': 'Enter Arabic title',
      'enter_french_title': 'Enter French title',
      'enter_english_title': 'Enter English title',
      'save_category': 'Save Category',
      'saving': 'Saving...',
      'category_added_successfully': 'Category added successfully',
      'category_deleted_successfully': 'Category deleted successfully',
      'confirm_deletion': 'Confirm Deletion',
      'delete_category_confirmation':
          'Are you sure you want to delete this category?',

      // Validation Messages
      'name_required': 'Name is required',
      'phone_required': 'Phone number is required',
      'username_required': 'Username is required',
      'password_required': 'Password is required',
      'address_required': 'Address is required',
      'arabic_title_required': 'Arabic title is required',
      'french_title_required': 'French title is required',
      'english_title_required': 'English title is required',
      'image_required': 'Please select an image',
      'invalid_phone': 'Invalid phone number',
      'username_min_length': 'Username must be at least 3 characters',
      'username_invalid_chars':
          'Username can only contain letters, numbers and underscores',
      'username_available': 'Username is available',
      'username_taken': 'Username is already taken',
      'phone_available': 'Phone number is available',
      'phone_taken': 'Phone number is already used',
      'verifying_username': 'Verifying username...',
      'verifying_phone': 'Verifying phone number...',

      // Account Types
      'client': 'Client',
      'supplier': 'Supplier',
      'transporter': 'Transporter',
      'choose_account_type': 'Please choose account type',
      'choose_wilaya': 'Please choose wilaya',
      'choose_commune': 'Please choose commune',

      // Errors
      'failed_to_load_categories': 'Failed to load categories',
      'failed_to_add_category': 'Failed to add category',
      'failed_to_delete_category': 'Failed to delete category',
      'failed_to_pick_image': 'Failed to pick image',
      'image_selected_successfully': 'Image selected successfully',
      'location_updated_successfully': 'Location updated successfully',
      'failed_to_open_location_picker': 'Failed to open location picker',
      'failed_to_get_location': 'Failed to get current location',
      'location_permission_required': 'Location permissions are required',
      'location_permission_denied':
          'Location permissions are permanently denied. Please enable them in settings.',

      // Navigation
      'home': 'Home',
      'features': 'Features',
      'pages': 'Pages',
      'search': 'Search',
      'settings': 'Settings',
      // parametre
      'changer_password': 'Change Password',
      'changer_langue': 'Change Language',
      'profile': 'My Profile',
      'logout': 'Logout',
      'mon_compte': 'My Count',
      // Profile
      'edit_profile': 'Edit My Profile',
      'photo_profile': 'Picture Profile  ',
      'effacer': 'Clear',
      'Valider': 'Finish',
      'nom': 'Name',

      'old_password': 'Old Password',
      'new_password': 'New Password',
    },

    'fr': {
      // Common
      'app_name': 'Application Rawaa',
      'loading': 'Chargement...',
      'error': 'Erreur',
      'success': 'Succès',
      'cancel': 'Annuler',
      'save': 'Enregistrer',
      'delete': 'Supprimer',
      'confirm': 'Confirmer',
      'yes': 'Oui',
      'no': 'Non',

      // Authentication
      'welcome_back': 'Bon Retour',
      'login': 'Connexion',
      'register': 'S\'inscrire',
      'registration': 'Inscription',
      'name': 'Nom',
      'phone_number': 'Numéro de Téléphone',
      'username': 'Nom d\'utilisateur',
      'password': 'Mot de Passe',
      'confirm_password': 'Confirmer le Mot de Passe',
      'email': 'Email',
      'address': 'Adresse',

      // Registration
      'enter_your_name': 'Entrez votre nom',
      'enter_phone_number': 'Entrez le numéro de téléphone',
      'enter_username': 'Entrez le nom d\'utilisateur',
      'enter_password': 'Entrez le mot de passe',
      'enter_address': 'Entrez l\'adresse',
      'send_otp': 'Envoyer OTP',
      'verify_otp': 'Vérifier OTP',
      'resend': 'Renvoyer',
      'verification_code': 'Code de Vérification',
      'enter_otp': 'Entrez le code OTP',
      'complete_registration': 'Terminer l\'Inscription',

      // Location
      'current_location': 'Localisation Actuelle',
      'get_location': 'Obtention de la localisation...',
      'refresh_location': 'Actualiser la Localisation',
      'allow_location': 'Autoriser la Localisation',
      'select_location': 'Sélectionner la Localisation',
      'confirm_location': 'Confirmer cette localisation',

      // Dashboard
      'categories': 'Catégories',
      'products': 'Produits',
      'active_projects': 'Projets Actifs',
      'overdue': 'En Retard',
      'pending': 'En Attente',
      'meetings': 'Réunions',
      'your_projects': 'Vos Projets',
      'view_all': 'Voir Tout',
      'recent_activity': 'Activité Récente',

      // Categories
      'add_new_category': 'Ajouter une Catégorie',
      'category_image': 'Image de la Catégorie',
      'tap_to_select_image': 'Appuyez pour sélectionner une image',
      'arabic_title': 'Titre Arabe',
      'french_title': 'Titre Français',
      'english_title': 'Titre Anglais',
      'enter_arabic_title': 'Entrez le titre arabe',
      'enter_french_title': 'Entrez le titre français',
      'enter_english_title': 'Entrez le titre anglais',
      'save_category': 'Enregistrer la Catégorie',
      'saving': 'Enregistrement...',
      'category_added_successfully': 'Catégorie ajoutée avec succès',
      'category_deleted_successfully': 'Catégorie supprimée avec succès',
      'confirm_deletion': 'Confirmer la Suppression',
      'delete_category_confirmation':
          'Êtes-vous sûr de vouloir supprimer cette catégorie?',

      // Validation Messages
      'name_required': 'Le nom est obligatoire',
      'phone_required': 'Le numéro de téléphone est obligatoire',
      'username_required': 'Le nom d\'utilisateur est obligatoire',
      'password_required': 'Le mot de passe est obligatoire',
      'address_required': 'L\'adresse est obligatoire',
      'arabic_title_required': 'Le titre arabe est obligatoire',
      'french_title_required': 'Le titre français est obligatoire',
      'english_title_required': 'Le titre anglais est obligatoire',
      'image_required': 'Veuillez sélectionner une image',
      'invalid_phone': 'Numéro de téléphone invalide',
      'username_min_length':
          'Le nom d\'utilisateur doit contenir au moins 3 caractères',
      'username_invalid_chars':
          'Le nom d\'utilisateur ne peut contenir que des lettres, chiffres et underscores',
      'username_available': 'Nom d\'utilisateur disponible',
      'username_taken': 'Nom d\'utilisateur déjà pris',
      'phone_available': 'Numéro de téléphone disponible',
      'phone_taken': 'Numéro de téléphone déjà utilisé',
      'verifying_username': 'Vérification du nom d\'utilisateur...',
      'verifying_phone': 'Vérification du numéro de téléphone...',

      // Account Types
      'client': 'Client',
      'supplier': 'Fournisseur',
      'transporter': 'Transporteur',
      'choose_account_type': 'Veuillez choisir le type de compte',
      'choose_wilaya': 'Veuillez choisir la wilaya',
      'choose_commune': 'Veuillez choisir la commune',

      // Errors
      'failed_to_load_categories': 'Échec du chargement des catégories',
      'failed_to_add_category': 'Échec de l\'ajout de la catégorie',
      'failed_to_delete_category': 'Échec de la suppression de la catégorie',
      'failed_to_pick_image': 'Échec de la sélection d\'image',
      'image_selected_successfully': 'Image sélectionnée avec succès',
      'location_updated_successfully': 'Localisation mise à jour avec succès',
      'failed_to_open_location_picker':
          'Échec de l\'ouverture du sélecteur de localisation',
      'failed_to_get_location':
          'Échec de l\'obtention de la localisation actuelle',
      'location_permission_required':
          'Les permissions de localisation sont requises',
      'location_permission_denied':
          'Les permissions de localisation sont définitivement refusées. Veuillez les activer dans les paramètres.',

      // Navigation
      'home': 'Accueil',
      'features': 'Fonctionnalités',
      'pages': 'Pages',
      'search': 'Recherche',
      'settings': 'Paramètres',
      // parametre
      'changer_password': 'Changer mot de passe',
      'changer_langue': 'Changer la langue',
      'profile': 'Mon Profile',
      'logout': 'Deconnexion',
      'mon_compte': 'Mon Compte',
      // Profile
      'edit_profile': 'Modifier Mon Profile',
      'photo_profile': 'Photo Profile',
      'effacer': 'Effacer',
      'Valider': 'Valider',
      'nom': 'Nom',
      'old_password': 'Ancien mot de passe',
      'new_password': 'Nouveau mot de passe',
    },

    'ar': {
      // Common
      'app_name': 'تطبيق رواء',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'success': 'نجح',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'delete': 'حذف',
      'confirm': 'تأكيد',
      'yes': 'نعم',
      'no': 'لا',

      // Authentication
      'welcome_back': 'مرحباً بعودتك',
      'login': 'تسجيل الدخول',
      'register': 'التسجيل',
      'registration': 'التسجيل',
      'name': 'الاسم',
      'phone_number': 'رقم الهاتف',
      'username': 'اسم المستخدم',
      'password': 'كلمة المرور',
      'confirm_password': 'تأكيد كلمة المرور',
      'email': 'البريد الإلكتروني',
      'address': 'العنوان',

      // Registration
      'enter_your_name': 'أدخل اسمك',
      'enter_phone_number': 'أدخل رقم الهاتف',
      'enter_username': 'أدخل اسم المستخدم',
      'enter_password': 'أدخل كلمة المرور',
      'enter_address': 'أدخل العنوان',
      'send_otp': 'إرسال رمز التحقق',
      'verify_otp': 'التحقق من رمز التحقق',
      'resend': 'إعادة الإرسال',
      'verification_code': 'رمز التحقق',
      'enter_otp': 'أدخل رمز التحقق',
      'complete_registration': 'إكمال التسجيل',

      // Location
      'current_location': 'الموقع الحالي',
      'get_location': 'جاري الحصول على الموقع...',
      'refresh_location': 'تحديث الموقع',
      'allow_location': 'السماح بالموقع',
      'select_location': 'اختيار الموقع',
      'confirm_location': 'تأكيد هذا الموقع',

      // Dashboard
      'categories': 'الفئات',
      'products': 'السلع',
      'active_projects': 'المشاريع النشطة',
      'overdue': 'متأخر',
      'pending': 'في الانتظار',
      'meetings': 'الاجتماعات',
      'your_projects': 'مشاريعك',
      'view_all': 'عرض الكل',
      'recent_activity': 'النشاط الأخير',

      // Categories
      'add_new_category': 'إضافة فئة جديدة',
      'category_image': 'صورة الفئة',
      'tap_to_select_image': 'اضغط لاختيار صورة',
      'arabic_title': 'العنوان العربي',
      'french_title': 'العنوان الفرنسي',
      'english_title': 'العنوان الإنجليزي',
      'enter_arabic_title': 'أدخل العنوان العربي',
      'enter_french_title': 'أدخل العنوان الفرنسي',
      'enter_english_title': 'أدخل العنوان الإنجليزي',
      'save_category': 'حفظ الفئة',
      'saving': 'جاري الحفظ...',
      'category_added_successfully': 'تم إضافة الفئة بنجاح',
      'category_deleted_successfully': 'تم حذف الفئة بنجاح',
      'confirm_deletion': 'تأكيد الحذف',
      'delete_category_confirmation': 'هل أنت متأكد من حذف هذه الفئة؟',

      // Validation Messages
      'name_required': 'الاسم مطلوب',
      'phone_required': 'رقم الهاتف مطلوب',
      'username_required': 'اسم المستخدم مطلوب',
      'password_required': 'كلمة المرور مطلوبة',
      'address_required': 'العنوان مطلوب',
      'arabic_title_required': 'العنوان العربي مطلوب',
      'french_title_required': 'العنوان الفرنسي مطلوب',
      'english_title_required': 'العنوان الإنجليزي مطلوب',
      'image_required': 'يرجى اختيار صورة',
      'invalid_phone': 'رقم هاتف غير صحيح',
      'username_min_length': 'اسم المستخدم يجب أن يحتوي على 3 أحرف على الأقل',
      'username_invalid_chars':
          'اسم المستخدم يمكن أن يحتوي فقط على أحرف وأرقام وشرطة سفلية',
      'username_available': 'اسم المستخدم متاح',
      'username_taken': 'اسم المستخدم مستخدم بالفعل',
      'phone_available': 'رقم الهاتف متاح',
      'phone_taken': 'رقم الهاتف مستخدم بالفعل',
      'verifying_username': 'جاري التحقق من اسم المستخدم...',
      'verifying_phone': 'جاري التحقق من رقم الهاتف...',

      // Account Types
      'client': 'عميل',
      'supplier': 'مورد',
      'transporter': 'ناقل',
      'choose_account_type': 'يرجى اختيار نوع الحساب',
      'choose_wilaya': 'يرجى اختيار الولاية',
      'choose_commune': 'يرجى اختيار البلدية',

      // Errors
      'failed_to_load_categories': 'فشل في تحميل الفئات',
      'failed_to_add_category': 'فشل في إضافة الفئة',
      'failed_to_delete_category': 'فشل في حذف الفئة',
      'failed_to_pick_image': 'فشل في اختيار الصورة',
      'image_selected_successfully': 'تم اختيار الصورة بنجاح',
      'location_updated_successfully': 'تم تحديث الموقع بنجاح',
      'failed_to_open_location_picker': 'فشل في فتح منتقي الموقع',
      'failed_to_get_location': 'فشل في الحصول على الموقع الحالي',
      'location_permission_required': 'أذونات الموقع مطلوبة',
      'location_permission_denied':
          'أذونات الموقع مرفوضة نهائياً. يرجى تفعيلها في الإعدادات.',

      // Navigation
      'home': 'الرئيسية',
      'features': 'الميزات',
      'pages': 'الصفحات',
      'search': 'البحث',
      'settings': 'الإعدادات',
      // parametre
      'changer_password': 'تغيير كلمة المرور',
      'changer_langue': 'تغيير اللغة',
      'profile': 'معلوملتي الشخصية',
      'logout': 'تسجيل الخروج',
      'mon_compte': 'حسابي',
      // Profile
      'edit_profile': 'تعديل المعلومات الحساب',
      'photo_profile': 'الصورة الشخصية',
      'effacer': 'مسح',
      'Valider': 'تأكيد',
      'nom': 'الاسم',
      'old_password': 'كلمة المرور الحالية',
      'new_password': 'كلمة المرور الجديدة',
    },
  };
}
