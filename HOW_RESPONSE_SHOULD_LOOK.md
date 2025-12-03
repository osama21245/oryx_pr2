# كيف يجب أن يظهر الـ Response في التطبيق

## الـ Response الصحيح (كما يجب أن يكون)

```json
{
  "message": "تم العثور على 3 محلات في محافظة قنا",
  "data": {
    "status": true,
    "data": [
      {
        "id": 142,
        "name": "محل 12 متر",
        "category_id": 6,
        "category": "محل",
        "category_image": "https://oryxinvestmentsegypt.com/storage/categories/shop.png",
        "price": 6000,
        "city": "محافظة قنا",
        "price_format": "EGP 6,000",
        "address": "محافظة قنا",
        "status": 1,
        "premium_property": 0,
        "price_duration": null,
        "property_image": "https://oryxinvestmentsegypt.com/storage/199/1000323162.jpg",
        "is_favourite": 0,
        "property_for": 5,
        "advertisement_property": null,
        "advertisement_property_date": null
      },
      {
        "id": 143,
        "name": "محل 85 متر",
        "category_id": 6,
        "category": "محل",
        "category_image": "https://oryxinvestmentsegypt.com/storage/categories/shop.png",
        "price": 25000,
        "city": "محافظة قنا",
        "price_format": "EGP 25,000",
        "address": "محافظة قنا",
        "status": 1,
        "premium_property": 0,
        "price_duration": null,
        "property_image": "https://oryxinvestmentsegypt.com/storage/200/image0.jpg",
        "is_favourite": 0,
        "property_for": 5,
        "advertisement_property": null,
        "advertisement_property_date": null
      },
      {
        "id": 164,
        "name": "محل 15 متر",
        "category_id": 6,
        "category": "محل",
        "category_image": "https://oryxinvestmentsegypt.com/storage/categories/shop.png",
        "price": 8000,
        "city": "محافظة قنا",
        "price_format": "EGP 8,000",
        "address": "محافظة قنا",
        "status": 1,
        "premium_property": 0,
        "price_duration": null,
        "property_image": "https://oryxinvestmentsegypt.com/storage/201/image1.jpg",
        "is_favourite": 0,
        "property_for": 5,
        "advertisement_property": null,
        "advertisement_property_date": null
      }
    ],
    "near_by_property": []
  }
}
```

---

## كيف يظهر في التطبيق

### 1. الرسالة (Message)
```
تم العثور على 3 محلات في محافظة قنا
```

### 2. قائمة العقارات (Properties List)

**العقار 1:**
- الاسم: محل 12 متر
- السعر: EGP 6,000
- المدينة: محافظة قنا
- الصورة: [صورة العقار]

**العقار 2:**
- الاسم: محل 85 متر
- السعر: EGP 25,000
- المدينة: محافظة قنا
- الصورة: [صورة العقار]

**العقار 3:**
- الاسم: محل 15 متر
- السعر: EGP 8,000
- المدينة: محافظة قنا
- الصورة: [صورة العقار]

---

## الـ Response الخطأ (الحالي)

```json
{
  "message": "يا صديقي، عندك مجموعة حلوة من المحلات في محافظة قنا. إليك بيانات هذه المحلات:\n\n```json\n{...JSON هنا...}\n```\n\nإذا كان لديك استفسار عن المحلات أو عقارات أخرى، أنا هنا دائماً لمساعدتك!",
  "data": {
    "status": false,
    "data": [],
    "near_by_property": []
  }
}
```

**المشكلة:**
- ❌ JSON داخل نص في `message`
- ❌ `data.data` فارغ
- ❌ لا تظهر أي عقارات في التطبيق

---

## الفرق الرئيسي

| الميزة | ❌ الخطأ | ✅ الصحيح |
|--------|---------|----------|
| `message` | JSON داخل نص | نص بسيط فقط |
| `data.status` | `false` | `true` |
| `data.data` | `[]` فارغ | `[3 عقارات]` |
| `data.near_by_property` | `[]` | `[]` |
| التطبيق | لا يظهر عقارات | يظهر 3 عقارات |

---

## الحل

يجب تحديث الـ Assistant prompt في OpenAI:

1. افتح OpenAI Assistant API
2. ابحث عن `RealEstateAssistant`
3. انسخ المحتوى من `openai_assistant_prompt.json`
4. الصق في حقل `instructions`
5. احفظ

الـ prompt المحدث يحتوي على:
- ✅ تحذيرات واضحة ضد وضع JSON داخل نص
- ✅ أمثلة على الـ response الصحيح
- ✅ أمثلة على الـ response الخطأ (ممنوع)

