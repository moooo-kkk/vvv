#!/usr/bin/env python3
# -*- coding: utf-8 -*-

################################################################################
#                                                                              #
#          تحليل قاعدة بيانات نمبر بوك السعودية - Python Script             #
#              Database Analysis Tool - Number Book Database                  #
#                                                                              #
################################################################################

import sqlite3
import json
import os
import sys
from pathlib import Path
from datetime import datetime
from collections import defaultdict

class DatabaseAnalyzer:
    def __init__(self, db_path):
        """تهيئة المحلل"""
        self.db_path = db_path
        self.conn = None
        self.cursor = None
        
    def connect(self):
        """الاتصال بقاعدة البيانات"""
        try:
            self.conn = sqlite3.connect(self.db_path)
            self.cursor = self.conn.cursor()
            print(f"✓ متصل بـ: {self.db_path}")
            return True
        except Exception as e:
            print(f"✗ خطأ في الاتصال: {e}")
            return False
    
    def get_tables(self):
        """الحصول على قائمة الجداول"""
        try:
            self.cursor.execute(
                "SELECT name FROM sqlite_master WHERE type='table'"
            )
            return [row[0] for row in self.cursor.fetchall()]
        except Exception as e:
            print(f"✗ خطأ: {e}")
            return []
    
    def get_table_info(self, table_name):
        """الحصول على معلومات الجدول"""
        try:
            # عدد الصفوف
            self.cursor.execute(f"SELECT COUNT(*) FROM {table_name}")
            count = self.cursor.fetchone()[0]
            
            # الأعمدة
            self.cursor.execute(f"PRAGMA table_info({table_name})")
            columns = self.cursor.fetchall()
            
            return {
                'name': table_name,
                'row_count': count,
                'columns': [col[1] for col in columns]
            }
        except Exception as e:
            print(f"✗ خطأ في {table_name}: {e}")
            return None
    
    def export_to_json(self, table_name, output_file):
        """تصدير جدول إلى JSON"""
        try:
            self.cursor.execute(f"SELECT * FROM {table_name}")
            columns = [description[0] for description in self.cursor.description]
            rows = self.cursor.fetchall()
            
            data = [dict(zip(columns, row)) for row in rows]
            
            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False, indent=2)
            
            print(f"✓ تصديرَدير: {table_name} → {output_file}")
            return True
        except Exception as e:
            print(f"✗ خطأ في التصدير: {e}")
            return False
    
    def export_to_csv(self, table_name, output_file):
        """تصدير جدول إلى CSV"""
        try:
            import csv
            self.cursor.execute(f"SELECT * FROM {table_name}")
            columns = [description[0] for description in self.cursor.description]
            rows = self.cursor.fetchall()
            
            with open(output_file, 'w', encoding='utf-8', newline='') as f:
                writer = csv.writer(f)
                writer.writerow(columns)
                writer.writerows(rows)
            
            print(f"✓ تصدير: {table_name} → {output_file}")
            return True
        except Exception as e:
            print(f"✗ خطأ في التصدير: {e}")
            return False
    
    def query_table(self, table_name, limit=10):
        """استعلام عن بيانات الجدول"""
        try:
            self.cursor.execute(f"SELECT * FROM {table_name} LIMIT {limit}")
            columns = [description[0] for description in self.cursor.description]
            rows = self.cursor.fetchall()
            
            return {
                'columns': columns,
                'rows': rows
            }
        except Exception as e:
            print(f"✗ خطأ: {e}")
            return None
    
    def generate_summary(self):
        """توليد ملخص قاعدة البيانات"""
        tables = self.get_tables()
        summary = {
            'database': self.db_path,
            'timestamp': datetime.now().isoformat(),
            'tables': []
        }
        
        for table in tables:
            info = self.get_table_info(table)
            if info:
                summary['tables'].append(info)
        
        return summary
    
    def print_summary(self):
        """طباعة الملخص"""
        print("\n" + "="*60)
        print("ملخص قاعدة البيانات")
        print("="*60 + "\n")
        
        summary = self.generate_summary()
        
        print(f"📁 الملف: {summary['database']}")
        print(f"📅 التاريخ: {summary['timestamp']}")
        print(f"📊 عدد الجداول: {len(summary['tables'])}\n")
        
        print("الجداول:")
        print("-" * 60)
        
        for table in summary['tables']:
            print(f"  📋 {table['name']}")
            print(f"     - الصفوف: {table['row_count']}")
            print(f"     - الأعمدة: {', '.join(table['columns'])}")
            print()
    
    def save_summary(self, output_file):
        """حفظ الملخص"""
        summary = self.generate_summary()
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(summary, f, ensure_ascii=False, indent=2)
        print(f"✓ تم حفظ الملخص: {output_file}")
    
    def close(self):
        """إغلاق الاتصال"""
        if self.conn:
            self.conn.close()
            print("\n✓ تم إغلاق الاتصال")


