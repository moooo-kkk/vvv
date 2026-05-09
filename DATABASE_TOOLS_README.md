# 🗄️ أدوات سحب وتحليل قاعدة البيانات

دليل شامل لسحب وتحليل قاعدة بيانات تطبيق نمبر بوك السعودية

---

## 📦 الملفات المتاحة

### 1. `DATABASE_ACCESS_GUIDE.md` 📚
**الدليل الشامل**
- شرح مفصل للمفاهيم
- أوامر ADB بالتفصيل
- استكشاف الأخطاء
- أمثلة عملية

### 2. `pull_database.sh` 🔧
**Script Bash تلقائي**
- سحب قاعدة البيانات تلقائياً
- البحث الذكي عن التطبيق
- عرض الملفات المسحوبة
- تحليل أولي

### 3. `analyze_database.py` 🐍
**Script Python متقدم**
- تحليل شامل للبيانات
- تصدير JSON و CSV
- إحصائيات والجداول
- عينات من البيانات

---

## 🚀 كيفية البدء السريعة

### الخطوة 1: التحضير

```bash
# تحميل الملفات
cd /path/to/numberbook
# أو انسخها من هنا

# تعطيل صلاحيات التنفيذ للـ scripts
chmod +x pull_database.sh
chmod +x analyze_database.py
```

### الخطوة 2: تشغيل المحاكي

```bash
# تأكد من تشغيل محاكي Android
# وركّب التطبيق عليه
```

### الخطوة 3: سحب البيانات

#### الطريقة الأولى - Script تلقائي (موصى به)
```bash
./pull_database.sh
```

يقوم بـ:
✓ البحث عن المحاكي  
✓ البحث عن التطبيق  
✓ سحب قاعدة البيانات  
✓ عرض الملفات  

#### الطريقة الثانية - يدوي
```bash
# تحقق من المحاكي
adb devices

# ابحث عن التطبيق
adb shell pm list packages | grep number

# اسحب قاعدة البيانات
adb pull /data/data/com.numberbook/databases/ ./

# سرد الملفات
ls -la databases/
```

### الخطوة 4: تحليل البيانات

```bash
# استخدام Python Script
python3 analyze_database.py databases/app.db

# أو يدويًا
sqlite3 databases/app.db
> .tables
> SELECT * FROM contacts LIMIT 10;
```

---

## 📊 أوامر مفيدة

### البحث والعرض

```bash
# عرض كل الجداول
sqlite3 databases/app.db ".tables"

# عرض هيكل جدول
sqlite3 databases/app.db ".schema contacts"

# عد الأرقام
sqlite3 databases/app.db "SELECT COUNT(*) FROM contacts;"

# عرض البيانات
sqlite3 databases/app.db "SELECT * FROM contacts LIMIT 10;"

# البحث عن رقم
sqlite3 databases/app.db "SELECT * FROM contacts WHERE number LIKE '05%';"
```

### التصدير

```bash
# إلى CSV
sqlite3 databases/app.db ".mode csv" ".output contacts.csv" "SELECT * FROM contacts;" ".quit"

# إلى JSON (Python)
python3 -c "
import sqlite3, json
conn = sqlite3.connect('databases/app.db')
cursor = conn.cursor()
cursor.execute('SELECT * FROM contacts')
data = [dict(zip([d[0] for d in cursor.description], row)) for row in cursor.fetchall()]
json.dump(data, open('contacts.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=2)
"
```

---

## 🎯 حالات الاستخدام

### 1️⃣ للمطورين - فهم البنية
```bash
# فحص شامل
python3 analyze_database.py databases/app.db

# سيعطيك:
# - عدد الجداول والأعمدة
# - عدد الصفوف في كل جدول
# - عينات من البيانات
# - قائمة بالملفات المُصدّرة
```

### 2️⃣ لتحليل البيانات - الإحصائيات
```bash
# استعلامات مفيدة
sqlite3 app.db <<EOF
-- إجمالي الأرقام
SELECT COUNT(*) as total FROM contacts;

-- التوزيع حسب الفئة
SELECT category, COUNT(*) FROM contacts GROUP BY category;

-- آخر إضافات
SELECT * FROM contacts ORDER BY created_at DESC LIMIT 10;
EOF
```

### 3️⃣ للنسخ الاحتياطية
```bash
# نسخة احتياطية
cp databases/app.db app_backup_$(date +%Y%m%d).db

# أو عبر ADB مباشرة
adb pull /data/data/com.numberbook/ ./backup/
```

---

## 🐛 استكشاف الأخطاء

### ❌ "adb: command not found"
```bash
# احفظ مسار ADB
export PATH="$PATH:~/Android/Sdk/platform-tools"

# أو ثبّت:
# macOS: brew install android-platform-tools
# Linux: sudo apt-get install android-tools-adb
# Windows: choco install adb
```

### ❌ "no devices/emulators found"
```bash
# تأكد من تشغيل المحاكي
# في شاشة تشغيل المحاكيات اختر "Start"

# أو أعد تشغيل ADB
adb kill-server
adb start-server
adb devices
```

