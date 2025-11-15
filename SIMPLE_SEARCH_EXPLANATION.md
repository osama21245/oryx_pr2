# 🔍 Search Explained Simply

## Think of it like Google Search, but for Properties

### What happens when you search?

```
You type "Dubai" → App waits 0.5 seconds → Sends to server → Shows results
```

---

## 📍 Where Everything Happens

### 1. **Starting Point** - `main_screen.dart` (Line 300-313)
This is just a button that opens the search screen. You can't type here.

```dart
// This is like a button that says "Tap to search"
AppTextField(
  readOnly: true,  // ← Can't type here!
  onTap: () {
    SearchScreen().launch(context);  // ← Opens search screen
  }
)
```

---

### 2. **The Actual Search** - `search_screen.dart`

#### A. When User Types (Line 241-250)
```dart
onChanged: (v) {  // ← This runs every time user types a letter
  _debouncer.run(() {  // ← Wait 500ms before doing anything
    mSearchValue = v;  // ← Save what user typed: "Dubai"
    searchPropertyApi();  // ← Call the search function
  });
}
```

**What's a Debouncer?**
- User types: D → Du → Dub → Dubai
- Without debouncer: Would search 4 times (bad!)
- With debouncer: Waits until user stops, then searches once (good!)

---

#### B. The Search Function (Line 127-153)
This is the MAIN function that does everything:

```dart
searchPropertyApi() async {
  // STEP 1: Prepare the request
  Map req = {
    "search": mSearchValue,      // What user typed: "Dubai"
    "latitude": latitude,         // GPS location (or 0.0)
    "longitude": longitude        // GPS location (or 0.0)
  };
  
  // STEP 2: Show loading spinner
  appStore.setLoading(true);
  
  // STEP 3: Call the API (sends request to server)
  searchProperty(req).then((value) {
    
    // STEP 4: Server sent back results!
    // value.propertyData = properties matching "Dubai"
    // value.nearByProperty = properties near "Dubai"
    
    // STEP 5: Combine both lists into one
    mergePropertyData.clear();  // Clear old results
    mergePropertyData.addAll(value.propertyData!);      // Add exact matches
    mergePropertyData.addAll(value.nearByProperty!);    // Add nearby properties
    
    // STEP 6: Save "Dubai" to recent searches
    userStore.addToRecentSearchList("Dubai");
    
    // STEP 7: Hide loading, update screen
    appStore.setLoading(false);
    setState(() {});  // ← This refreshes the UI to show results
  });
}
```

---

#### C. The API Call (Line 268-274 in `RestApis.dart`)
This sends the request to the server:

```dart
Future<SearchResponse> searchProperty(Map request) async {
  // Sends POST request to: 'search-location?per_page=100'
  // With data: { "search": "Dubai", "latitude": 0.0, "longitude": 0.0 }
  // Server responds with: { "data": [...], "near_by_property": [...] }
}
```

---

#### D. Display Results (Line 354-377)
Shows the properties found:

```dart
ListView.builder(
  itemCount: mergePropertyData.length,  // How many properties found
  itemBuilder: (context, index) {
    // Show each property as a card
    return AdvertisementPropertyComponent(
      property: mergePropertyData[index]
    );
  }
)
```

---

## 🎯 Real Example

Let's say user searches for "Dubai":

1. **User types "Dubai"** in search box
   - Each letter triggers `onChanged`
   - Debouncer waits 500ms after last letter

2. **After 500ms**, `searchPropertyApi()` is called
   - Creates request: `{ "search": "Dubai", "latitude": 0.0, "longitude": 0.0 }`
   - Shows loading spinner

3. **Sends to server** via `searchProperty()` function
   - POST to: `search-location?per_page=100`
   - Server searches database for properties in Dubai

4. **Server responds** with:
   ```json
   {
     "data": [
       { "id": 1, "name": "Dubai Marina Apartment", "price": 500000 },
       { "id": 2, "name": "Dubai Downtown Villa", "price": 800000 }
     ],
     "near_by_property": [
       { "id": 3, "name": "Near Dubai Property", "price": 300000 }
     ]
   }
   ```

5. **App processes results**:
   - Clears old results
   - Adds exact matches (Dubai Marina, Dubai Downtown)
   - Adds nearby properties (Near Dubai Property)
   - Saves "Dubai" to recent searches
   - Hides loading spinner

6. **UI updates**:
   - Shows list with 3 properties
   - User can tap any property to see details

---

## 🔑 Key Variables

| Variable | What It Is | Example Value |
|----------|------------|---------------|
| `mSearchCont` | The text field | User types "Dubai" here |
| `mSearchValue` | What user typed | "Dubai" |
| `mergePropertyData` | All properties found | [Property1, Property2, Property3] |
| `_debouncer` | Timer that waits | Waits 500ms |
| `latitude` / `longitude` | GPS coordinates | 25.2048, 55.2708 (or 0.0) |

---

## 💡 Simple Summary

```
1. User types → Wait 500ms
2. Call API → Send "Dubai" to server  
3. Server finds properties → Returns list
4. Combine results → Show on screen
5. Save search → Add to recent searches
```

That's it! It's just like Google Search, but for properties. 🏠

