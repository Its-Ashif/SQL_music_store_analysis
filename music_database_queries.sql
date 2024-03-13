/* Question Set 1 - Easy */

/* Q1: Who is the senior most employee based on job title? */

select * from employee
order by levels desc 
limit 1
	
/* Q2: Which countries have the most Invoices? */
	
select count(*) as total_invoice,billing_country from invoice 
group by billing_country order by total_invoice desc

/* Q3: What are top 3 values of total invoice? */
	
select total from invoice 
order by total desc 
limit 3

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */
	
select billing_city,SUM(total) as sum_of_total_invoice from invoice 
group by billing_city order by sum_of_total_invoice desc 
limit 1

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/
	
select customer.customer_id,customer.first_name,customer.last_name , SUM(invoice.total) as total_spent
from customer join invoice on customer.customer_id = invoice.customer_id group by customer.customer_id 
order by total_spent desc 
limit 1 
	

	
/* Question Set 2 - Moderate */

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

select distinct email,first_name,last_name from customer 
join invoice on customer.customer_id = invoice.customer_id 
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id 
where track.track_id in (
	select track.track_id from track 
	join genre on track.genre_id = genre.genre_id 
	where genre.name like 'Rock'
)
order by email

/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select artist.artist_id,artist.name, count(artist.artist_id) as number_of_songs from artist 
join album on artist.artist_id = album.artist_id
join track on album.album_id = track.album_id 
join genre on track.genre_id = genre.genre_id 
where genre.name like 'Rock' 
group by artist.artist_id
order by number_of_songs desc
limit 10;

/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

select name,milliseconds from track 
where milliseconds > (select avg(milliseconds) from track) 
order by milliseconds desc


 
/* Question Set 3 - Advance */

/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

with best_selling_artist as (
	select artist.artist_id, artist.name, SUM(invoice_line.unit_price * invoice_line.quantity) as total_sales
    from invoice_line
    join track on invoice_line.track_id = track.track_id
    join album on track.album_id = album.album_id
    join artist on album.artist_id = artist.artist_id
    group by 1
    order by 3 desc
    limit 1
)

select c.customer_id,c.first_name,c.last_name, bsa.name,
SUM(li.unit_price * li.quantity) as amount_spent
from invoice i
join customer c on i.customer_id = c.customer_id
join invoice_line li on li.invoice_id = i.invoice_id
join track t on li.track_id = t.track_id
join album alb on t.album_id = alb.album_id
join best_selling_artist bsa on bsa.artist_id = alb.artist_id
group by 1,2,3,4
order by 5 desc

/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

with best_selling_genre as(
	select g.genre_id,g.name,SUM(li.unit_price * li.quantity) as total_spent from genre g
    join track t on g.genre_id = t.genre_id
    join invoice_line li on t.track_id = li.track_id
    group by 1
    order by 2 desc
    limit 1
)

select i.billing_country,bsg.name,SUM(li.unit_price * li.quantity) as total_spent from invoice i
join invoice_line li on i.invoice_id = li.invoice_id
join track t on li.track_id = t.track_id
join best_selling_genre bsg on bsg.genre_id = t.genre_id
group by 1,2
order by 3 desc



