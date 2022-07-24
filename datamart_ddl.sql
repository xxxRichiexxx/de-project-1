-- Создание витрины данных

CREATE TABLE analysis.dm_rfm_segments (
    user_id int,
    recency int NOT NULL,
    frequency int NOT NULL,
    monetary_value int NOT NULL,
    CONSTRAINT dm_rfm_segments_recency_check CHECK(recency BETWEEN 1 AND 5),
    CONSTRAINT dm_rfm_segments_frequency_check CHECK(frequency BETWEEN 1 AND 5),
    CONSTRAINT dm_rfm_segments_monetary_value_check CHECK(monetary_value BETWEEN 1 AND 5),
    CONSTRAINT dm_rfm_segments_user_id_pk PRIMARY KEY(user_id)
);

--Внесены изменения в код создания витрины. В рабочей базе данные изменения отражены с помощью следующих скриптов:
--ALTER TABLE analysis.dm_rfm_segments
--DROP CONSTRAINT dm_rfm_segments_user_id_fk

--ALTER TABLE analysis.dm_rfm_segments
--ADD CONSTRAINT dm_rfm_segments_user_id_pk PRIMARY KEY(user_id)