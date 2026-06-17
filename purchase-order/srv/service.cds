using mypo from '../db/schema';

service PurchaseOrderService {

    @odata.draft.enabled
    entity PurchaseOrders as projection on mypo.PurchaseOrders
        actions {

            action submitOrder() returns String;

            action approveOrder() returns String;

            action rejectOrder(reason : String) returns String;
        };

    entity POItems as projection on mypo.POItems;

    entity Suppliers as projection on mypo.Suppliers;

    entity Products as projection on mypo.Products;
}
