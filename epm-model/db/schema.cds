using { cuid, managed, Currency, Country } from '@sap/cds/common';

namespace com.epm;

// ─── SUPPLIERS ───────────────────────────────────
entity Suppliers : cuid, managed {
  supplierName  : String(100);
  contactPerson : String(100);
  email         : String(255);
  phone         : String(20);
  street        : String(200);
  city          : String(100);
  state         : String(50);
  pincode       : String(10);
  country       : Country;
  isActive      : Boolean default true;
  products      : Association to many Products on products.supplier = $self;
}

// ─── PRODUCT CATEGORIES ──────────────────────────
entity Categories : cuid, managed {
  categoryName   : String(100);
  description    : String(500);
  parentCategory : Association to Categories;
  products       : Association to many Products on products.category = $self;
}

// ─── PRODUCTS ────────────────────────────────────
entity Products : cuid, managed {
  productName  : String(100);
  description  : String(500);
  price        : Decimal(10,2);
  currency     : Currency;
  weight       : Decimal(8,3);
  weightUnit   : String(5) default 'KG';
  stock        : Integer default 0;
  minStock     : Integer default 10;
  supplier     : Association to Suppliers;
  category     : Association to Categories;
  isAvailable  : Boolean default true;
}

// ─── CUSTOMERS ───────────────────────────────────
entity Customers : cuid, managed {
  customerName : String(100);
  email        : String(255);
  phone        : String(20);
  street       : String(200);
  city         : String(100);
  state        : String(50);
  pincode      : String(10);
  country      : Country;
  creditLimit  : Decimal(12,2) default 100000;
  orders       : Association to many SalesOrders on orders.customer = $self;
}

// ─── SALES ORDERS ────────────────────────────────
entity SalesOrders : cuid, managed {
  orderNumber  : String(20);
  customer     : Association to Customers;
  orderDate    : Date;
  deliveryDate : Date;
  grossAmount  : Decimal(12,2);
  netAmount    : Decimal(12,2);
  taxAmount    : Decimal(10,2);
  currency     : Currency;
  status       : String(20) default 'New';
  priority     : String(10) default 'Medium';
  items        : Composition of many SalesOrderItems on items.order = $self;
}

// ─── SALES ORDER ITEMS ───────────────────────────
entity SalesOrderItems : cuid {
  order        : Association to SalesOrders;
  product      : Association to Products;
  quantity     : Integer;
  unitPrice    : Decimal(10,2);
  grossAmount  : Decimal(12,2);
  netAmount    : Decimal(12,2);
  taxAmount    : Decimal(10,2);
  currency     : Currency;
  deliveryDate : Date;
}

// ─── PURCHASE ORDERS ─────────────────────────────
entity PurchaseOrders : cuid, managed {
  poNumber     : String(20);
  supplier     : Association to Suppliers;
  orderDate    : Date;
  grossAmount  : Decimal(12,2);
  netAmount    : Decimal(12,2);
  currency     : Currency;
  status       : String(20) default 'Draft';
  items        : Composition of many PurchaseOrderItems on items.order = $self;
}

// ─── PURCHASE ORDER ITEMS ────────────────────────
entity PurchaseOrderItems : cuid {
  order        : Association to PurchaseOrders;
  product      : Association to Products;
  quantity     : Integer;
  unitPrice    : Decimal(10,2);
  grossAmount  : Decimal(12,2);
  currency     : Currency;
  deliveryDate : Date;
}

// ─── STOCK ───────────────────────────────────────
entity Stock : managed {
  key product   : Association to Products;
  key warehouse : String(20);
  quantity      : Integer;
  minQuantity   : Integer default 10;
  lastUpdated   : DateTime;
}