-- Видалення таблиць з каскадним видаленням можливих описів цілісності
DROP TABLE IF EXISTS "user" CASCADE;
DROP TABLE IF EXISTS sleep_schedule CASCADE;
DROP TABLE IF EXISTS sleep CASCADE;
DROP TABLE IF EXISTS monitoring_mode CASCADE;
DROP TABLE IF EXISTS report CASCADE;
DROP TABLE IF EXISTS recommendation CASCADE;
DROP TABLE IF EXISTS optimal_time CASCADE;
DROP TABLE IF EXISTS sleep_condition CASCADE;

-- Створення таблиці "user"
CREATE TABLE "user" (
    user_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор користувача
    -- Зовнішній ключ для зв'язку з таблицею sleep_schedule
    sleep_schedule_id INTEGER NOT NULL
);

-- Створення таблиці sleep_schedule
CREATE TABLE sleep_schedule (
    schedule_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор графіка сну
    bed_time VARCHAR(5) NOT NULL, -- Час відходу до сну (формат: HH:MM)
    wake_up_time VARCHAR(5) NOT NULL, -- Час прокидання (формат: HH:MM)
    user_id INTEGER NOT NULL, -- Зовнішній ключ для "user"
    CONSTRAINT fk_user_schedule FOREIGN KEY (user_id) REFERENCES "user" (
        user_id
    )
);

-- Створення таблиці sleep
CREATE TABLE sleep (
    sleep_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор сну
    duration INTEGER CHECK (duration > 0) NOT NULL, -- Тривалість сну в хвилинах
    wake_count INTEGER CHECK (wake_count >= 0) NOT NULL, -- Кількість пробуджень
    -- Якість сну
    quality FLOAT CHECK (quality >= 0 AND quality <= 100) NOT NULL,
    user_id INTEGER NOT NULL, -- Зовнішній ключ для "user"
    CONSTRAINT fk_user_sleep FOREIGN KEY (user_id) REFERENCES "user" (user_id)
);

-- Створення таблиці monitoring_mode
CREATE TABLE monitoring_mode (
    mode_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор режиму моніторингу
    mode_name VARCHAR(50) NOT NULL, -- Назва режиму моніторингу
    user_id INTEGER NOT NULL, -- Зовнішній ключ для "user"
    CONSTRAINT fk_user_mode FOREIGN KEY (user_id) REFERENCES "user" (user_id)
);

-- Створення таблиці report
CREATE TABLE report (
    report_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор звіту
    report_date DATE NOT NULL, -- Дата звіту
    user_id INTEGER NOT NULL, -- Зовнішній ключ для "user"
    CONSTRAINT fk_user_report FOREIGN KEY (user_id) REFERENCES "user" (
        user_id
    )
);

-- Створення таблиці recommendation
CREATE TABLE recommendation (
    -- Унікальний ідентифікатор рекомендації
    recommendation_id SERIAL PRIMARY KEY,
    recommendation_text TEXT NOT NULL, -- Текст рекомендації
    user_id INTEGER NOT NULL, -- Зовнішній ключ для "user"
    CONSTRAINT fk_user_recommendation FOREIGN KEY (
        user_id
    ) REFERENCES "user" (user_id)
);

-- Створення таблиці optimal_time
CREATE TABLE optimal_time (
    -- Унікальний ідентифікатор оптимального часу
    optimal_time_id SERIAL PRIMARY KEY,
    start_time VARCHAR(5) NOT NULL, -- Час початку
    end_time VARCHAR(5) NOT NULL, -- Час кінця
    user_id INTEGER NOT NULL, -- Зовнішній ключ для "user"
    CONSTRAINT fk_user_optimal_time FOREIGN KEY (user_id) REFERENCES "user" (
        user_id
    )
);

-- Створення таблиці sleep_condition
CREATE TABLE sleep_condition (
    condition_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор стану сну
    condition_description TEXT NOT NULL, -- Опис стану сну
    user_id INTEGER NOT NULL, -- Зовнішній ключ для "user"
    CONSTRAINT fk_user_sleep_condition FOREIGN KEY (
        user_id
    ) REFERENCES "user" (user_id)
);

-- Обмеження регулярного виразу для полів типу VARCHAR
-- Перевірка для email
ALTER TABLE "user" ADD CONSTRAINT user_email_check
CHECK (user_email ~* '^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$');

-- Перевірка для телефонного номера
ALTER TABLE "user" ADD CONSTRAINT user_phone_check
CHECK (user_phone ~* '^\(\d{3}\)\d{3}-\d{4}$');
