-------------------------------- PROJECT ON INSTAGRAM DATABASE-----------------------------------------------
----------------------------------- (by Nisha Jagtap)--------------------------------------------------------

-- 1) How many times does the average user post?
select avg(post) from 
(select count(photos.id) as post from users
join photos on users.id = photos.user_id 
group by username) as h;

-- 2) Find the top 5 most used hashtags;
select tag_name, count(*) as c from photo_tags
join tags on photo_tags.tag_id = tags.id 
group by tag_id, tag_name 
order by c desc limit 5;

-- 3) Find users who have liked every single photo on the site;

select u.username, count(photo_id) as no_of_photos from likes l
join photos p on l.photo_id = p.id
join users u on l.user_id = u.id
group by username having no_of_photos =
(select count(distinct photo_id) from likes);

-- 4) Retrieve a list of users along with their usernames and
-- the rank of their account creation, ordered by the creation date in ascending order;

select user_id, username, users.created_at,
rank () over (order by users.created_at) as 'rank'
from users 
inner join photos on users.id = photos.user_id group by user_id, username ;

-- 5) List the comments made on photos with their comment texts, photo URLs, and usernames of users who posted the comments. 
-- Include the comment count for each photo;

select  u.username, c.comment_text, p.image_url from photos p
join comments c on p.id = c.photo_id
join users u on c.user_id = u.id
group by u.username,  c.comment_text, p.image_url;

select image_url,photo_id, count(comment_text) as c_count from photos 
join comments on photos.id = comments.photo_id group by image_url, photo_id;

-- 6) For each tag, show the tag name and the number of photos associated with that tag.
-- Rank the tags by the number of photos in descending order;
 
select t.tag_name , count(image_url) as no_of_photos from tags t
join photo_tags pt on t.id = pt.tag_id
join photos p on pt.photo_id = p.id
join users u on p.user_id = u.id
group by t.tag_name
order by no_of_photos  desc; 

-- 7) List the usernames of users who have posted photos along with the count
-- of photos they have posted. Rank them by the number of photos in descending order.
 
select u.username ,count(p.image_url) as no_of_photos from photos p 
join users u on p.user_id = u.id group by u.username 
order by no_of_photos  desc;

 -- 8) Display the username of each user along with the creation date of
 -- their first posted photo and the creation date of their next posted photo.

select username, created_at,
lag(created_at) over (order by created_at) as first_post, 
lead(created_at) over (order by created_at) as next_post 
from users;

-- 9) For each comment, show the comment text, the username of the commenter,
-- and the comment text of the previous comment made on the same photo.

select  comments.user_id, username, image_url, comment_text, 
lag(comment_text) over (partition by image_url) as previous_comment from comments 
join users on comments.user_id = users.id
join photos on users.id = photos.user_id 
group by  comments.user_id, username, image_url, comment_text ;

 -- 10) Show the username of each user along with the number of photos they have posted and the number of photos posted by the user before them and after them, based on the creation date.

select p.user_id, u.username , count(p.image_url) as no_of_photos,
lag(count(p.image_url)) over(order by 'p.created_at') as before_users ,
lead(count(p.image_url)) over(order by 'p.created_at') as  after_users  from photos p 
join users u on p.user_id = u.id group by p.user_id, u.username;