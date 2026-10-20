-- ==========================================================
-- Predictive Maintenance Data Warehouse - DDL Script
-- ==========================================================

USE predictive_maintenance_dw;
GO

-- 1. إنشاء الـ Schemas إذا لم تكن موجودة
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
    EXEC('CREATE SCHEMA bronze');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'silver')
    EXEC('CREATE SCHEMA silver');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'audit')
    EXEC('CREATE SCHEMA audit');
GO

-- 2. جدول الـ Audit للتسجيل والتتبع (إذا لم يكن موجوداً)
IF NOT EXISTS (SELECT * FROM sys.tables t JOIN sys.schemas s ON t.schema_id = s.schema_id WHERE s.name = 'audit' AND t.name = 'load_log')
BEGIN
    CREATE TABLE audit.load_log (
        load_id BIGINT IDENTITY(1,1) PRIMARY KEY,
        batch_id UNIQUEIDENTIFIER NOT NULL,
        source_name VARCHAR(100) NOT NULL,
        target_table VARCHAR(128) NOT NULL,
        start_time DATETIME2 NOT NULL,
        end_time DATETIME2 NULL,
        rows_loaded BIGINT NULL,
        status VARCHAR(20) NOT NULL,
        message VARCHAR(2000) NULL
    );
END
GO

-- 3. جدول طبقة الفضة الموحد والنظيف (Silver Integrated Table)
DROP TABLE IF EXISTS silver.integrated_maintenance;
GO

CREATE TABLE silver.integrated_maintenance (
    record_id INT IDENTITY(1,1) PRIMARY KEY,
    source_system VARCHAR(50) NOT NULL,        -- لتحديد مصدر البيانات (AI4I أو CNC)
    item_identifier VARCHAR(100) NULL,         -- معرف المنتج
    air_temperature_k DECIMAL(6,2) NULL,       -- درجات الحرارة
    rotational_speed_rpm INT NULL,             -- سرعة الدوران
    torque_nm DECIMAL(6,2) NULL,               -- العزم
    tool_wear_min INT NULL,                    -- تآكل الأداة
    machine_failure INT NULL,                  -- حالة الفشل (0 أو 1)
    processed_at DATETIME2 DEFAULT SYSDATETIME()
);
GO