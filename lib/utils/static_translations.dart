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
    "ru": "Tower",
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
