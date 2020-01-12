SELECT C.CustomerID, C.CustomerFname, C.CustomerLname, COUNT(B.BookingID) AS 'TotalNumberOfBookings', 
	NTILE(10) OVER (ORDER BY(COUNT(B.BookingID))) AS 'Quartile'
FROM tblCUSTOMER C
JOIN tblBOOKING B ON B.CustomerID = C.CustomerID
WHERE B.BookDateTime BETWEEN GETDATE() AND GETDATE()-365*9 
GROUP BY C.CustomerID, C.CustomerFname, C.CustomerLname