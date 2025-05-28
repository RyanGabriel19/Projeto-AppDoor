SHOW VARIABLES LIKE 'event_scheduler'; -- Aqui eu verifico se o event_scheduler está ativo (ON)

SHOW EVENTS; -- Aqui eu verifico os jobs/eventos que eu já criei

CREATE EVENT job_movimenta_porta
ON SCHEDULE EVERY 5 MINUTE
DO
BEGIN

SELECT * FROM USUARIO;

END;