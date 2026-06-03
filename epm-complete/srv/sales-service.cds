using { com.epm as db } from '../db/schema';

service SalesService @(path:'/sales') {

    entity Products as projection on db.Products;

    entity Customers as projection on db.Customers;

    entity SalesOrders as projection on db.SalesOrders;

    entity SalesOrderItems as projection on db.SalesOrderItems;
}