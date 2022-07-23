-- Создание витрины данных

CREATE TABLE analysis.dm_rfm_segments (
    user_id int,
    recency int NOT NULL,
    frequency int NOT NULL,
    monetary_value int NOT NULL,
    CONSTRAINT dm_rfm_segments_recency_check CHECK(recency BETWEEN 1 AND 5),
    CONSTRAINT dm_rfm_segments_frequency_check CHECK(frequency BETWEEN 1 AND 5),
    CONSTRAINT dm_rfm_segments_monetary_value_check CHECK(monetary_value BETWEEN 1 AND 5),
    CONSTRAINT dm_rfm_segments_user_id_fk FOREIGN KEY(user_id) REFERENCES production.users(id)
)