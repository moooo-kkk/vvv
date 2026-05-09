# 📱 دليل الوصول لقاعدة بيانات التطبيق

## 🎯 معلومات سريعة

- **لا تحتاج لهذا المجلد**: البيئة الحالية معزولة عن محاكي الأندرويد
- **تنفيذ الأوامر على جهازك**: شغّل الأوامر مباشرة على كمبيوترك
- **المحاكي يجب أن يكون مشغلاً**: قبل محاولة الاتصال

---

## 💻 خطوات العمل على جهازك

### الخطوة 1: التحقق من المحاكي

افتح Terminal/PowerShell على جهازك وشغّل:

```bash
adb devices
```

**يجب أن ترى**:
```
List of attached devices
emulator-5554    device
```

---

### الخطوة 2: البحث عن اسم حزمة التطبيق

```bash
# البحث عن التطبيق
adb shell pm list packages | grep -i "number\|saudi"
```

سيظهر اسم مثل:
```
package:com.numberbook
package:com.example.numberbook
```

**احفظ اسم الحزمة هذا بدقة!**

---

### الخطوة 3: سحب قاعدة البيانات

استبدل `PACKAGE_NAME` باسم الحزمة الفعلي:

```bash
# سحب مجلد قاعدة البيانات
adb pull /data/data/PACKAGE_NAME/databases/ ./

# مثال:
# adb pull /data/data/com.numberbook/databases/ ./
```

---

### الخطوة 4: فحص الملفات المسحوبة

```bash
# قائمة الملفات
ls -la databases/

# يجب أن ترى ملفات مثل:
# - app.db
# - app.db-shm
# - app.db-wal
```

---

### الخطوة 5: فتح قاعدة البيانات

#### الطريقة الأولى: عبر Terminal (قوية لكن صعبة)

```bash
sqlite3 databases/app.db
```

بعدها شغّل الأوامر التالية:

```sqlite
-- عرض الجداول
.tables

-- عرض هيكل جدول معين
.schema contacts

-- عرض البيانات
SELECT * FROM contacts LIMIT 10;

-- عد الأرقام
SELECT COUNT(*) as total FROM contacts;

-- البحث عن رقم
SELECT * FROM contacts WHERE number LIKE '%05%' LIMIT 5;

-- تصدير البيانات
.output data.csv
.mode csv
SELECT * FROM contacts;
.output stdout

-- الخروج
.quit
```

#### الطريقة الثانية: عبر برنامج GUI (سهلة)

استخدم أحد هذه البرامج:
1. **SQLite Browser** - مجاني وسهل
2. **DB Browser for SQLite** - موصى به
3. **SQLiteStudio** - احترافي

---

## 📝 البيانات المتوقعة

قاعدة البيانات قد تحتوي على جداول مثل:

### 📇 جدول الأرقام
```sql
CREATE TABLE contacts (
    id INTEGER PRIMARY KEY,
    name TEXT,
    number TEXT,
    category TEXT,
    timestamp DATETIME,
    is_favorite BOOLEAN
);
```

### 🔍 جدول سجل البحث
```sql
CREATE TABLE search_history (
    id INTEGER PRIMARY KEY,
    query TEXT,
    result_count INTEGER,
    timestamp DATETIME
);
```

### ⭐ جدول المفضلات
```sql
CREATE TABLE favorites (
    id INTEGER PRIMARY KEY,
    contact_id INTEGER,
    saved_at DATETIME
);
```

---

## 🎯 أوامر مهمة بسيطة

```bash
# 1. اسحب قاعدة البيانات
adb pull /data/data/com.yourapp/databases/app.db .

# 2. افتحها
sqlite3 app.db

# 3. عرض كل جدول
.tables

# 4. عرض البيانات من جدول
SELECT * FROM contacts;

# 5. عد عدد الأرقام
SELECT COUNT(*) FROM contacts;

# 6. ابحث عن رقم معين
SELECT * FROM contacts WHERE number = '0501234567';

# 7. اخرج
.quit
```

---

## 🔧 Script تلقائي (اختياري)

أنشئ ملف `pull_database.sh` على جهازك:

