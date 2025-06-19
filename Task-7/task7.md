## Logic

To solve the problem of constructing hierarchical chains of employee subordination, a recursive common table expression (CTE) is used, which allows tree-like data structures to be processed in SQL. A recursive CTE consists of two main parts: a base case (anchor member) and a recursive case (recursive member), combined by the UNION ALL operator. In the base case, the recursion process is initialized by selecting all employees whose ManagerID field is NULL, which means that these employees are top managers of the organization and have no superiors. For each such employee, an initial chain of command is created, consisting only of their EmployeeID, converted to string format using the CAST function with type CHAR(1000), and the hierarchy level is set to 0. The recursive part of the query is executed iteratively and at each step finds all employees who are direct subordinates of employees already processed in previous iterations, using the join condition e.ManagerID = sc.EmployeeID between the current employee table and the results of the previous iteration of subordination_chains. For each subordinate found, a new chain is formed by concatenating the existing chain with the symbols “ -> ” and the identifier of the current employee using the CONCAT function, and the level is increased by one. The recursion process automatically ends when there are no more employees that satisfy the join condition, i.e., when all leaf nodes of the hierarchical tree have been reached. The final selection extracts all the formed chains and sorts them first by descending level (level DESC), which allows you to see the longest chains of subordination first, and then by alphabetical order of the chains themselves to ensure a deterministic result. The result of the query is a complete set of all possible paths from top managers to end employees in the organizational hierarchy, presented in a text format convenient for analysis, where each chain shows the sequence of subordination from manager to subordinate through arrows.

## Structural observations

A single root hierarchy, as all chains begin with employee ID 109, clearly indicating that this employee is the sole top manager of the organization (probably the CEO or President). This indicates a centralized organizational structure with a single leader.

All results shown have a depth of 0 to 4, which means a 5-level hierarchy (from 0 to 4). This structure is typical for medium and large corporations:
Level 0: CEO (109);
Level 1: Top managers (12, 140, 148, and so on);
Level 2: Middle managers (3, 71, 200, 21, and so on);
Level 3: Managers (158, 263, 274, 41, 90, 108, etc.);
Level 4: Rank-and-file employees/specialists;

## Observations
Some managers have the largest number of direct subordinates, which may indicate management overload or the specifics of operational activities requiring direct control.
The organization also demonstrates a classic functional structure with a clear division of responsibilities between key areas.