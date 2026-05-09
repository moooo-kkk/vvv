# تفاصيل هيكل ملف APK

## 🗂️ شجرة الملفات الكاملة

```
نمبر بوك السعودية_1.0.3.apk
│
├─── AndroidManifest.xml                  (28 KB) - ملف البيان الثنائي
│                                         [Binary XML - يحتوي على إعدادات التطبيق]
│
├─── classes.dex                          (6.7 MB) - كوبد التطبيق المترجم
│                                         [Dalvik Executable - جميع أكواد Java/Kotlin]
│
├─── resources.arsc                       (156 KB) - جدول الموارد المترجم
│                                         [Resource Archive - ربط الموارد بـ IDs]
│
├─── META-INF/                            (288 KB) - بيانات التوقيع
│    ├─── MANIFEST.MF                     - قائمة الملفات والفحوصات
│    ├─── BNDLTOOL.SF                     (35 KB) - ملف التوقيع
│    ├─── BNDLTOOL.RSA                    (2 KB) - شهادة RSA
│    ├─── services/
│    └─── com/                            - بيانات المكتبات
│         ├─── google/
│         ├─── firebase/
│         └─── androidx/
│                                         [ملفات تكوين المكتبات المدمجة]
│
├─── res/                                 (980 KB) - موارد الواجهة
│    ├─── anim/                           - رسوميات حركية
│    ├─── color/                          - ألوان المستوى الأساسي
│    ├─── color-v21/                      - ألوان Android 5.0+
│    ├─── color-v23/                      - ألوان Android 6.0+
│    ├─── drawable/                       - صور قابلة للرسم
│    ├─── drawable-v21/                   - صور محسّنة v21
│    ├─── drawable-v23/                   - صور محسّنة v23
│    ├─── drawable-watch-v20/             - صور Wear OS
│    ├─── interpolator/                   - دوال الحركة
│    ├─── layout/                         - تخطيطات XML الأساسية
│    ├─── layout-v21/                     - تخطيطات v21
│    ├─── layout-v22/                     - تخطيطات v22
│    ├─── layout-v26/                     - تخطيطات v26
│    ├─── layout-watch-v20/               - تخطيطات Wear OS
│    ├─── mipmap-anydpi-v26/              - أيقونات متجاوبة
│    ├─── mipmap-hdpi-v4/                 - أيقونات بدقة عالية
│    ├─── mipmap-mdpi-v4/                 - أيقونات بدقة متوسطة
│    └─── ... (ملافات إضافية)
│
├─── assets/                              (232 KB) - موارد إضافية
│    ├─── dexopt/                         - ملفات تحسين الأداء
│    └─── flutter_assets/                 - موارد التطبيق Flutter
│        ├─── AssetManifest.bin           - قائمة الموارد الثنائية
│        ├─── AssetManifest.json          - قائمة الموارد JSON
│        ├─── FontManifest.json           - قائمة الخطوط
│        ├─── NOTICES.Z                   - إشعارات الترخيص (مضغوط)
│        ├─── assets/
│        │   ├─── images/
│        │   │   └─── logo.png            - شعار التطبيق
│        │   └─── fonts/
│        │       └─── Tajawal-Medium.ttf  - خط عربي
│        ├─── fonts/
│        │   └─── MaterialIcons-Regular.otf
│        └─── shaders/                    - برامج تظليل الرسومات
│
├─── kotlin/                              (72 KB) - مكتبات Kotlin المدمجة
│    └─── ... (ملفات metadata Kotlin)
│
├─── DebugProbesKt.bin                    (1.7 KB)
│                                         [معلومات تصحيح Kotlin]
│
├─── kotlin-tooling-metadata.json         (4 KB)
│                                         [بيانات أدوات البناء]
│
└─── *.properties                         - ملفات خصائص المكتبات
     ├─── firebase-*.properties            (Firebase)
     ├─── play-services-*.properties       (Google Play Services)
     └─── user-messaging-platform.properties
```

---

## 📦 محتويات ملفات الخصائص (Properties)

### Firebase Properties
```
firebase-analytics.properties
├─ version: 21.5.0
└─ client: firebase-analytics

firebase-annotations.properties
├─ version: 16.2.0
└─ client: firebase-annotations

firebase-encoders.properties
├─ version: 17.0.0
└─ client: firebase-encoders

firebase-measurement-connector.properties
├─ version: 19.0.0
└─ client: firebase-measurement-connector
```

### Google Play Services Properties
```
play-services-ads.properties
play-services-ads-base.properties
play-services-ads-identifier.properties
play-services-ads-lite.properties
play-services-appset.properties
play-services-base.properties
play-services-basement.properties
play-services-measurement.properties
play-services-measurement-api.properties
play-services-measurement-base.properties
play-services-measurement-impl.properties
play-services-measurement-sdk.properties
play-services-measurement-sdk-api.properties
play-services-stats.properties
play-services-tasks.properties
```

---

## 🎨 تفاصيل Kotlin Metadata

