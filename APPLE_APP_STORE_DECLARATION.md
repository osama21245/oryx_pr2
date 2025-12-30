# What to Write to Apple - App Store Connect Privacy Declaration

## ✅ Location Data - What to Declare

Based on your app's code analysis:

### **Location Data Usage**

**Question: Do you use location data for tracking?**
**Answer: ❌ NO**

**Question: What is the purpose?**
**Answer: ✅ App Functionality Only**

---

## 📋 Step-by-Step Guide for App Store Connect

### 1. Go to App Store Connect → Your App → App Privacy

### 2. For Location Data, Declare:

#### **Data Type: Location (Approximate Location)** ⚠️ NOT Precise Location

**Questions and Answers:**

1. **"Do you or your third-party partners collect this data?"**
   - ✅ **Yes** (you collect it)

2. **"Do you use this data to track the user?"**
   - ❌ **NO** ← This is the key answer!

3. **"Do you use this data linked to the user's identity?"**
   - ✅ **Yes** (if user is logged in) OR
   - ❌ **No** (if location search works without login)

4. **"Do you use this data for third-party advertising?"**
   - ❌ **NO**

5. **"Purpose of collection":**
   - ✅ **App Functionality** ← Select this

---

## 📝 Detailed Description to Write

### **Location (Approximate Location)**

**What to write in the description field:**

```
We collect approximate location (city/area level) only when you explicitly 
use the "Use My Current Location" feature to search for properties near you. 
This location data is sent to our servers solely to provide location-based 
property search results. We do NOT use this data for:
- Tracking users across apps or websites
- Third-party advertising
- Data brokers
- Analytics or marketing purposes

The location is approximate (city/area level) to protect user privacy, and 
is only collected when you actively choose to use the location search feature.
```

### **Shorter Version (if character limit):**

```
We collect approximate location only when you use "Use My Current Location" 
to search for nearby properties. Used solely for app functionality - NOT for 
tracking, advertising, or shared with third parties.
```

---

## 🔍 Why You're NOT Tracking

Based on code analysis, your app:

✅ **Does NOT track users because:**
- Location is only sent to YOUR own API server (oryxinvestmentsegypt.com)
- Location is only collected when user explicitly taps "Use My Current Location"
- No third-party analytics/tracking SDKs found (no Google Analytics, Facebook Pixel, etc.)
- Location is approximate (city level), not precise GPS
- Used only for property search functionality
- Not shared with advertisers or data brokers
- Not used to build user profiles across apps/websites

❌ **You would be tracking IF:**
- You shared location with Facebook/Google for ads ← You don't do this
- You linked location to advertising ID across apps ← You don't do this
- You sold location data to data brokers ← You don't do this
- You used location to track user behavior across websites ← You don't do this

---

## ✅ Complete Checklist for App Store Connect

### Location (Approximate Location)

- [x] **Data Type**: Location → Approximate Location (NOT Precise)
- [x] **Do you collect?**: Yes
- [x] **Used for Tracking?**: ❌ NO ← Most Important!
- [x] **Linked to User Identity?**: Yes (if user logged in) / No (if not logged in)
- [x] **Used for Third-Party Advertising?**: ❌ NO
- [x] **Purpose**: App Functionality
- [x] **Description**: (Use the text above)

---

## 📸 Screenshot Guide

In App Store Connect, you'll see checkboxes like this:

```
Location (Approximate Location)
├── Do you collect this data?
│   └── ☑ Yes
├── Do you use this data to track the user?
│   └── ☐ NO  ← Check this!
├── Do you use this data linked to the user's identity?
│   └── ☑ Yes (or No, depending on if you require login)
├── Do you use this data for third-party advertising?
│   └── ☐ NO
└── Purpose
    └── ☑ App Functionality
```

---

## 🎯 Key Points to Remember

1. **Tracking = Following users across apps/websites for ads**
   - You're NOT doing this, so answer: **NO**

2. **App Functionality = Using data to make the app work**
   - You ARE doing this (finding properties), so answer: **YES**

3. **Approximate Location is better for privacy**
   - You're using city-level location, which is more privacy-friendly

4. **Be honest and accurate**
   - Apple reviews apps, so declare truthfully based on your actual code

---

## ⚠️ Important Notes

- **ATT (App Tracking Transparency)**: NOT required because you're not tracking
- **Precise vs Approximate**: Make sure you select "Approximate Location" not "Precise Location"
- **Description**: Keep it clear and honest about how you use the data
- **Third-Party Partners**: If you only send to your own server, you don't have third-party partners for location data

---

## 📧 If Apple Asks Questions

If Apple reviewers ask about your location usage, you can respond:

> "Our app collects approximate location (city/area level) only when users 
> explicitly tap the 'Use My Current Location' button. This location is sent 
> to our API server (oryxinvestmentsegypt.com) solely to provide location-based 
> property search results. We do not use this data for tracking, advertising, 
> or share it with third parties. The location is approximate to protect user 
> privacy and is only collected for app functionality."

---

## ✅ Summary

**What to tell Apple:**
- ✅ We collect approximate location
- ❌ We do NOT use it for tracking
- ✅ We use it for App Functionality only
- ❌ We do NOT use it for third-party advertising
- ✅ We only collect when user explicitly requests it

**You're good to go!** Your app is privacy-friendly and compliant. 🎉

