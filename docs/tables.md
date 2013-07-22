This isn't intended as something we should implement all at once, but rather a
sort of textual E-R diagram to guide us and start discussions (w/r/t mapping the
frontend and future flexibility)


Users
=====
name
email

Authentications (Omniauth standard)
===================================
user_id
provider
uid

UserLinks
=========
user_id
service_name (aka twitter)
service_url (aka http://twitter.com/zapnap)

Instructors
===========
user_id
course_id
title
biography

Courses
=======
name
published_at
course_start_date
campaign_end_date
venue_id <sup>1</sup>
instructor_id
description
min_seats
max_seats
price_per_seat <sup>2</sup>
short_name (slug)
custom_domain

Venues <sup>1</sup>
======
name
address
city
state
zip

Reservations
============
course_id
user_id
canceled_at
completed_at
payment_fields <sup>3</sup>


Notes
=====
1. Should Venue be a separate table? (promotes re-use, engagement with co-working
   spaces, etc). Otoh, simpler to iterate / edit if we keep it in the same table.

2. We probably want to allow for the possibility of tiered seats / different
   reservation levels at some point.

3. Payment fields are TBD. We probably hold a reference to an authorization.
   Will also need a field to indicate if the payment has been captured. We
   probably want a separate table for this (payments?)
