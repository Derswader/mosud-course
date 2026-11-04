<img width="443" height="422" alt="Снимок экрана 2026-11-04 193132" src="https://github.com/user-attachments/assets/5f62e6ce-5e64-490f-83ab-69ce9dcdd70c" />

Каждый комплект должен иметь уникальный код.	uq_bundle_code — UNIQUE
Каждый комплект должен принадлежать существующему продавцу из Olist.	fk_bundle_seller — FOREIGN KEY
Комплект может иметь только статус active или inactive.	ck_bundle_status — CHECK
Каждый товар в комплекте должен существовать в таблице товаров Olist.	fk_item_product — FOREIGN KEY
Каждый товар должен относиться к существующему комплекту.	fk_item_bundle — FOREIGN KEY
Один и тот же товар не может повторяться в одном комплекте, но может входить в разные комплекты.	pk_bundle_items — составной PRIMARY KEY
Количество каждого товара в комплекте должно быть больше нуля.	ck_item_quantity — CHECK
Цена комплекта должна быть положительной.	ck_bundle_price — CHECK
Для одного комплекта не может существовать две цены с одинаковой датой начала действия.	uq_bundle_price_date — составной UNIQUE
Дата окончания действия цены не может быть раньше даты начала.	ck_price_dates — CHECK
