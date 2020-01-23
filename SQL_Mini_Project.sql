/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform.


/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

select f.name,
f.membercost

from country_club.Facilities f
where f.membercost > 0

order by 2

/* Q2: How many facilities do not charge a fee to members? */

select f.name,
f.membercost

from country_club.Facilities f
where f.membercost = 0

order by 2

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

select f.facid,
f.name,
f.membercost,
f.monthlymaintenance

from country_club.Facilities f
where f.membercost > 0
and f.membercost > (f.monthlymaintenance * .2)

order by 3

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

select f.facid,
f.name,
f.membercost,
f.monthlymaintenance

from country_club.Facilities f

where f.facid in (1,5)

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

select f.name,
f.monthlymaintenance,
case when f.monthlymaintenance > 100 then 'expensive'
     when f.monthlymaintenance <= 100 then 'cheap'
     else null end as pricing

from country_club.Facilities f

order by 2

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

select distinct m.firstname,
m.surname,
max(m.joindate) as recent_member

from country_club.Members m

where m.firstname <> 'GUEST'

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

select concat(m.firstname, ' ', m.surname) as full_name,
f.name

from country_club.Members m
left join country_club.Bookings b on m.memid = b.memid
left join country_club.Facilities f on b.facid = f.facid

where f.facid in (0,1)

group by 1

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

select f.name, 
concat(m.firstname, ' ', m.surname) as full_name,
case when m.memid = 0 then b.slots * f.guestcost
	 else b.slots * f.membercost end as cost

from country_club.Members m
left join country_club.Bookings b on m.memid = b.memid
left join country_club.Facilities f on b.facid = f.facid

where b.starttime >= '2012-09-14' and 
	  b.starttime < '2012-09-15' and (
    (m.memid = 0 and b.slots * f.guestcost > 30) or 
	(m.memid <> 0 and b.slots * f.membercost > 30)
	)

order by cost desc


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

select full_name,
facility,
cost

from (
    
select f.name as facility, 
concat(m.firstname, ' ', m.surname) as full_name,
case when m.memid = 0 then b.slots * f.guestcost
	 else b.slots * f.membercost end as cost

from country_club.Members m
left join country_club.Bookings b on m.memid = b.memid
left join country_club.Facilities f on b.facid = f.facid

where b.starttime >= '2012-09-14' and 
	  b.starttime < '2012-09-15' 
          
	) as subquery

    where cost > 30
    order by cost desc

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

select facility,
revenue 

from (

select f.name as facility, 
sum(case when m.memid = 0 then b.slots * f.guestcost
	 else b.slots * f.membercost end) as revenue

from country_club.Members m
left join country_club.Bookings b on m.memid = b.memid
left join country_club.Facilities f on b.facid = f.facid

    group by 1
    
    ) as subquery

where revenue < 1000

order by revenue
