
-- кол-во строк по таблицам

SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM olist.customers
UNION ALL
SELECT 'geolocation', COUNT(*)
FROM olist.geolocation
UNION ALL
SELECT 'orders', COUNT(*)
FROM olist.orders
UNION ALL
SELECT 'order_items', COUNT(*)
FROM olist.order_items
UNION ALL
SELECT 'order_payments', COUNT(*)
FROM olist.order_payments
UNION ALL
SELECT 'order_reviews', COUNT(*)
FROM olist.order_reviews
UNION ALL
SELECT 'products', COUNT(*)
FROM olist.products
UNION ALL
SELECT 'sellers', COUNT(*)
FROM olist.sellers
UNION ALL
SELECT 'product_category_name_translation', COUNT(*)
FROM olist.product_category_name_translation;


-- null по таблицам

SELECT 'customers.customer_id' AS field, COUNT(*) AS null_count
FROM olist.customers
WHERE customer_id IS NULL
UNION ALL
SELECT 'geolocation.geolocation_zip_code_prefix', COUNT(*)
FROM olist.geolocation
WHERE geolocation_zip_code_prefix IS NULL
UNION ALL
SELECT 'orders.order_id', COUNT(*)
FROM olist.orders
WHERE order_id IS NULL
UNION ALL
SELECT 'orders.customer_id', COUNT(*)
FROM olist.orders
WHERE customer_id IS NULL
UNION ALL
SELECT 'order_items.order_id', COUNT(*)
FROM olist.order_items
WHERE order_id IS NULL
UNION ALL
SELECT 'order_items.order_item_id', COUNT(*)
FROM olist.order_items
WHERE order_item_id IS NULL
UNION ALL
SELECT 'order_items.product_id', COUNT(*)
FROM olist.order_items
WHERE product_id IS NULL
UNION ALL
SELECT 'order_items.seller_id', COUNT(*)
FROM olist.order_items
WHERE seller_id IS NULL
UNION ALL
SELECT 'order_payments.order_id', COUNT(*)
FROM olist.order_payments
WHERE order_id IS NULL
UNION ALL
SELECT 'order_payments.payment_sequential', COUNT(*)
FROM olist.order_payments
WHERE payment_sequential IS NULL
UNION ALL
SELECT 'order_reviews.review_id', COUNT(*)
FROM olist.order_reviews
WHERE review_id IS NULL
UNION ALL
SELECT 'order_reviews.order_id', COUNT(*)
FROM olist.order_reviews
WHERE order_id IS NULL
UNION ALL
SELECT 'products.product_id', COUNT(*)
FROM olist.products
WHERE product_id IS NULL
UNION ALL
SELECT 'sellers.seller_id', COUNT(*)
FROM olist.sellers
WHERE seller_id IS NULL
UNION ALL
SELECT 'product_category_name_translation.product_category_name', COUNT(*)
FROM olist.product_category_name_translation
WHERE product_category_name IS NULL;


-- проверка null при соединении

SELECT 'orders -> customers' AS relation, COUNT(*) AS orphan_count
FROM olist.orders o
LEFT JOIN olist.customers c
    ON o.customer_id = c.customer_id
WHERE o.customer_id IS NOT NULL
    AND c.customer_id IS NULL

UNION ALL

SELECT 'order_items -> orders', COUNT(*)
FROM olist.order_items i
LEFT JOIN olist.orders o
    ON i.order_id = o.order_id
WHERE i.order_id IS NOT NULL
    AND o.order_id IS NULL

UNION ALL

SELECT 'order_items -> products', COUNT(*)
FROM olist.order_items i
LEFT JOIN olist.products p
    ON i.product_id = p.product_id
WHERE i.product_id IS NOT NULL
    AND p.product_id IS NULL

UNION ALL

SELECT 'order_items -> sellers', COUNT(*)
FROM olist.order_items i
LEFT JOIN olist.sellers s
    ON i.seller_id = s.seller_id
WHERE i.seller_id IS NOT NULL
    AND s.seller_id IS NULL

UNION ALL

SELECT 'order_payments -> orders', COUNT(*)
FROM olist.order_payments p
LEFT JOIN olist.orders o
    ON p.order_id = o.order_id
WHERE p.order_id IS NOT NULL
    AND o.order_id IS NULL

UNION ALL

SELECT 'order_reviews -> orders', COUNT(*)
FROM olist.order_reviews r
LEFT JOIN olist.orders o
    ON r.order_id = o.order_id
WHERE r.order_id IS NOT NULL
    AND o.order_id IS NULL;


-- ANALYZE

ANALYZE olist.customers;
ANALYZE olist.geolocation;
ANALYZE olist.orders;
ANALYZE olist.order_items;
ANALYZE olist.order_payments;
ANALYZE olist.order_reviews;
ANALYZE olist.products;
ANALYZE olist.sellers;
ANALYZE olist.product_category_name_translation;
