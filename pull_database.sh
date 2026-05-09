#!/bin/bash

################################################################################
#                                                                              #
#        سحب وتحليل قاعدة البيانات من تطبيق نمبر بوك السعودية              #
#              Database Extraction Script for Number Book App                 #
#                                                                              #
################################################################################

set -e  # الخروج عند أي خطأ

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# الدوال
print_header() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}║${NC} $1"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# البداية
clear
print_header "سحب قاعدة البيانات - نمبر بوك السعودية"

# التحقق من ADB
print_info "جاري التحقق من ADB..."
if ! command -v adb &> /dev/null; then
    print_error "ADB غير مثبت!"
    echo ""
    echo "تثبيت ADB:"
    echo "  - Windows: قم بتثبيت Android SDK"
    echo "  - Mac: brew install android-platform-tools"
    echo "  - Linux: sudo apt-get install android-tools-adb"
    exit 1
fi
print_success "ADB موجود"

echo ""

# التحقق من المحاكي
print_info "البحث عن الأجهزة المتصلة..."
echo ""
adb devices

echo ""
read -p "اضغط Enter للمتابعة..." -t 5 || true

# البحث عن التطبيق
print_info "البحث عن تطبيق نمبر بوك..."
PACKAGES=$(adb shell pm list packages | grep -iE "number|numberbook|saudi" || echo "")

if [ -z "$PACKAGES" ]; then
    print_warning "لم يتم العثور على تطبيقات مطابقة"
    print_info "البحث يدوي عن كل الحزم..."
    adb shell pm list packages
    echo ""
    read -p "أدخل اسم الحزمة كاملاً: " PACKAGE_NAME
else
    echo "$PACKAGES"
    echo ""
    read -p "أدخل اسم الحزمة (أو اضغط Enter للاختيار الأول): " PACKAGE_NAME
    
    if [ -z "$PACKAGE_NAME" ]; then
        PACKAGE_NAME=$(echo "$PACKAGES" | head -1 | sed 's/package://')
    fi
fi

# إزالة "package:" إذا كانت موجودة
PACKAGE_NAME=$(echo "$PACKAGE_NAME" | sed 's/package://')

print_success "اسم الحزمة: $PACKAGE_NAME"

echo ""

# إنشاء مجلد للحفظ
BACKUP_DIR="numberbook_database_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
print_info "إنشاء مجلد الحفظ: $BACKUP_DIR"

echo ""

# سحب قاعدة البيانات
print_header "جاري سحب قاعدة البيانات..."
echo ""

if adb pull "/data/data/$PACKAGE_NAME/databases/" "$BACKUP_DIR/databases/" 2>/dev/null; then
    print_success "تم سحب قاعدة البيانات بنجاح!"
else
    # محاولة مع sudo إذا فشل
    print_warning "محاولة مع صلاحيات أعلى..."
    adb shell "su 0 cp -r /data/data/$PACKAGE_NAME/databases/* /sdcard/" 2>/dev/null || {
        print_error "فشل سحب قاعدة البيانات!"
        echo ""
        echo "الأسباب المحتملة:"
        echo "  1. التطبيق قد يكون قيد التشغيل (أغلقه أولاً)"
        echo "  2. قد تحتاج صلاحيات root"
        echo "  3. قد لا تكون قاعدة البيانات موجودة"
        exit 1
    }
fi

echo ""