```bash
#!/bin/bash

echo "🔍 البحث عن الأجهزة..."
adb devices

echo "📦 البحث عن التطبيق..."
PACKAGE=$(adb shell pm list packages | grep -i "number\|saudi" | head -1 | sed 's/package://')

if [ -z "$PACKAGE" ]; then
    echo "❌ لم يتم العثور على التطبيق!"
    exit 1
fi

echo "✓ وجدت الحزمة: $PACKAGE"

echo "📥 جاري سحب قاعدة البيانات..."
adb pull /data/data/$PACKAGE/databases/ ./databases_backup/

echo "✅ تم السحب!"
echo "📁 الملفات في: databases_backup/"
ls -lah databases_backup/

echo "📂 فتح قاعدة البيانات..."
sqlite3 databases_backup/*db ".tables"
```

شغّل:
```bash
chmod +x pull_database.sh
./pull_database.sh
```

---

## ⚠️ استكشاف الأخطاء

### ❌ خطأ: "adb: command not found"
**الحل**:
- ثبّت Android SDK
- أو استخدم `android-studio`
- أو ثبّت `adb` مباشرة من Google

### ❌ خطأ: "no devices/emulators found"
**الحل**:
- تأكد من تشغيل المحاكي
- شغّل: `adb devices`
- يجب أن ترى البطاريق 🐧

### ❌ خطأ: "Permission denied"
**الحل**:
- قد تحتاج root
- جرب: `adb shell su`

### ❌ خطأ: "database is locked"
**الحل**:
- أغلق التطبيق على المحاكي
- حاول السحب مرة أخرى

---

## 📊 تحليل البيانات بعد السحب

بعد سحب قاعدة البيانات، يمكنك:

### 1. تصدير إلى CSV
```bash
sqlite3 app.db
.mode csv
.output contacts.csv
SELECT * FROM contacts;
.quit
```

### 2. تصدير إلى JSON (Python)
```python
import sqlite3
import json

conn = sqlite3.connect('app.db')
cursor = conn.cursor()

cursor.execute("SELECT * FROM contacts")
columns = [description[0] for description in cursor.description]
data = [dict(zip(columns, row)) for row in cursor.fetchall()]

with open('contacts.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

conn.close()
```

### 3. عرض الإحصائيات
```sql
-- عدد الأرقام الكلي
SELECT COUNT(*) as total_numbers FROM contacts;

-- عدد المفضلات
SELECT COUNT(*) as favorites FROM contacts WHERE is_favorite = 1;

-- أكثر الفئات
SELECT category, COUNT(*) as count FROM contacts GROUP BY category ORDER BY count DESC;

-- آخر أرقام تم إضافتها
SELECT * FROM contacts ORDER BY timestamp DESC LIMIT 10;
```

---

## 🎁 أدوات مفيدة

| الأداة | الرابط | الميزات |
|-------|--------|--------|
| **SQLite Browser** | https://sqlitebrowser.org | واجهة رسومية سهلة |
| **DBeaver** | https://dbeaver.io | قوية وشاملة |
| **SQLiteStudio** | https://sqlitestudio.pl | احترافية |
| **Online SQLite** | https://sqliteonline.com | بدون تثبيت |

---

## 📚 مثال عملي كامل

```bash
# 1. تحقق من المحاكي
adb devices

# 2. ابحث عن التطبيق
adb shell pm list packages | grep number

# 3. الحزمة: com.numberbook.saudi

# 4. اسحب قاعدة البيانات
adb pull /data/data/com.numberbook.saudi/databases/ ./my_database

# 5. افتح قاعدة البيانات
cd my_database
sqlite3 app.db

# 6. في sqlite3:
sqlite> .tables
sqlite> SELECT COUNT(*) FROM contacts;
sqlite> SELECT name, number FROM contacts LIMIT 10;
sqlite> .quit

# 7. تصدير البيانات
sqlite3 app.db "SELECT * FROM contacts" > contacts_export.txt
```

---

## ✅ نصائح مهمة

1. ✓ **أغلق التطبيق قبل السحب** - لتجنب تأمين الملفات
2. ✓ **احفظ نسخة احتياطية** - في حالة الحاجة
3. ✓ **لا تختبر على البيانات الأصلية** - استخدم نسخة
4. ✓ **احترم خصوصية المستخدمين** - لا تشارك البيانات
5. ✓ **فعّل VPN إن أمكن** - لحماية الاتصال

---

## 🚀 الخطوة التالية

جرّب الأوامر على جهازك واخبرني:
1. هل المحاكي يعمل؟ ✓
2. ما اسم الحزمة الدقيق؟
3. هل نجح السحب؟

وسأساعدك بالتفاصيل! 📱💾

---

**آخر تحديث**: 9 مايو 2026  
**الحالة**: جاهز للاستخدام ✅

