CREATE DATABASE formulaUno;
use formulaUno;

# Primera consulta
SELECT
   d.forename,
   d.surname,
   r.date,
   r.name AS raceName,
   c.name AS constructorName,
   AVG(lt.milliseconds) AS avgLapTime,
   (SELECT count(*) from pitStops ps
   WHERE r.raceId = ps.raceId
   AND d.driverId = ps.driverId) AS pitStopCount,
   (SELECT position
    FROM qualifying q
    WHERE q.raceId = r.raceId
    AND q.driverId = d.driverId) AS qualyPosition
FROM
   lapTimes lt
JOIN
   results res ON lt.raceId = res.raceId AND lt.driverId = res.driverId
JOIN
   drivers d ON res.driverId = d.driverId
JOIN
   races r ON res.raceId = r.raceId
JOIN
   constructors c ON res.constructorId = c.constructorId
LEFT JOIN
   pitStops ps ON lt.raceId = ps.raceId AND lt.driverId = ps.driverId
WHERE
   res.positionOrder <= 10
GROUP BY
   d.driverId, d.forename, d.surname, r.raceId, r.name, c.name, r.date
ORDER BY
   r.date ASC;

# Consulta reescrita
SELECT
    d.forename,
    d.surname,
    r.date,
    r.name AS raceName,
    c.name AS constructorName,
    AVG(lt.milliseconds) AS avgLapTime,
    (SELECT count(*) from pitStops ps
    WHERE r.raceId = ps.raceId
    AND d.driverId = ps.driverId) AS pitStopCount,
    q.position
FROM
    lapTimes lt
JOIN
    results res ON lt.raceId = res.raceId AND lt.driverId = res.driverId
JOIN
    drivers d ON res.driverId = d.driverId
JOIN
    races r ON res.raceId = r.raceId
JOIN
    qualifying q ON q.raceId = r.raceId AND q.driverId = d.driverId
JOIN
    constructors c ON res.constructorId = c.constructorId
WHERE
    res.positionOrder <= 10
GROUP BY
    d.driverId, d.forename, d.surname, r.raceId, r.name, c.name, r.date, q.position
ORDER BY
    r.date ASC;

# índices para optimizar

CREATE INDEX idx_qualifying_raceId_driverId ON qualifying(raceId, driverId);
CREATE INDEX idx_constructors_constructorId ON constructors(constructorId);
CREATE INDEX idx_pitStops_raceId_driverId ON pitStops(raceId, driverId);

# Drops para borrar los índices
DROP INDEX idx_qualifying_raceId_driverId ON qualifying;
DROP INDEX idx_constructors_constructorId ON constructors;
DROP INDEX idx_pitStops_raceId_driverId ON pitStops;

# índices despreciados
CREATE INDEX idx_res_raceId_driverId ON results (raceId, driverId);
CREATE INDEX idx_lapTimes_raceId_driverId ON lapTimes (raceId, driverId);
DROP INDEX idx_res_raceId_driverId ON results;
DROP INDEX idx_lapTimes_raceId_driverId ON lapTimes;


