Simple query. I don't know what to comment on :)

An employee is considered to be working in the department on 1999-05-01, if StartDate ≤ ‘1999-05-01’ (has already started working by this date) and one of the following conditions:
1. EndDate ≥ ‘1999-05-01’ (has not yet finished working);
2. EndDate IS NULL (continues to work);

DISTINCT is used to exclude duplicates if an employee has multiple records in different shifts.


## Answer
DepartmentName EmployeeCount 
Production 149
Finance 11
Information Services 10
Human Resources 6
Shipping and Receiving 6
Engineering 5
Marketing 5
Production Control 5
Document Control 5
Quality Assurance 5
Purchasing 3
Research and Development 3
Tool Design 1
Facilities and Maintenance 1
Executive 1