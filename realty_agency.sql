-- Агентство по недвижимости: аренда квартиры (PostgreSQL)

CREATE TABLE district (
    district_id SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE apartment_status (
    status_id SERIAL PRIMARY KEY,
    name      VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE owner (
    owner_id  SERIAL PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    phone     VARCHAR(20)  NOT NULL,
    email     VARCHAR(100)
);

CREATE TABLE tenant (
    tenant_id   SERIAL PRIMARY KEY,
    full_name   VARCHAR(150) NOT NULL,
    phone       VARCHAR(20)  NOT NULL,
    email       VARCHAR(100),
    passport_no VARCHAR(20)  NOT NULL UNIQUE
);

CREATE TABLE agent (
    agent_id  SERIAL PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    phone     VARCHAR(20)  NOT NULL,
    hire_date DATE         NOT NULL
);

CREATE TABLE apartment (
    apartment_id SERIAL PRIMARY KEY,
    owner_id     INT NOT NULL,
    district_id  INT NOT NULL,
    status_id    INT NOT NULL,
    street       VARCHAR(100)  NOT NULL,
    house        VARCHAR(10)   NOT NULL,
    flat_no      VARCHAR(10),
    rooms        SMALLINT      NOT NULL CHECK (rooms > 0),
    area_m2      NUMERIC(6,2)  NOT NULL CHECK (area_m2 > 0),
    floor        SMALLINT,
    monthly_rent NUMERIC(10,2) NOT NULL CHECK (monthly_rent > 0),
    CONSTRAINT fk_apartment_owner    FOREIGN KEY (owner_id)    REFERENCES owner (owner_id),
    CONSTRAINT fk_apartment_district FOREIGN KEY (district_id) REFERENCES district (district_id),
    CONSTRAINT fk_apartment_status   FOREIGN KEY (status_id)   REFERENCES apartment_status (status_id)
);

CREATE TABLE amenity (
    amenity_id SERIAL PRIMARY KEY,
    name       VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE apartment_amenity (
    apartment_id INT NOT NULL,
    amenity_id   INT NOT NULL,
    PRIMARY KEY (apartment_id, amenity_id),
    CONSTRAINT fk_aa_apartment FOREIGN KEY (apartment_id) REFERENCES apartment (apartment_id),
    CONSTRAINT fk_aa_amenity   FOREIGN KEY (amenity_id)   REFERENCES amenity (amenity_id)
);

CREATE TABLE viewing (
    viewing_id       SERIAL PRIMARY KEY,
    apartment_id     INT       NOT NULL,
    tenant_id        INT       NOT NULL,
    agent_id         INT       NOT NULL,
    viewing_datetime TIMESTAMP NOT NULL,
    result           VARCHAR(200),
    CONSTRAINT fk_viewing_apartment FOREIGN KEY (apartment_id) REFERENCES apartment (apartment_id),
    CONSTRAINT fk_viewing_tenant    FOREIGN KEY (tenant_id)    REFERENCES tenant (tenant_id),
    CONSTRAINT fk_viewing_agent     FOREIGN KEY (agent_id)     REFERENCES agent (agent_id)
);

CREATE TABLE lease_contract (
    contract_id  SERIAL PRIMARY KEY,
    apartment_id INT NOT NULL,
    tenant_id    INT NOT NULL,
    agent_id     INT NOT NULL,
    start_date   DATE NOT NULL,
    end_date     DATE NOT NULL,
    rent_amount  NUMERIC(10,2) NOT NULL,
    deposit      NUMERIC(10,2) NOT NULL DEFAULT 0,
    commission   NUMERIC(10,2) NOT NULL DEFAULT 0,
    CHECK (end_date > start_date),
    CONSTRAINT fk_contract_apartment FOREIGN KEY (apartment_id) REFERENCES apartment (apartment_id),
    CONSTRAINT fk_contract_tenant    FOREIGN KEY (tenant_id)    REFERENCES tenant (tenant_id),
    CONSTRAINT fk_contract_agent     FOREIGN KEY (agent_id)     REFERENCES agent (agent_id)
);

CREATE TABLE payment_type (
    payment_type_id SERIAL PRIMARY KEY,
    name            VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE payment (
    payment_id      SERIAL PRIMARY KEY,
    contract_id     INT           NOT NULL,
    payment_type_id INT           NOT NULL,
    payment_date    DATE          NOT NULL,
    amount          NUMERIC(10,2) NOT NULL CHECK (amount > 0),
    CONSTRAINT fk_payment_contract FOREIGN KEY (contract_id)     REFERENCES lease_contract (contract_id),
    CONSTRAINT fk_payment_type     FOREIGN KEY (payment_type_id) REFERENCES payment_type (payment_type_id)
);
