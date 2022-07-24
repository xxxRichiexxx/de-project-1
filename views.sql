-- Создаем представления для получения данных из источников

CREATE OR REPLACE VIEW analysis.orderitems AS
	SELECT * FROM production.orderitems;
	
CREATE OR REPLACE VIEW analysis.orders AS
	SELECT * FROM production.orders;
	
CREATE OR REPLACE VIEW analysis.orderstatuses AS
	SELECT * FROM production.orderstatuses;
	
CREATE OR REPLACE VIEW analysis.orderstatuslog AS
	SELECT * FROM production.orderstatuslog;
	
CREATE OR REPLACE VIEW analysis.users AS
	SELECT * FROM production.users;