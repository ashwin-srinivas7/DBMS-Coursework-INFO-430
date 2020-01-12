--Customer who have had at least 3 flights arriving into SEATAC airport since May 4, 2011
WITH CTE_1(CustomerID, CustomerFname, CustomerLname, NumFlightsToSEATAC)
AS
(
	SELECT C.CustomerID, C.CustomerFname, C.CustomerLname, COUNT(B.FlightID)
	FROM tblCUSTOMER C
		JOIN tblBOOKING B ON B.CustomerID = C.CustomerID
		JOIN tblFLIGHT F ON F.FlightID = B.FlightID
		JOIN tblAIRPORT A ON A.AirportID = F.ArrivalAirportID
	WHERE A.AirportName = 'SEATAC'AND B.BookDateTime > 'May 4, 2011'
	GROUP BY C.CustomerID, C.CustomerFname, C.CustomerLname
	HAVING COUNT(B.FlightID) > 3
),

--have had no more than 7 flights departing from Seoul/Inchon since November 12, 2010 
CTE_2(CustomerID, CustomerFname, CustomerLname, NumFlights)
AS
(
	SELECT C.CustomerID, C.CustomerFname, C.CustomerLname, COUNT(B.FlightID)
	FROM tblCUSTOMER C
		JOIN tblBOOKING B ON B.CustomerID = C.CustomerID
		JOIN tblFLIGHT F ON F.FlightID = B.FlightID
		JOIN tblAIRPORT A ON A.AirportID = F.DepartAirportID
	WHERE A.AirportName = 'Seoul/Incheon'
	AND B.BookDateTime > 'Nov 12, 2010'
	GROUP BY C.CustomerID, C.CustomerFname, C.CustomerLname
	HAVING COUNT(B.FlightID) <= 7
),
--have booked flights with more than $10,750 in fares in 2017
CTE_3(CustomerID, CustomerFname, CustomerLname, TotalFare)
AS
(
	SELECT C.CustomerID, C.CustomerFname, C.CustomerLname, SUM(B.Fare)
	FROM tblCUSTOMER C
		JOIN tblBOOKING B ON B.CustomerID = C.CustomerID
	WHERE B.BookDateTime BETWEEN '1 Jan, 2017' AND '31 Dec, 2017'
	GROUP BY C.CustomerID, C.CustomerFname, C.CustomerLname
	HAVING SUM(B.Fare)>10750
),
--have booking fees of less than $3,300 for 'excessive luggage' between June and September 2014 
CTE_4(CustomerID, CustomerFname, CustomerLname, Fee)
AS
(
	SELECT C.CustomerID, C.CustomerFname, C.CustomerLname, SUM(F.FeeAmount)
	FROM tblCUSTOMER C
		JOIN tblBOOKING B ON C.CustomerID = B.CustomerID
		JOIN tblBOOKING_FEE BF ON BF.BookingID = B.BookingID
		JOIN tblFEE F ON F.FeeID = BF.FeeID
		JOIN tblFEE_TYPE FT ON FT.FeeTypeID = F.FeeTypeID
	WHERE FT.FeeTypeName = 'Excessive Luggage' 
	AND (B.BookDateTime BETWEEN 'Jun 1, 2014' AND 'Sep 30, 2014')
	GROUP BY C.CustomerID, C.CustomerFname, C.CustomerLname
	HAVING SUM(F.FeeAmount)<3300
)
SELECT * FROM CTE_1 C1
JOIN CTE_2 C2 ON C2.CustomerID = C1.CustomerID
JOIN CTE_3 C3 ON C3.CustomerID = C2.CustomerID
JOIN CTE_3 C4 ON C4.CustomerID = C3.CustomerID