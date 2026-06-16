using { com.epm as db } from '../db/schema';

service SalesService @(path:'/sales') {

    entity Products as projection on db.Products;

    entity Customers as projection on db.Customers;

    entity SalesOrders as projection on db.SalesOrders
actions {

    action confirm() returns {
        status  : String(20);
        message : String(200);
    };

    action cancel(
        reason : String(500)
    ) returns {
        status  : String(20);
        message : String(200);
    };

    action ship(
        trackingNumber : String(50),
        carrier        : String(50)
    ) returns {
        status             : String(20);
        message            : String(200);
        estimatedDelivery  : Date;
    };

};

    entity SalesOrderItems as projection on db.SalesOrderItems;

    entity Suppliers as projection on db.Suppliers;

    entity Categories as projection on db.Categories;
}