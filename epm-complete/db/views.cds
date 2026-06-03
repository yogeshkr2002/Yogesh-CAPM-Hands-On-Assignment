namespace com.epm;

using { com.epm as db } from './schema';

entity ProductCatalog as select from db.Products {
    ID,
    name,
    price,
    supplier.name as supplierName,
    category.name as categoryName,
    stock
};

entity OrderReport as select from db.SalesOrders {
    orderNumber,
    customer.name as customerName,
    totalAmount,
    orderDate,
    status
};

entity LowStockAlert as select from db.Products {
    ID,
    name,
    stock,
    minStock,
    supplier.name as supplierName,
    supplier.contact as supplierContact
}
where stock <= minStock;