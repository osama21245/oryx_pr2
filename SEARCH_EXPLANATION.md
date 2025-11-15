# 🔍 How Search Works - Simple Explanation

## 📱 The Complete Flow (Step by Step)

### STEP 1: User Opens Search
**Location:** `main_screen.dart` - Line 287-329

```
User taps search box → Opens SearchScreen
```

**Code:**
```dart
AppTextField(
  readOnly: true,  // Can't type here, just opens search screen
  onTap: () async {
    bool? res = await SearchScreen(isBack: true).launch(context);
    // Opens the actual search screen
  }
)
```

---

### STEP 2: User Types in Search Screen
**Location:** `search_screen.dart` - Line 241-250

```
User types "Dubai" → Waits 500ms → Calls API
```

**What happens:**
1. User types: "D" → "Du" → "Dub" → "Dubai"
2. Each letter triggers `onChanged`
3. **Debouncer waits 500ms** (so it doesn't call API for every letter)
4. After user stops typing for 500ms → Calls `searchPropertyApi()`

**Code:**
```dart
onChanged: (v) {
  _debouncer.run(() {  // ⏱️ Waits 500ms
    mSearchValue = v;  // Saves what user typed: "Dubai"
    searchPropertyApi();  // 🔍 Calls the search API
  });
}
```

---

### STEP 3: API Call is Made
**Location:** `search_screen.dart` - Line 127-153

```
Creates request → Sends to server → Gets results
```

**Request sent to server:**
```json
{
  "search": "Dubai",
  "latitude": 0.0,
  "longitude": 0.0
}
```

**Code:**
```dart
searchPropertyApi() async {
  // 1. Create the request
  Map req = {
    "search": mSearchValue,  // "Dubai"
    "latitude": latitude,     // 0.0 or GPS coordinates
    "longitude": longitude    // 0.0 or GPS coordinates
  };
  
  // 2. Show loading spinner
  appStore.setLoading(true);
  
  // 3. Call API
  searchProperty(req).then((value) {
    // 4. Server returns results
    // value.propertyData = properties matching "Dubai"
    // value.nearByProperty = properties near "Dubai"
    
    // 5. Combine both lists
    mergePropertyData.clear();
    mergePropertyData.addAll(value.propertyData!);
    mergePropertyData.addAll(value.nearByProperty!);
    
    // 6. Save to recent searches
    userStore.addToRecentSearchList("Dubai");
    
    // 7. Update UI
    setState(() {});
  });
}
```

---

### STEP 4: Server Response
**Location:** `RestApis.dart` - Line 268-274

```
POST request to: 'search-location?per_page=100'
```

**Server returns:**
```json
{
  "status": true,
  "data": [
    { "id": 1, "name": "Dubai Marina", "price": 500000, ... },
    { "id": 2, "name": "Dubai Downtown", "price": 800000, ... }
  ],
  "near_by_property": [
    { "id": 3, "name": "Near Dubai", "price": 300000, ... }
  ]
}
```

**Code:**
```dart
Future<SearchResponse> searchProperty(Map request) async {
  return SearchResponse.fromJson(
    await buildHttpResponse(
      'search-location?per_page=100',  // API endpoint
      request: request,                 // { "search": "Dubai", ... }
      method: HttpMethod.POST
    )
  );
}
```

---

### STEP 5: Display Results
**Location:** `search_screen.dart` - Line 354-377

```
Shows list of properties found
```

**Code:**
```dart
ListView.builder(
  itemCount: mergePropertyData.length,  // Total properties found
  itemBuilder: (context, index) {
    return AdvertisementPropertyComponent(
      property: mergePropertyData[index],  // Show each property
    );
  }
)
```

---

## 🎯 Key Concepts Explained Simply

### 1. **Debouncer** (Line 85, 242)
**What it does:** Waits before searching
**Why:** If user types "Dubai" quickly, don't search for "D", "Du", "Dub", "Duba", "Dubai"
**How:** Waits 500ms after user stops typing, then searches once

```dart
_debouncer = Debouncer(milliseconds: 500);
// User types → Wait 500ms → If no more typing → Search
```

### 2. **Recent Searches** (Line 111-119, 293-353)
**What it does:** Remembers what user searched before
**Where stored:** `userStore.mRecentSearchList`
**When shown:** When search box is empty

```dart
// Save search
userStore.addToRecentSearchList("Dubai");

// Show recent searches
userStore.mRecentSearchList  // ["Dubai", "Abu Dhabi", "Sharjah"]
```

### 3. **Location Search** (Line 94-109, 280-286)
**What it does:** Search using GPS location
**How:** Gets current location → Searches nearby properties

```dart
_getCurrentLocation() {
  // Get GPS coordinates
  Position position = await Geolocator.getCurrentPosition();
  latitude = position.latitude;   // 25.2048
  longitude = position.longitude; // 55.2708
  
  // Search with location
  searchPropertyApi();  // Now includes real coordinates
}
```

### 4. **Merged Results** (Line 139-143)
**What it does:** Combines two types of results
**Why:** Shows exact matches + nearby properties

```dart
// Server returns:
// - propertyData: Exact matches for "Dubai"
// - nearByProperty: Properties near "Dubai"

// Combine them:
mergePropertyData.clear();
mergePropertyData.addAll(value.propertyData!);      // Add exact matches
mergePropertyData.addAll(value.nearByProperty!);    // Add nearby properties
```

---

## 🔄 Complete User Journey Example

```
1. User on MainScreen
   └─> Taps search box
       └─> Opens SearchScreen

2. User types "Dubai"
   └─> onChanged fires
       └─> Debouncer starts 500ms timer
           └─> User keeps typing "Dubai"
               └─> Timer resets each time
                   └─> User stops typing
                       └─> After 500ms → searchPropertyApi() called

3. API Call
   └─> Request: { "search": "Dubai", "latitude": 0.0, "longitude": 0.0 }
       └─> POST to 'search-location?per_page=100'
           └─> Server processes
               └─> Returns SearchResponse

4. Process Results
   └─> Get propertyData (exact matches)
       └─> Get nearByProperty (nearby properties)
           └─> Merge both lists
               └─> Save "Dubai" to recent searches
                   └─> Update UI (setState)

5. Display
   └─> Show ListView with all properties
       └─> User can tap property to see details
```

---

## 📝 Important Variables

| Variable | What It Stores | Example |
|----------|---------------|---------|
| `mSearchCont` | Text field controller | "Dubai" |
| `mSearchValue` | Current search text | "Dubai" |
| `mergePropertyData` | All properties found | [Property1, Property2, ...] |
| `latitude` | GPS latitude | 25.2048 or 0.0 |
| `longitude` | GPS longitude | 55.2708 or 0.0 |
| `_debouncer` | Timer for delaying search | Waits 500ms |

---

## 🎓 Quick Summary

1. **User types** → Debouncer waits 500ms
2. **API called** → Sends search text + location
3. **Server responds** → Returns matching properties
4. **Results merged** → Exact matches + nearby properties
5. **UI updated** → Shows list of properties
6. **Search saved** → Added to recent searches

That's it! 🎉

