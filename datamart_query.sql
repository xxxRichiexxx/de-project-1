-- Заполнение витрины

INSERT INTO analysis.dm_rfm_segments
SELECT r.user_id, recency, frequency, monetary_value
FROM analysis.tmp_rfm_recency as r
JOIN analysis.tmp_rfm_frequency as f USING (user_id) 
JOIN analysis.tmp_rfm_monetary_value as m USING (user_id)

