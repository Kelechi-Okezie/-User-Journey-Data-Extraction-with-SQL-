# -User-Journey-Data-Extraction-with-SQL-
In this project, I will focus on extracting user journey data using SQL. SQL is often used to fetch raw data from storage, which is then transferred to other software for preprocessing. However, SQL can do much more than just selecting data from tables. In many cases, aggregating or preprocessing data directly within SQL is easier and more efficient, which is exactly what I'll be doing here.

The goal of this project is to create a customer journey data extract that serves as the foundation for further analysis. When I mention "user journey," I’m referring to the steps users take while navigating the product or platform before making a purchase. The context is an online subscription-based company that offers monthly, quarterly, and annual plans. In this case, I'll be working with data from the 365 platform.

Using SQL alone, I will consider all users who purchased a plan and aggregate the pages they visited into one continuous sequence or string. This user journey data will be analyzed in a later project.

## DATABASE STRUCTURE
Now, let’s consider the structure and contents of the database (see file in repsitory attachment).

The database consists of three tables: front_interactions , student_purchases , and front_visitors.

The front_interactions  table records all visitor activity on the company’s front page, including visiting specific pages, clicks, and other interactions on said pages. The table consists of the following six fields or columns:

 visitor_id  – (int) the ID number of the visitor
 session_id  – (int) the session number during which the interaction took place
 event_source_url  – (string) the URL of the page on which the given event took place
 event_destination_url   – (string) the URL of the page when the event was completed/processed (for interactions during which the user stays on the same page, this is the same as source URL)
 event_date   – (datetime) the exact timestamp of the event/interaction
 event_name   – (string) an internal name of the event
This table records all events on the front pages—from scrolling to clicking on buttons. The significant aspect regarding this project is that it also records the source and destination URLs for every event. These are the same for such interactions as scrolling or clicking on a form field. But when a visitor clicks on a page link, these two URLs would differ since they moved to a different page. This is what you’ll focus on for this project since we are interested in the sequence of pages in the visitor’s journey.

The next table is student_purchases  which contains records of user payments and the type of product they purchased. This includes all payments—even if they are subsequent recurring payments for the same subscription. Its columns contain the following:

 user_id   – (int) the ID of the user, different from the visitor_id
 purchase_id   – (int) the ID of the purchase
 purchase_type   – (int) the type of subscription purchased (0=monthly, 1=quarterly, 2=annual)
 purchase_price   – (decimal) the price the user paid in dollars
 date_purchased   – (datetime) the exact datetime of the purchase
Notice that since the person needs to have purchased a product to be in this table and has an account, they are no longer considered a visitor but a user. It’s also noteworthy that the purchase price in this table can be used as an indicator for test users. If a user has purchased a product at $0, they’re probably just a test one.

The default sorting for this table is based on date_purchased, from old to new.

The final table front_visitors  is the link between front_interactions and student_purchases. There are only two columns in this table:

 visitor_id   – (int) the ID of the visitor—each record has this field filled in
 user_id   – (int) the ID of the user corresponding to this visitor—many NULL values here because many visitors never made an account and so were never assigned a user_id
From this table, you can determine which user corresponds to which visitor. Just bear in mind that most visitors have never created an account and are not considered users.

These are the general guidelines concerning the database. You can investigate all these specifics in SQL by yourself. (Remember that familiarization with the data you’re working with is an essential and often overlooked first step.)

Finally, to help when coding, you can download an additional file URL_Aliases.xlsx—a reference list with all the URLs you need and suggested aliases for the pages—because you presumably won’t be familiar with all the pages in the dataset.

[URL_Aliases.xlsx](https://github.com/user-attachments/files/17176598/URL_Aliases.xlsx)
