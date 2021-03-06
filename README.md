
<!-- Add banner here -->



![Banner](https://github.com/hbeltrao/Olist-EDA-Project/blob/a75d2049dbdce4ebe1e73fe9f9c8066b17eb5e40/README-header.png)





# Diving into Brazilian E-Commerce Public Dataset by Olist using SQL and Python



<!-- Add buttons here -->



![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/hbeltrao/Olist-EDA-Project?include_prereleases)
![GitHub last commit](https://img.shields.io/github/last-commit/hbeltrao/Olist-EDA-Project)
![GitHub issues](https://img.shields.io/github/issues-raw/hbeltrao/Olist-EDA-Project)
![GitHub pull requests](https://img.shields.io/github/issues-pr/hbeltrao/Olist-EDA-Project)
![GitHub](https://img.shields.io/github/license/hbeltrao/Olist-EDA-Project)



<!-- Describe your project in brief -->



In this project we will dive into the Olist E-Commerce database and perform a series of analysis to extract business related information such as :

- Order shipping performance: 
	 - Delay on shippment or on delivery;
	 - freight values;
- Order review analysis:
	- Sentiment analisys;
	- review score vs order value and delivery delays;
- Customer profile:
	- customer distribution by city and state;
	- average order ticket per customer per region;
- Purchase analysis:
	- orders per city-state;
	- payment analysis;
- Sellers performance:
	- top sellers and best reviewed;
- Product analysis:
	- products with most orders;
	- top products by selling and reviews;



# Table of contents



- [Title](#diving-into-brazilian-e-commerce-public-dataset-by-olist-using-sql-and-python)

- [Table of contents](#table-of-contents)

- [Database Context and structure](#database-context-and-structure)

- [Methodology](#methodology)

- [Customers and sellers demography](#customers-and-sellers-demography)

- [Order shipping and delivery performance](#order-shipping-and-delivery-performance)

- [License](#license)

- [Footer](#footer)



# Database Context and structure

[(Back to top)](#table-of-contents)



The database used in this project was published by an E-Commerce platform from Brazil called Olist and contains   data from orders made in their platform between 2016 and 2018 and is avaliable on kaggle in the following link:
https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

All data has been pre-processed, cleaned and anonymised by Olist before publishing the database, and references to the companies and partners in the review text have been replaced with the names of Game of Thrones great houses.


The data is distributed through 8 tables connected following the Data Schema showed on Figure-1:

 1. olist_customers_dataset
 2. olist_geolocation_dataset
 3. olist_order_items_dataset
 4. olist_order_payments_dataset
 5. olist_order_reviews_dataset
 6. olist_orders_dataset
 7. olist_products_dataset
 8. olist_sellers_dataset

![Figure-1](https://github.com/hbeltrao/Olist-EDA-Project/blob/a75d2049dbdce4ebe1e73fe9f9c8066b17eb5e40/Data%20Schema.png)




# Methodology

[(Back to top)](#table-of-contents)



For each topic of the introduction, we will try to use the following Data Analysis Framework:

![Figure-2](https://github.com/hbeltrao/Olist-EDA-Project/blob/197e8354d87b4030909f9eba5341f76a7d480ab1/data%20analysis%20framework.png)

All data was stored in a MySQL database and the access  made via SQL queries directly through python code on the jupyter notebooks.

Anomymization was already done by the dataset owner so this step was skipped.

No extra data was necesary to perform the analysis on this project.

Each process of cleaning, filtering and transforming is explained inside each notebook alongside its code.

The main tools and libraries used were:

 - MySQL Workbench (develop and tes all queries);
 - Jupyter Notebook (document all steps and process all codes)
 - Pandas, Matplotlib and Seaborn (data manipulation and graph creation)
 - 



# Customers and sellers demography

[(Back to top)](#table-of-contents)


Before beginning to explore operation performance characteristics such as delivery performance, top selling products, order review and impacts of delays on customer satisfaction, is better to have an overview of the distribution of customers and sellers in order to have a better understanding on the Olist commercial positioning and analyze possible improvements on logistics strategy to increase marketshare and customer satisfaction based on operation performance and customer feedback.

Following there is the demographic distribution of customers, sellers, orders and revenue:
<!-- 
![Figure-3](brazil map of customer  distribution)
![Figure-4](brazil map of seller  distribution)
![Figure-5](brazil map of sales  distribution)
![Figure-6](brazil map of revenue  distribution)
-->
 


# Order shipping and delivery performance

[(Back to top)](#table-of-contents)



As one of the biggest challenges (if not the biggest) of e-commerce, delivery time and cost impact a lot on any online company's performance.

This way, let's explore the performance of the platforms shipping and delivery process by answering the following questions:

	1. How many orders were shipped with delay?
	2. What are the regions with most delays?
	3. Are there any seller with high delay rate?
	4. How many orders were delivered with delay?
	5. How shipping delay impacts delivery performance?
	6. Are there any relation between delivery delay and the distance between sellers and customers?
	7. How does freight value behaves among states?

The jupyter notebook  "Order shipping and delivery performance" navigate through these questions, with answers and insights



# License

[(Back to top)](#table-of-contents)



<!-- Adding the license to README is a good practice so that people can easily refer to it.



Make sure you have added a LICENSE file in your project folder. **Shortcut:** Click add new file in your root of your repo in GitHub > Set file name to LICENSE > GitHub shows LICENSE templates > Choose the one that best suits your project!



I personally add the name of the license and provide a link to it like below. -->



[GNU General Public License version 3](https://opensource.org/licenses/GPL-3.0)



# Footer

[(Back to top)](#table-of-contents)



<!-- Let's also add a footer because I love footers and also you **can** use this to convey important info.



Let's make it an image because by now you have realised that multimedia in images == cool(*please notice the subtle programming joke). -->



Leave a star in GitHub, give a clap in Medium and share this guide if you found this helpful.



<!-- Add the footer here -->



<!-- ![Footer](https://github.com/navendu-pottekkat/awesome-readme/blob/master/fooooooter.png) -->