### ❌ "Permission denied"
```bash
# قد تحتاج صلاحيات root
adb shell su -c "ls /data/data/com.numberbook/databases/"

# أو استخدم:
adb root
adb pull /data/data/com.numberbook/databases/ ./
```

### ❌ "database is locked"
```bash
# أغلق التطبيق على المحاكي
adb shell am force-stop com.numberbook

# حاول السحب مرة أخرى
adb pull /data/data/com.numberbook/databases/ ./
```

---

## 📁 البنية النهائية

بعد التنفيذ ستحصل على:

```
numberbook_database_backup_YYYYMMDD_HHMMSS/
├── databases/
│   ├── app.db           ← قاعدة البيانات الرئيسية
│   ├── app.db-shm       ← ملف مساعد
│   └── app.db-wal       ← ملف سجل
├── analysis_output/     ← (من Python Script)
│   ├── contacts_data.json
│   ├── contacts_data.csv
│   ├── favorites_data.json
│   ├── favorites_data.csv
│   └── database_summary.json
└── DATABASE_REPORT.txt  ← (من Bash Script)
```

---

## 🔍 أمثلة SQL مفيدة

### الاستعلامات الشائعة

```sql
-- 1. إجمالي الأرقام
SELECT COUNT(*) as total FROM contacts;

-- 2. أكثر الأرقام استخداماً
SELECT number, COUNT(*) as count FROM contacts GROUP BY number ORDER BY count DESC LIMIT 10;

-- 3. البحث عن رقم معين
SELECT * FROM contacts WHERE number = '0501234567';

-- 4. الأرقام التي تبدأ بـ 05
SELECT * FROM contacts WHERE number LIKE '05%';

-- 5. الأرقام المفضلة فقط
SELECT * FROM contacts WHERE is_favorite = 1;

-- 6. آخر تحديث
SELECT MAX(updated_at) as last_update FROM contacts;

-- 7. الإحصائيات
SELECT 
    COUNT(*) as total,
    COUNT(DISTINCT category) as categories,
    COUNT(CASE WHEN is_favorite=1 THEN 1 END) as favorites
FROM contacts;

-- 8. الدمج مع الجداول الأخرى
SELECT c.*, f.saved_at 
FROM contacts c 
LEFT JOIN favorites f ON c.id = f.contact_id;
```

---

## 🛠️ أدوات إضافية موصى بها

| الأداة | الوصف | التحميل |
|-------|-------|--------|
| **DB Browser** | واجهة رسومية سهلة | https://sqlitebrowser.org |
| **DBeaver** | متقدمة وقوية | https://dbeaver.io |
| **SQLiteStudio** | متخصصة و احترافية | https://sqlitestudio.pl |
| **Online SQLite** | بدون تثبيت | https://sqliteonline.com |

---

## 📝 ملاحظات مهمة

### الأمان والخصوصية
- ✓ قاعدة البيانات قد تحتوي على بيانات شخصية
- ✓ لا تشارك النسخ الاحتياطية علناً
- ✓ احذف النسخ بعد الاستخدام إذا لزم الأمر
- ✓ استخدم VPN عند الاتصال بـ ADB

### الصيانة
- ✓ احفظ نسخة احتياطية قبل أي تعديل
- ✓ لا تغيّر قاعدة البيانات يدويًا إلا إذا كنت متأكداً
- ✓ تحقق من الملفات قبل الحذف

---

## 🚀 الخطوات التالية

### للمطورين:
1. فهم بنية قاعدة البيانات من `analyze_database.py`
2. كتابة استعلامات مخصصة
3. تطوير أدوات تحليل إضافية

### للمستخدمين:
1. الحصول على نسخة احتياطية من البيانات
2. تصدير البيانات إلى صيغ آمنة
3. حذف البيانات القديمة بأمان

### للباحثين:
1. جمع البيانات الإحصائية
2. تحليل أنماط الاستخدام
3. كتابة التقارير

---

## 📞 الدعم والمساعدة

### أسئلة شائعة

**س: هل يمكن تعديل البيانات؟**  
ج: نعم، لكن احذر من كسر البنية

**س: كم حجم قاعدة البيانات عادة؟**  
ج: من 1-100 ميجا حسب عدد الأرقام

**س: هل البيانات مشفرة؟**  
ج: قد تكون مشفرة على جهاز مقفل

**س: هل أحتاج root؟**  
ج: نادراً، غالباً ADB عادي يكفي

---

## ✅ قائمة التحقق

قبل البدء:
- ✓ هل المحاكي مشغّل؟
- ✓ هل ADB مثبت؟
- ✓ هل التطبيق مركّب على المحاكي؟
- ✓ هل لديك مساحة كافية؟

بعد السحب:
- ✓ هل الملفات موجودة؟
- ✓ هل يمكن فتح قاعدة البيانات؟
- ✓ هل البيانات صحيحة؟

---

**آخر تحديث**: 9 مايو 2026  
**الحالة**: جاهز للاستخدام ✅

