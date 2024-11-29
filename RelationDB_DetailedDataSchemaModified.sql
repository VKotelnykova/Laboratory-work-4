-- Видалення таблиць з каскадним видаленням можливих описів цілісності
DROP TABLE IF EXISTS User CASCADE;
DROP TABLE IF EXISTS SleepSchedule CASCADE;
DROP TABLE IF EXISTS Sleep CASCADE;
DROP TABLE IF EXISTS MonitoringMode CASCADE;
DROP TABLE IF EXISTS Report CASCADE;
DROP TABLE IF EXISTS Recommendation CASCADE;
DROP TABLE IF EXISTS OptimalTime CASCADE;
DROP TABLE IF EXISTS SleepCondition CASCADE;

-- Створення таблиці User
CREATE TABLE User (
    user_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор користувача
    sleepSchedule INTEGER NOT NULL -- Зовнішній ключ для зв'язку з таблицею SleepSchedule
);

-- Створення таблиці SleepSchedule
CREATE TABLE SleepSchedule (
    schedule_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор графіка сну
    bedTime VARCHAR(5) NOT NULL, -- Час відходу до сну (формат: HH:MM)
    wakeUpTime VARCHAR(5) NOT NULL, -- Час прокидання (формат: HH:MM)
    user_id INTEGER NOT NULL, -- Зовнішній ключ для User
    CONSTRAINT fk_user_schedule FOREIGN KEY (user_id) REFERENCES User(user_id)
);

-- Створення таблиці Sleep
CREATE TABLE Sleep (
    sleep_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор сну
    duration INTEGER CHECK (duration > 0) NOT NULL, -- Тривалість сну в хвилинах
    wakeCount INTEGER CHECK (wakeCount >= 0) NOT NULL, -- Кількість пробуджень
    quality FLOAT CHECK (quality >= 0 AND quality <= 100) NOT NULL, -- Якість сну
    user_id INTEGER NOT NULL, -- Зовнішній ключ для User
    CONSTRAINT fk_user_sleep FOREIGN KEY (user_id) REFERENCES User(user_id)
);

-- Створення таблиці MonitoringMode
CREATE TABLE MonitoringMode (
    mode_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор режиму моніторингу
    isActive BOOLEAN NOT NULL, -- Чи активований режим моніторингу
    user_id INTEGER NOT NULL, -- Зовнішній ключ для User
    CONSTRAINT fk_user_mode FOREIGN KEY (user_id) REFERENCES User(user_id)
);

-- Створення таблиці Report
CREATE TABLE Report (
    report_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор звіту
    sleepDuration INTEGER CHECK (sleepDuration > 0) NOT NULL, -- Тривалість сну у звіті
    wakeCount INTEGER CHECK (wakeCount >= 0) NOT NULL, -- Кількість пробуджень у звіті
    sleepQuality FLOAT CHECK (sleepQuality >= 0 AND sleepQuality <= 100) NOT NULL, -- Якість сну
    sleep_id INTEGER NOT NULL, -- Зовнішній ключ для таблиці Sleep
    CONSTRAINT fk_sleep_report FOREIGN KEY (sleep_id) REFERENCES Sleep(sleep_id)
);

-- Створення таблиці Recommendation
CREATE TABLE Recommendation (
    recommendation_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор рекомендації
    description TEXT NOT NULL, -- Опис рекомендації
    report_id INTEGER NOT NULL, -- Зовнішній ключ для таблиці Report
    CONSTRAINT fk_report_recommendation FOREIGN KEY (report_id) REFERENCES Report(report_id)
);

-- Створення таблиці OptimalTime
CREATE TABLE OptimalTime (
    optimalTime_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор оптимального часу
    recommendedTime VARCHAR(5) NOT NULL, -- Рекомендований час для відходу до сну
    recommendation_id INTEGER NOT NULL, -- Зовнішній ключ для таблиці Recommendation
    CONSTRAINT fk_recommendation_optimalTime FOREIGN KEY (recommendation_id) REFERENCES Recommendation(recommendation_id)
);

-- Створення таблиці SleepCondition
CREATE TABLE SleepCondition (
    condition_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор умов сну
    temperature FLOAT CHECK (temperature >= 0 AND temperature <= 40) NOT NULL, -- Температура в кімнаті
    lighting VARCHAR(255) NOT NULL, -- Умови освітлення в кімнаті
    recommendation_id INTEGER NOT NULL, -- Зовнішній ключ для таблиці Recommendation
    CONSTRAINT fk_recommendation_condition FOREIGN KEY (recommendation_id) REFERENCES Recommendation(recommendation_id)
);

-- Обмеження регулярного виразу для полів типу VARCHAR
-- Перевірка для email
ALTER TABLE User ADD CONSTRAINT User_email_check 
    CHECK (user_email ~* '^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$');

-- Перевірка для телефонного номера
ALTER TABLE User ADD CONSTRAINT User_phone_check 
    CHECK (user_phone ~* '^\(\d{3}\)\d{3}-\d{4}$');