```json
{
  "schemaVersion": "1.1.0",
  "buildSystem": "Gradle",
  "buildSystemVersion": "7.5",
  "buildPlugin": "org.jetbrains.kotlin.gradle.plugin.KotlinAndroidPluginWrapper",
  "buildPluginVersion": "1.7.10",
  "projectSettings": {
    "isHmppEnabled": true,
    "isCompatibilityMetadataVariantEnabled": false,
    "isKPMEnabled": false
  },
  "projectTargets": [
    {
      "target": "org.jetbrains.kotlin.gradle.plugin.mpp.KotlinAndroidTarget",
      "platformType": "androidJvm",
      "extras": {
        "android": {
          "sourceCompatibility": "1.8",
          "targetCompatibility": "1.8"
        }
      }
    }
  ]
}
```

---

## 📱 تفاصيل Flutter Assets

### Manifest Files

#### AssetManifest.json
قائمة بجميع موارد التطبيق التي يستخدمها Flutter

#### FontManifest.json
```json
[
  {
    "family": "MaterialIcons",
    "fonts": [
      {
        "asset": "fonts/MaterialIcons-Regular.otf"
      }
    ]
  },
  {
    "family": "Tajawal",
    "fonts": [
      {
        "asset": "assets/fonts/Tajawal-Medium.ttf"
      }
    ]
  }
]
```

### الخطوط المستخدمة

#### 1. Material Icons
- **الملف**: MaterialIcons-Regular.otf
- **الحجم**: OpenType Font
- **الاستخدام**: أيقونات واجهة المستخدم
- **المصدر**: Google Design System
- **الأيقونات الشاملة**: 5000+ أيقونة

#### 2. Tajawal-Medium
- **الملف**: Tajawal-Medium.ttf
- **النوع**: TrueType Font
- **الاستخدام**: نص واجهة المستخدم
- **الدعم**: عربي كامل
- **الميزات**:
  - خط نظيف وحديث
  - سهولة القراءة
  - دعم كامل للغة العربية
  - وزن متوسط يوازن بين الوضوح والجاذبية

### الصور والموارد
```
assets/
├─── images/
│   └─── logo.png           - شعار التطبيق الرئيسي
│                           (صيغة PNG مع شفافية)
│
└─── fonts/
    └─── Tajawal-Medium.ttf - خط Tajawal
```

### ملفات إضافية

#### NOTICES.Z
- **الحجم**: ~98 KB (مضغوط)
- **النوع**: Zlib Compressed
- **المحتوى**: إشعارات رخص المكتبات المستخدمة
  - رخص open-source
  - إشعارات من Google و Firebase
  - ملف قانوني لشروط الاستخدام

#### shaders/
- **المحتوى**: برامج تظليل رسومات (GLSL/Vulkan)
- **الاستخدام**: تأثيرات رسومية متقدمة

---

## 🔐 تفاصيل التوقيع الرقمي

### ملف MANIFEST.MF
- طول: 35 KB
- **المحتوى الرئيسي**:
  - قائمة MD5 لجميع الملفات
  - تحقق من سلامة الملفات
  - قيم Hash للتحقق من عدم التعديل

### ملف BNDLTOOL.SF
- طول: 35 KB
- **النوع**: Signature File
- **المضمون**: توقيع SHA-256 للملف MANIFEST.MF
- **الغرض**: ضمان سلامة قائمة الملفات

### ملف BNDLTOOL.RSA
- طول: 2 KB
- **النوع**: Certificate (PKCS#7)
- **الطول**: 2048-bit (محتمل)
- **الاستخدام**: توقيع رقمي باستخدام RSA
- **التحقق**: يتم التحقق من التوقيع عند تثبيت التطبيق

^---

## ⚙️ ملفات التحسين والأداء

### DebugProbesKt.bin
- **الحجم**: 1.7 KB
- **النوع**: Kotlin Debug Probes Binary
- **الغرض**: معلومات تصحيح وتتبع Kotlin
- **الاستخدام**: تحسين تجربة التصحيح

### stamp-cert-sha256
- **المحتوى**: بصمة SHA-256 للشهادة
- **الاستخدام**: التحقق من توقيع التطبيق

---

## 📊 توزيع الحجم بالنسبة المئوية

```
Kotlin Code (classes.dex)    ======= 86.2%
Resources                   ====== 12.7%
MetaData & Signature        =  3.7%
Raw Data & Properties       =  1.2%
Other Files                 <  0.5%
```

---

## 🔍 ملاحظات تقنية مهمة

### نقاط هندسية مهمة

1. **استخدام DEX واحد فقط**
   - الكود كامل في classes.dex
   - لا يوجد تقسيم DEX (لم نقترب من حد 65K method)

2. **دعم متقدم للغة العربية**
   - خط Tajawal متخصص للعربية
   - دعم RTL (Right-to-Left)
   - موارد منفصلة حسب الكثافة

3. **التكامل العميق مع Google Services**
   - Firebase بشكل شامل
   - Google Play Services
   - Ads API مدمجة

4. **تحسينات الأداء**
   - Profile Installer للتحسين
   - dexopt للتحسين الثنائي
   - Coroutines للمعالجة الفعالة

5. **دعم إصدارات Android متعددة**
   - موارد كثيفة للتوافقية
   - دعم من API 19+ (محتمل)
   - تحسينات لـ Wear OS

---

**اخر تحديث**: 9 مايو 2026
