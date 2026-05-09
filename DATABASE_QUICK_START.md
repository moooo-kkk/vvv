# 🚀 البدء السريع - قاعدة البيانات

## ⚡ 3 خطوات فقط:

### 1️⃣ شغّل الأمر على جهازك

```bash
chmod +x pull_database.sh
./pull_database.sh
```

سيقوم بـ:
- 🔍 البحث عن المحاكي
- 📱 البحث عن التطبيق
- 📥 سحب قاعدة البيانات تلقائياً
- ✅ عرض الملفات المسحوبة

### 2️⃣ حلّل البيانات

```bash
python3 analyze_database.py databases/app.db
```

ستحصل على:
- 📊 ملخص الجداول
- 📈 إحصائيات البيانات
- 💾 تصدير JSON و CSV
- 🔍 عينات من السجلات

### 3️⃣ استكشف النتائج

```bash
# فتح قاعدة البيانات يدويًا
sqlite3 databases/app.db

# بعدها اكتب:
.tables              # عرض الجداول
SELECT * FROM contacts LIMIT 10;  # عرض بيانات
```

---

## 🎯 الملفات المتاحة

```
📁 numberbook_database_backup_YYYYMMDD_HHMMSS/
│
├── 📁 databases/              # الملفات الأصلية
│   ├── app.db                 # قاعدة البيانات الرئيسية
│   ├── app.db-shm
│   └── app.db-wal
│
├── 📁 analysis_output/        # (من Python)
│   ├── contacts_data.json     # الأرقام بصيغة JSON
│   ├── contacts_data.csv      # الأرقام بصيغة CSV
│   ├── favorites_data.json    # المفضلات
│   └── database_summary.json  # الملخص
│
└── 📄 DATABASE_REPORT.txt     # (من Bash)
```

---

## 📚 الوثائق الكاملة

- **DATABASE_ACCESS_GUIDE.md** ← شرح مفصّل للأوامر
- **DATABASE_TOOLS_README.md** ← استخدام الأدوات

---

## ❓ الأسئلة الشائعة السريعة

**س: هل أحتاج root؟**  
ج: غالباً لا، ADB عادي يكفي

**س: كم الوقت المتوقع؟**  
ج: 2-5 دقائق حسب حجم البيانات

**س: هل البيانات آمنة؟**  
ج: نعم، لكن احفظها بأمان ولا تشارك

**س: ماذا لو حدث خطأ؟**  
ج: اقرأ قسم "استكشاف الأخطاء" في الأدلة

---

## 🔧 أوامر يدوية سريعة

```bash
# التحقق من المحاكي
adb devices

# البحث عن التطبيق
adb shell pm list packages | grep -i number

# السحب المباشر
adb pull /data/data/[package]/databases/ ./

# فتح قاعدة البيانات
sqlite3 app.db

# استعلام سريع
sqlite3 app.db "SELECT COUNT(*) FROM contacts;"
```

---

**جرّب الآن! 🚀**

