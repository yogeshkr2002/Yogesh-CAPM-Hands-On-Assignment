using { com.epm as db } from '../db/schema';

service AdminService @(path:'/admin') {

    entity Suppliers as projection on db.Suppliers;

    entity Categories as projection on db.Categories;

    entity Products as projection on db.Products;

    entity Customers as projection on db.Customers;

    entity SalesOrders as projection on db.SalesOrders;

    entity SalesOrderItems as projection on db.SalesOrderItems;

    entity PurchaseOrders as projection on db.PurchaseOrders;

    entity PurchaseOrderItems as projection on db.PurchaseOrderItems;
}