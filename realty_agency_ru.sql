-- Агентство по недвижимости: аренда квартиры (PostgreSQL, названия на русском)

CREATE TABLE район (
    код_района SERIAL PRIMARY KEY,
    название   VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE статус_квартиры (
    код_статуса SERIAL PRIMARY KEY,
    название    VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE владелец (
    код_владельца SERIAL PRIMARY KEY,
    фио           VARCHAR(150) NOT NULL,
    телефон       VARCHAR(20)  NOT NULL,
    email         VARCHAR(100)
);

CREATE TABLE арендатор (
    код_арендатора SERIAL PRIMARY KEY,
    фио            VARCHAR(150) NOT NULL,
    телефон        VARCHAR(20)  NOT NULL,
    email          VARCHAR(100),
    номер_паспорта VARCHAR(20)  NOT NULL UNIQUE
);

CREATE TABLE агент (
    код_агента     SERIAL PRIMARY KEY,
    фио            VARCHAR(150) NOT NULL,
    телефон        VARCHAR(20)  NOT NULL,
    дата_найма     DATE         NOT NULL
);

CREATE TABLE квартира (
    код_квартиры  SERIAL PRIMARY KEY,
    код_владельца INT NOT NULL,
    код_района    INT NOT NULL,
    код_статуса   INT NOT NULL,
    улица         VARCHAR(100)  NOT NULL,
    дом           VARCHAR(10)   NOT NULL,
    номер_квартиры VARCHAR(10),
    комнат        SMALLINT      NOT NULL CHECK (комнат > 0),
    площадь_м2    NUMERIC(6,2)  NOT NULL CHECK (площадь_м2 > 0),
    этаж          SMALLINT,
    аренда_в_месяц NUMERIC(10,2) NOT NULL CHECK (аренда_в_месяц > 0),
    CONSTRAINT fk_квартира_владелец FOREIGN KEY (код_владельца) REFERENCES владелец (код_владельца),
    CONSTRAINT fk_квартира_район    FOREIGN KEY (код_района)    REFERENCES район (код_района),
    CONSTRAINT fk_квартира_статус   FOREIGN KEY (код_статуса)   REFERENCES статус_квартиры (код_статуса)
);

CREATE TABLE удобство (
    код_удобства SERIAL PRIMARY KEY,
    название     VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE удобство_квартиры (
    код_квартиры INT NOT NULL,
    код_удобства INT NOT NULL,
    PRIMARY KEY (код_квартиры, код_удобства),
    CONSTRAINT fk_ук_квартира FOREIGN KEY (код_квартиры) REFERENCES квартира (код_квартиры),
    CONSTRAINT fk_ук_удобство FOREIGN KEY (код_удобства) REFERENCES удобство (код_удобства)
);

CREATE TABLE просмотр (
    код_просмотра  SERIAL PRIMARY KEY,
    код_квартиры   INT       NOT NULL,
    код_арендатора INT       NOT NULL,
    код_агента     INT       NOT NULL,
    дата_время     TIMESTAMP NOT NULL,
    результат      VARCHAR(200),
    CONSTRAINT fk_просмотр_квартира   FOREIGN KEY (код_квартиры)   REFERENCES квартира (код_квартиры),
    CONSTRAINT fk_просмотр_арендатор  FOREIGN KEY (код_арендатора) REFERENCES арендатор (код_арендатора),
    CONSTRAINT fk_просмотр_агент      FOREIGN KEY (код_агента)     REFERENCES агент (код_агента)
);

CREATE TABLE договор_аренды (
    код_договора   SERIAL PRIMARY KEY,
    код_квартиры   INT NOT NULL,
    код_арендатора INT NOT NULL,
    код_агента     INT NOT NULL,
    дата_начала    DATE NOT NULL,
    дата_окончания DATE NOT NULL,
    сумма_аренды   NUMERIC(10,2) NOT NULL,
    залог          NUMERIC(10,2) NOT NULL DEFAULT 0,
    комиссия       NUMERIC(10,2) NOT NULL DEFAULT 0,
    CHECK (дата_окончания > дата_начала),
    CONSTRAINT fk_договор_квартира  FOREIGN KEY (код_квартиры)   REFERENCES квартира (код_квартиры),
    CONSTRAINT fk_договор_арендатор FOREIGN KEY (код_арендатора) REFERENCES арендатор (код_арендатора),
    CONSTRAINT fk_договор_агент     FOREIGN KEY (код_агента)     REFERENCES агент (код_агента)
);

CREATE TABLE тип_платежа (
    код_типа SERIAL PRIMARY KEY,
    название VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE платёж (
    код_платежа  SERIAL PRIMARY KEY,
    код_договора INT           NOT NULL,
    код_типа     INT           NOT NULL,
    дата_платежа DATE          NOT NULL,
    сумма        NUMERIC(10,2) NOT NULL CHECK (сумма > 0),
    CONSTRAINT fk_платёж_договор FOREIGN KEY (код_договора) REFERENCES договор_аренды (код_договора),
    CONSTRAINT fk_платёж_тип     FOREIGN KEY (код_типа)     REFERENCES тип_платежа (код_типа)
);
