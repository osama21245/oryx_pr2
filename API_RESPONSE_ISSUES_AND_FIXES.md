# Property Detail API Response - Issues and Expected Format

## Current Issues in Your Response

### 1. **Latitude/Longitude as String "null"**
**Problem:**
```json
"latitude": "null",
"longitude": "null"
```

**Should be:**
```json
"latitude": null,
"longitude": null
```

The app expects `null` (JSON null), not the string `"null"`. This can cause parsing issues.

### 2. **Near By Place Error Handling**
**Current Response:**
```json
"near_by_place": {
  "error_message": "You must use an API key...",
  "status": "REQUEST_DENIED",
  "results": [],
  "html_attributions": []
}
```

**Expected (when successful):**
```json
"near_by_place": {
  "status": "OK",
  "results": [...],
  "html_attributions": []
}
```

**Expected (when error - optional):**
```json
"near_by_place": {
  "status": "REQUEST_DENIED",
  "error_message": "You must use an API key...",
  "results": [],
  "html_attributions": []
}
```

The app can handle errors, but ensure `results` is always an array (even if empty).

### 3. **Property Amenity Value**
**Current:** Empty array `[]` - This is **CORRECT** ✅

**When populated, should look like:**
```json
"property_amenity_value": [
  {
    "id": 1,
    "property_id": 109,
    "amenity_id": 5,
    "name": "Swimming Pool",
    "status": 1,
    "type": "checkbox",
    "value": ["Indoor Pool", "Outdoor Pool"],
    "created_at": "2025-10-13T15:11:26.000000Z",
    "updated_at": "2025-12-02T13:50:28.000000Z",
    "amenity_image": "https://..."
  }
]
```

## Complete Expected Response Structure

### Top Level Structure:
```json
{
  "status": true,                    // Optional: success indicator
  "message": "...",                  // Optional: message
  "data": { ... },                   // REQUIRED: Property details
  "property_amenity_value": [ ... ], // REQUIRED: Array (can be empty)
  "customer": { ... },               // REQUIRED: Customer info
  "near_by_place": { ... }           // REQUIRED: Nearby places (can have error)
}
```

### Key Points:

1. **All null values should be JSON `null`, not strings `"null"`**
2. **Arrays should always be arrays** (even if empty: `[]`)
3. **All required fields from the model should be present**
4. **Snake_case naming** (as per Laravel convention)

## Backend Fixes Needed

### Fix 1: Latitude/Longitude
In your Laravel backend, ensure:
```php
// Instead of:
'latitude' => $property->latitude ?? 'null',
'longitude' => $property->longitude ?? 'null',

// Use:
'latitude' => $property->latitude,
'longitude' => $property->longitude,
```

### Fix 2: Near By Place
Ensure the structure is consistent:
```php
'near_by_place' => [
    'status' => $status, // 'OK' or 'REQUEST_DENIED'
    'results' => $results ?? [],
    'html_attributions' => [],
    // Only include error_message if status is not OK
    ...($status !== 'OK' ? ['error_message' => $errorMessage] : [])
]
```

## Testing

After fixes, test with:
- Properties with null latitude/longitude
- Properties with valid coordinates
- Properties with amenities
- Properties without amenities
- Google Maps API working
- Google Maps API failing (should still return valid structure)