# سحب من sdcard إذا لم ينجح التحميل المباشر
if [ ! -f "$BACKUP_DIR/databases"/*.db 2>/dev/null ]; then
    print_info "محاولة السحب من sdcard..."
    adb pull "/sdcard/" "$BACKUP_DIR/" 2>/dev/null || true
fi

echo ""

# عرض الملفات المسحوبة
print_header "الملفات المسحوبة"
echo ""
ls -lah "$BACKUP_DIR/"
echo ""

if [ -d "$BACKUP_DIR/databases" ]; then
    echo "محتوى مجلد البيانات:"
    ls -lah "$BACKUP_DIR/databases/"
fi

echo ""

# البحث عن ملفات .db
DB_FILES=$(find "$BACKUP_DIR" -name "*.db" -type f 2>/dev/null || echo "")

if [ -z "$DB_FILES" ]; then
    print_error "لم يتم العثور على ملفات قاعدة بيانات!"
    exit 1
fi

echo ""
print_success "وجدت $(echo "$DB_FILES" | wc -l) ملف(ات) قاعدة بيانات"
echo ""

# عرض ملفات قاعدة البيانات
echo "ملفات قاعدة البيانات:"
echo "$DB_FILES" | while read -r file; do
    echo "  • $file"
done

echo ""
print_header "تحليل قاعدة البيانات"
echo ""

# استخراج أول ملف .db
DB_FILE=$(echo "$DB_FILES" | head -1)
print_info "فحص: $DB_FILE"
echo ""

# التحقق من أن sqlite3 موجود
if ! command -v sqlite3 &> /dev/null; then
    print_warning "sqlite3 غير مثبت، لا يمكن تحليل قاعدة البيانات"
    echo ""
    echo "لتثبيت sqlite3:"
    echo "  - Windows: choco install sqlite"
    echo "  - Mac: brew install sqlite"
    echo "  - Linux: sudo apt-get install sqlite3"
else
    # عرض الجداول
    print_info "الجداول الموجودة:"
    echo ""
    sqlite3 "$DB_FILE" ".tables" || echo "لم يتم العثور على جداول"
    
    echo ""
    print_info "معلومات قاعدة البيانات:"
    echo ""
    sqlite3 "$DB_FILE" ".schema" || echo "لم يتم الحصول على المعلومات"
fi

echo ""
print_header "النتائج"
echo ""
print_success "تم حفظ النسخة الاحتياطية في: $BACKUP_DIR"
echo ""
echo "📁 للوصول:   cd $BACKUP_DIR"
echo "📊 للفحص:    sqlite3 $DB_FILE"
echo "📥 للقراءة:  sqlite3 $DB_FILE '.tables'"
echo ""

# إنشاء ملف تقرير
REPORT_FILE="$BACKUP_DIR/DATABASE_REPORT.txt"
{
    echo "═══════════════════════════════════════════════════════════════"
    echo "تقرير سحب قاعدة البيانات"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    echo "التاريخ: $(date)"
    echo "اسم التطبيق: $PACKAGE_NAME"
    echo "مجلد الحفظ: $BACKUP_DIR"
    echo ""
    echo "───────────────────────────────────────────────────────────────"
    echo "الملفات المسحوبة:"
    echo "───────────────────────────────────────────────────────────────"
    ls -lh "$BACKUP_DIR/databases/" 2>/dev/null || echo "لم يتم السحب"
    echo ""
    
    if command -v sqlite3 &> /dev/null && [ -f "$DB_FILE" ]; then
        echo "───────────────────────────────────────────────────────────────"
        echo "الجداول:"
        echo "───────────────────────────────────────────────────────────────"
        sqlite3 "$DB_FILE" ".tables"
        echo ""
        echo "───────────────────────────────────────────────────────────────"
        echo "الإحصائيات:"
        echo "───────────────────────────────────────────────────────────────"
        sqlite3 "$DB_FILE" "SELECT name FROM sqlite_master WHERE type='table';" | while read -r table; do
            count=$(sqlite3 "$DB_FILE" "SELECT COUNT(*) FROM $table;")
            echo "  جدول $table: $count صف"
        done
    fi
} | tee "$REPORT_FILE"

echo ""
print_success "تم إنشاء ملف التقرير: $REPORT_FILE"
echo ""

# عرض الخطوات التالية
echo ""
print_header "الخطوات التالية"
echo ""
echo "1. واجهة رسومية (سهل):"
echo "   - حمّل: DB Browser for SQLite (https://sqlitebrowser.org)"
echo "   - افتح: $DB_FILE"
echo ""
echo "2. Terminal (قوي):"
echo "   - sqlite3 $DB_FILE"
echo "   - .tables (عرض الجداول)"
echo "   - SELECT * FROM [table_name];"
echo ""
echo "3. Python (متقدم):"
echo "   python3 analyze_database.py $DB_FILE"
echo ""

print_success "انتهى العمل! ✅"

################################################################################
# النهاية
################################################################################
