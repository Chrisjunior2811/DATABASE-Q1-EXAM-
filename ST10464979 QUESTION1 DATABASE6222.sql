
USE StudentNumber_DATA6222_ExamQ1;
GO

-- ==========================================
-- Q.1.1 CREATE OR ALTER VIEW
-- ==========================================
CREATE OR ALTER VIEW largeBOOKINGs AS
SELECT
    VenueID,
    ClientID,
    EventStartDate,
    EventEndDate,
    NumberOfAttendees
FROM BOOKING
WHERE YEAR(EventStartDate) = 2026
AND NumberOfAttendees >= 100;
GO

-- Display the view
SELECT * FROM largeBOOKINGs;
GO


-- ==========================================
-- Q.1.2 CREATE OR ALTER STORED PROCEDURE
-- ==========================================
CREATE OR ALTER PROCEDURE FindBOOKINGs
    @VenueID VARCHAR(5)
AS
BEGIN
    SELECT
        CLIENT.ClientFullName,
        CLIENT.ClientContact,
        BOOKING.EventStartDate,
        BOOKING.EventEndDate,
        BOOKING.NumberOfAttendees
    FROM BOOKING
    INNER JOIN CLIENT
        ON BOOKING.ClientID = CLIENT.ClientID
    INNER JOIN VENUE
        ON BOOKING.VenueID = VENUE.VenueID
    WHERE VENUE.VenueID = @VenueID;
END;
GO

-- Execute stored procedure
EXEC FindBOOKINGs @VenueID = 'V0001';
GO


-- ==========================================
-- Q.1.3 DISPLAY BOOKING STATUS
-- ==========================================
SELECT
    VENUE.VenueID,
    VENUE.VenueName,
    VENUE.VenueAddress,
    CASE
        WHEN BOOKING.BookingID IS NOT NULL
            THEN 'BOOKINGs exist'
        ELSE 'NO BOOKINGs exist'
    END AS [BOOKINGs STATUS]
FROM VENUE
LEFT JOIN BOOKING
    ON VENUE.VenueID = BOOKING.VenueID;
GO


-- ==========================================
-- Q.1.4 TOTAL ATTENDEES PER VENUE
-- ==========================================
SELECT
    VENUE.VenueName,
    ISNULL(SUM(BOOKING.NumberOfAttendees), 0) AS TotalAttendees
FROM VENUE
LEFT JOIN BOOKING
    ON VENUE.VenueID = BOOKING.VenueID
GROUP BY
    VENUE.VenueID,
    VENUE.VenueName
ORDER BY
    TotalAttendees DESC;
GO


-- ==========================================
-- Q.1.5 VENUES WITH NO BOOKINGS
-- ==========================================
SELECT
    VenueName
FROM VENUE
WHERE NOT EXISTS (
    SELECT 1
    FROM BOOKING
    WHERE BOOKING.VenueID = VENUE.VenueID
);
GO


-- ==========================================
-- VERIFY TABLE CONTENTS
-- ==========================================
SELECT * FROM CLIENT;
SELECT * FROM VENUE;
SELECT * FROM BOOKING;
GO

