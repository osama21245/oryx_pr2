import '../main.dart';

const Map<String, Map<String, String>> categoryTranslations = {
  "أرض": {
    "en": "Land",
    "ru": "Земля",
  },
  "إداري": {
    "en": "Administrative",
    "ru": "Административный",
  },
  "بـرج": {
    "en": "Tower",
    "ru": "Башня",
  },
  "زراعي": {
    "en": "Agricultural",
    "ru": "Сельскохозяйственный",
  },
  "شقة": {
    "en": "Apartment",
    "ru": "Квартира",
  },
  "صناعي": {
    "en": "Industrial",
    "ru": "Промышленный",
  },
  "عمارة": {
    "en": "Building",
    "ru": "Здание",
  },
  "فيلا": {
    "en": "Villa",
    "ru": "Вилла",
  },
  "محـل": {
    "en": "Shop",
    "ru": "Вилла",
  },
  "مشترك": {
    "en": "Shared",
    "ru": "Совместное проживание",
  },
};
const Map<String, Map<String, String>> cityTranslations = {
  "مدينة الأمل": {
    "en": "Amal City",
    "ru": "Amal City",
  },
  "محافظة قنا": {
    "en": "Qena",
    "ru": "Qena",
  },
  "غرب قنا": {
    "en": "West Qena",
    "ru": "West Qena",
  },
  "قنا الجديدة": {
    "en": "New Qena",
    "ru": "New Qena",
  },
  };
const Map<String, Map<String, String>> keyword = {
  "اختياري": {
    "en": "Optional",
    "ru": "необязательный",
  },
  "الدعم الفني": {
    "en": "Application Support",
    "ru": "Поддержка приложений",
  },
  "ابلاغ": {
    "en": "Report",
    "ru": "Отчет",
  },
  "للمطور العقاري فقط": {
    "en": "For real estate developer only",
    "ru": "Только для застройщиков недвижимости",
  },
  "من فضلك ادخل محافظتك": {
    "en": "Please enter your governorate",
    "ru": "Пожалуйста, укажите вашу провинцию",
  },
  "اختر المحافظة": {
    "en": "Select the governorate",
    "ru": "Выберите провинцию",
  },
  };
String translateCategoryName(String arabicName, String langCode) {
  if (langCode == 'ar') return arabicName;

  return categoryTranslations[arabicName]?[langCode] ?? arabicName;
}
String translateCityName(String arabicName, String langCode) {
  if (langCode == 'ar') return arabicName;

  return cityTranslations[arabicName]?[langCode] ?? arabicName;
}
String translateKeywords(String arabicName, String langCode) {
  if (langCode == 'ar') return arabicName;

  return keyword[arabicName]?[langCode] ?? arabicName;
}
String getCategoryName(String name) {
  return translateCategoryName(
    name,
    appStore.selectedLanguage,
  );
}

const Map<String, Map<String, String>> governorateTranslations = {
  'القاهرة': {'en': 'Cairo', 'ru': 'Каир'},
  'الجيزة': {'en': 'Giza', 'ru': 'Гиза'},
  'الإسكندرية': {'en': 'Alexandria', 'ru': 'Александрия'},
  'الدقهلية': {'en': 'Dakahlia', 'ru': 'Дакахлия'},
  'الشرقية': {'en': 'Sharqia', 'ru': 'Шаркия'},
  'القليوبية': {'en': 'Qalyubia', 'ru': 'Кальюбия'},
  'كفر الشيخ': {'en': 'Kafr El Sheikh', 'ru': 'Кафр-эш-Шейх'},
  'الغربية': {'en': 'Gharbia', 'ru': 'Гарбия'},
  'المنوفية': {'en': 'Monufia', 'ru': 'Монуфия'},
  'البحيرة': {'en': 'Beheira', 'ru': 'Бухейра'},
  'بورسعيد': {'en': 'Port Said', 'ru': 'Порт-Саид'},
  'الإسماعيلية': {'en': 'Ismailia', 'ru': 'Исмаилия'},
  'السويس': {'en': 'Suez', 'ru': 'Суэц'},
  'دمياط': {'en': 'Damietta', 'ru': 'Думьят'},
  'الفيوم': {'en': 'Faiyum', 'ru': 'Файюм'},
  'بني سويف': {'en': 'Beni Suef', 'ru': 'Бени-Суейф'},
  'المنيا': {'en': 'Minya', 'ru': 'Минья'},
  'أسيوط': {'en': 'Asyut', 'ru': 'Асьют'},
  'سوهاج': {'en': 'Sohag', 'ru': 'Сохаг'},
  'قنا': {'en': 'Qena', 'ru': 'Кена'},
  'الأقصر': {'en': 'Luxor', 'ru': 'Луксор'},
  'أسوان': {'en': 'Aswan', 'ru': 'Асуан'},
  'البحر الأحمر': {'en': 'Red Sea', 'ru': 'Красное море'},
  'الوادي الجديد': {'en': 'New Valley', 'ru': 'Новая Долина'},
  'مطروح': {'en': 'Matrouh', 'ru': 'Матрух'},
  'شمال سيناء': {'en': 'North Sinai', 'ru': 'Северный Синай'},
  'جنوب سيناء': {'en': 'South Sinai', 'ru': 'Южный Синай'},
};

String translateGovernorateName(String arabicName, String langCode) {
  if (langCode == 'ar') return arabicName;
  return governorateTranslations[arabicName]?[langCode] ?? arabicName;
}

String getGovernorateName(String name) {
  return translateGovernorateName(
    name,
    appStore.selectedLanguage,
  );
}