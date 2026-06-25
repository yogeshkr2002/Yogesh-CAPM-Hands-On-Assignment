using { com.epm as db } from '../db/schema';

// ─── Master Data Service ──────────────────────────
// For admins: manage suppliers, categories, products
service MasterDataService @(path: '/master-data') {

  entity Suppliers   as projection on db.Suppliers;
  entity Categories  as projection on db.Categories;
  entity Products    as projection on db.Products;
}

// ─── Sales Service ───────────────────────────────
// For sales team: manage customers and orders
service SalesService @(path: '/sales') {

  entity Customers        as projection on db.Customers;
  entity SalesOrders      as projection on db.SalesOrders;
  entity SalesOrderItems  as projection on db.SalesOrderItems;

  @readonly
  entity Products         as projection on db.Products;
}

// ─── Procurement Service ─────────────────────────
// For procurement team: manage suppliers and purchase orders
service ProcurementService @(path: '/procurement') {

  entity Suppliers          as projection on db.Suppliers;
  entity PurchaseOrders     as projection on db.PurchaseOrders;
  entity PurchaseOrderItems as projection on db.PurchaseOrderItems;

  @readonly
  entity Products           as projection on db.Products;
  
  @readonly
  entity Stock              as projection on db.Stock;
}