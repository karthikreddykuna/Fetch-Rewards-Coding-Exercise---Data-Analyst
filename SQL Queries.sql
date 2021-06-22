--SQL Queries were executed in pgAdmin 4 SQL dialect. 

--What are the top 5 brands by receipts scanned for most recent month?

SELECT b.name AS top_brands
FROM brands b
JOIN rewardsreceiptitemlist reward ON b.barcode= reward.barcode
JOIN receipts recp ON recp.receipt_id = reward.receipt_id
WHERE EXTRACT(MONTH FROM recp.datescanned) = (select EXTRACT(MONTH FROM recp.datescanned) ORDER BY EXTRACT(MONTH FROM datescanned) DESC LIMIT 1)
GROUP BY top_brands
ORDER BY count(recp.receipt_id) DESC
LIMIT 5;

-- When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?

SELECT rewardsreceiptstatus AS reward_receipt_status, AVG(totalSpent) AS average_spend_receipts
FROM receipts where rewardsreceiptstatus='FINISHED' or rewardsreceiptstatus='REJECTED'
GROUP BY reward_receipt_status
ORDER BY average_spend_receipts DESC
LIMIT 1;

-- When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?

SELECT rewardsreceiptstatus AS reward_receipt_status, SUM(purchasedItemCount) AS num_of_purchased_items
FROM receipts where rewardsreceiptstatus='FINISHED' or rewardsreceiptstatus='REJECTED'
GROUP BY reward_receipt_status
ORDER BY num_of_purchased_items DESC
LIMIT 1;

-- Which brand has the most spend among users who were created within the past 6 months?

SELECT b.name, SUM(totalSpent) AS total_spent
FROM brands b
JOIN rewardsReceiptItemList reward ON b.barcode= reward.barcode
JOIN receipts recp ON recp.receipt_id= reward.receipt_id
JOIN users u ON u.user_id= recp.userId
WHERE u.createddate > (select MAX(createddate) FROM users ORDER BY MAX(createddate) DESC) - INTERVAL '6 months'
GROUP BY b.name
ORDER BY total_spent DESC
LIMIT 1;

-- Which brand has the most transactions among users who were created within the past 6 months?

SELECT b.name, COUNT(recp.userId) AS number_of_transactions
FROM brands b
JOIN rewardsReceiptItemList reward ON b.barcode= reward.barcode
JOIN receipts recp ON recp.receipt_id= reward.receipt_id
JOIN users u ON u.user_id= recp.userId
WHERE u.createddate > (select MAX(createddate) FROM users ORDER BY MAX(createddate) DESC) - INTERVAL '6 months'
GROUP BY b.name
ORDER BY number_of_transactions DESC
LIMIT 1;
