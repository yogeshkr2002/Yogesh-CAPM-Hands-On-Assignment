namespace mypo;

using { cuid, managed } from '@sap/cds/common';

entity Suppliers : cuid, managed {
    name        : String(100);
    city        : String(50);
    country     : String(50);
}

entity Products : cuid, managed {
    name        : String(100);
    price       : Decimal(15,2);
    stock       : Integer;
}

entity PurchaseOrders : cuid, managed {
    poNumber        : String(20);
    supplier        : Association to Suppliers;
    orderDate       : Date;
    status          : String(20);
    totalAmount     : Decimal(15,2);

    items           : Composition of many POItems
                        on items.parent = $self;
}

entity POItems : cuid, managed {
    parent          : Association to PurchaseOrders;
    product         : Association to Products;

    quantity        : Integer;
    unitPrice       : Decimal(15,2);
    amount          : Decimal(15,2);
}