def main():
    """الدالة الرئيسية"""
    
    print("\n" + "="*60)
    print("محلل قاعدة بيانات نمبر بوك السعودية")
    print("Database Analyzer - Number Book App")
    print("="*60 + "\n")
    
    # التحقق من المدخلات
    if len(sys.argv) < 2:
        print("الاستخدام:")
        print("  python3 analyze_database.py <database_file>")
        print("\nمثال:")
        print("  python3 analyze_database.py databases_backup/databases/app.db")
        sys.exit(1)
    
    db_file = sys.argv[1]
    
    # التحقق من وجود الملف
    if not os.path.exists(db_file):
        print(f"✗ الملف غير موجود: {db_file}")
        sys.exit(1)
    
    # إنشاء محلل
    analyzer = DatabaseAnalyzer(db_file)
    
    # الاتصال
    if not analyzer.connect():
        sys.exit(1)
    
    print()
    
    # عرض ملخص
    analyzer.print_summary()
    
    # الحصول على الجداول
    tables = analyzer.get_tables()
    
    if not tables:
        print("⚠ لم يتم العثور على جداول!")
        analyzer.close()
        sys.exit(1)
    
    # إنشاء مجلد الإخراج
    output_dir = Path(db_file).parent / "analysis_output"
    output_dir.mkdir(exist_ok=True)
    
    print(f"\n📁 مجلد الإخراج: {output_dir}\n")
    
    # تصدير البيانات
    print("📥 تصدير البيانات...")
    print("-" * 60)
    
    for table in tables:
        # JSON
        json_file = output_dir / f"{table}_data.json"
        analyzer.export_to_json(table, str(json_file))
        
        # CSV
        csv_file = output_dir / f"{table}_data.csv"
        analyzer.export_to_csv(table, str(csv_file))
    
    print()
    
    # عرض عينة من البيانات
    print("📊 عينة من البيانات:")
    print("-" * 60)
    
    for table in tables:
        print(f"\n📋 جدول: {table}")
        print("." * 60)
        
        data = analyzer.query_table(table, limit=5)
        if data:
            # طباعة رؤوس الأعمدة
            print("  | ".join(f"{col:20}" for col in data['columns']))
            print("-" * 60)
            
            # طباعة البيانات
            for row in data['rows']:
                print("  | ".join(f"{str(val)[:20]:20}" for val in row))
            
            if len(data['columns']) > 1:
                print(f"\n  (عرض أول 5 صفوف من {tables.count(table)} إجمالي)")
    
    print("\n")
    
    # حفظ الملخص
    summary_file = output_dir / "database_summary.json"
    analyzer.save_summary(str(summary_file))
    
    # الملخص النهائي
    print("="*60)
    print("✅ تم التحليل بنجاح!")
    print("="*60)
    print(f"\n📁 النتائج محفوظة في: {output_dir}")
    print("\nالملفات المُنتجة:")
    
    for file in sorted(output_dir.iterdir()):
        size = file.stat().st_size / 1024  # بالـ KB
        print(f"  • {file.name:40} ({size:.1f} KB)")
    
    print("\n💡 نصيحة: استخدم برنامج مثل DB Browser for SQLite")
    print("   للاستعراض المتقدم: https://sqlitebrowser.org")
    
    # إغلاق الاتصال
    analyzer.close()
    
    print("\n")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n⚠ تم إيقاف البرنامج")
        sys.exit(1)
    except Exception as e:
        print(f"\n✗ خطأ غير متوقع: {e}")
        sys.exit(1)
