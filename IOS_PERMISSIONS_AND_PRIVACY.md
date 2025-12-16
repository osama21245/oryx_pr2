# iOS Permissions & App Store Privacy Policy Guide

## ⚡ Quick Answer

- **ATT (App Tracking Transparency)**: ❌ **NOT REQUIRED** - You don't need ATT for location permissions
- **Location Type**: ✅ **Approximate Location** (city/area level) - More privacy-friendly than precise GPS
- **ATT is only needed** if you track users across apps/websites for advertising purposes

---

## iOS Permissions (Minimum Required)

Your app currently uses the following permissions (all are already configured in `Info.plist`):

### 1. **Location (When In Use - Approximate)** ✅ Added
- **Key**: `NSLocationWhenInUseUsageDescription`
- **Purpose**: To find properties near the user's current location
- **Usage**: Only when user taps "Use My Current Location" button
- **Accuracy**: Approximate location (city/area level) - NOT precise GPS coordinates
- **Privacy Impact**: Very Low - only accessed when user explicitly requests it, uses approximate location
- **ATT Required?**: ❌ NO - App Tracking Transparency is NOT required for location permissions

### 2. **Microphone** ✅ Already Configured
- **Key**: `NSMicrophoneUsageDescription`
- **Purpose**: Voice search functionality
- **Usage**: Only when user uses voice search feature
- **Privacy Impact**: Low - only accessed during voice search

### 3. **Speech Recognition** ✅ Already Configured
- **Key**: `NSSpeechRecognitionUsageDescription`
- **Purpose**: Convert voice to text for search
- **Usage**: Only when user uses voice search feature
- **Privacy Impact**: Low - processed locally or sent to Apple's servers

### 4. **Camera** ✅ Already Configured
- **Key**: `NSCameraUsageDescription`
- **Purpose**: Capture photos for user profile picture
- **Usage**: Only when user wants to update profile picture
- **Privacy Impact**: Low - only accessed when user chooses to use it

### 5. **Photo Library** ✅ Already Configured
- **Key**: `NSPhotoLibraryUsageDescription`
- **Purpose**: Select photos for user profile picture
- **Usage**: Only when user wants to update profile picture
- **Privacy Impact**: Low - only accessed when user chooses to use it

---

## App Store Connect Privacy Policy Section

When submitting your app to the App Store, you'll need to fill out the **App Privacy** section. Here's what you should declare:

### Data Types You Collect

#### 1. **Location (Approximate Location)** ⚠️ NOT Precise Location
- **Do you collect this?**: ✅ Yes
- **Type**: Approximate Location (NOT Precise Location)
- **Purpose**: App Functionality
- **Linked to User**: ✅ Yes (if user account is linked)
- **Used for Tracking**: ❌ No
- **ATT Required?**: ❌ NO - App Tracking Transparency is separate and NOT required
- **Description**: "We collect your approximate location (city/area level) when you use the 'Use My Current Location' feature to find properties near you. We use approximate location to respect your privacy. This data is used only to provide location-based search results."

#### 2. **Audio Data (Microphone)**
- **Do you collect this?**: ✅ Yes
- **Purpose**: App Functionality
- **Linked to User**: ❌ No (processed locally/on-device)
- **Used for Tracking**: ❌ No
- **Description**: "We access your microphone only when you use voice search. Audio is processed to convert speech to text for search queries. Audio is not stored or transmitted to our servers."

#### 3. **User Content (Photos)**
- **Do you collect this?**: ✅ Yes
- **Purpose**: App Functionality
- **Linked to User**: ✅ Yes
- **Used for Tracking**: ❌ No
- **Description**: "We collect photos you upload for your profile picture. These photos are stored on our servers and associated with your account."

#### 4. **User ID / Account Information**
- **Do you collect this?**: ✅ Yes (if you have user accounts)
- **Purpose**: App Functionality, Account Management
- **Linked to User**: ✅ Yes
- **Used for Tracking**: ❌ No
- **Description**: "We collect account information to manage your user account and provide personalized features."

### Data Not Collected
- **Health & Fitness**: ❌ No
- **Financial Info**: ❌ No (unless you process payments)
- **Contact Info**: ❌ No (unless you collect email/phone)
- **Sensitive Info**: ❌ No

---

## Important: ATT (App Tracking Transparency) - NOT REQUIRED

**ATT is NOT required for location permissions!**

- **ATT (App Tracking Transparency)** is only required if you:
  - Track users across apps/websites for advertising
  - Share user data with data brokers
  - Use advertising IDs for tracking

- **Location permissions** are completely separate from ATT
- Since you're using **approximate location** (not precise GPS), it's even more privacy-friendly
- You do NOT need to implement ATT unless you're doing cross-app tracking for ads

**Your app does NOT need ATT** because:
- ✅ You're not tracking users across apps
- ✅ You're using approximate location (city/area level)
- ✅ Location is only used for property search functionality

---

## Privacy Policy URL

You'll need to provide a **Privacy Policy URL** in App Store Connect. This should be a web page that explains:

1. What data you collect
2. How you use the data
3. How you protect the data
4. User rights regarding their data
5. Contact information for privacy concerns

**Example Privacy Policy Sections to Include:**

```
1. Information We Collect
   - Location data (when you use location search)
   - Voice/audio data (for voice search - processed on-device)
   - Profile photos (when you upload them)
   - Account information (email, name, etc.)

2. How We Use Your Information
   - To provide property search functionality
   - To personalize your experience
   - To improve our services

3. Data Storage and Security
   - How you protect user data
   - Where data is stored
   - Data retention policies

4. Your Rights
   - How users can access their data
   - How users can delete their data
   - How users can opt-out of data collection

5. Contact Us
   - Email or contact form for privacy inquiries
```

---

## Quick Checklist for App Store Submission

- [x] All required permissions added to Info.plist with descriptions
- [ ] Privacy Policy URL created and accessible
- [ ] App Privacy section filled out in App Store Connect
- [ ] All data types declared accurately
- [ ] Purpose for each data type specified
- [ ] Tracking disclosure completed (if applicable)

---

## Notes

- **Minimum Permissions**: All permissions listed above are the minimum needed for your app's core features
- **Optional Permissions**: You don't need background location, contacts, or other permissions unless you add those features
- **Privacy-First**: Your app only accesses location when explicitly requested by the user, which is privacy-friendly
- **Compliance**: Make sure your privacy policy matches what you declare in App Store Connect

---

## Recommended Privacy Policy Template Locations

You can create a privacy policy page on:
- Your website (if you have one)
- GitHub Pages (free)
- Privacy policy generators (make sure to customize them)
- Your backend API documentation site

Make sure the URL is publicly accessible and doesn't require login.

