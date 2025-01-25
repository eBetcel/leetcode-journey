WITH StatusTrips AS (
    SELECT
        Trips.request_at AS day,
        CASE
            WHEN Trips.status IN ('cancelled_by_driver', 'cancelled_by_client') THEN 1
            ELSE 0
        END AS "cancelled"
    FROM
        Trips
        INNER JOIN Users AS ClientUsers ON (
            Trips.client_id = ClientUsers.users_id
            AND ClientUsers.role = 'client'
        )
        INNER JOIN Users AS DriversUsers ON (
            Trips.driver_id = DriversUsers.users_id
            AND DriversUsers.role = 'driver'
        )
    WHERE
        DriversUsers.banned != 'Yes'
        AND ClientUsers.banned != 'Yes'
        AND Trips.request_at >= '2013-10-01'
        AND Trips.request_at <= '2013-10-03'
)
SELECT
    day AS Day,
    ROUND(CAST(SUM(cancelled) AS NUMERIC) / COUNT(*), 2) as "Cancellation Rate"
FROM
    StatusTrips
GROUP BY
    day