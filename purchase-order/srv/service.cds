using mypo from '../db/schema';

@path: 'purchase-order'
@requires: 'authenticated-user'
service PurchaseOrderService {

    @odata.draft.enabled
    @restrict: [
        { grant: 'READ',                        to: 'Viewer' },
        { grant: ['READ', 'CREATE', 'UPDATE'],  to: 'PurchaseManager' },
        { grant: '*',                            to: 'Administrator' }
    ]
    entity PurchaseOrders as projection on mypo.PurchaseOrders
        actions {
            @requires: 'PurchaseManager'
            action submitOrder()               returns String;

            @requires: 'PurchaseManager'
            action approveOrder()              returns String;

            @requires: 'PurchaseManager'
            action rejectOrder(reason: String) returns String;
        };

    @restrict: [
        { grant: 'READ',                        to: 'Viewer' },
        { grant: ['READ', 'CREATE', 'UPDATE'],  to: 'PurchaseManager' },
        { grant: '*',                            to: 'Administrator' }
    ]
    entity POItems as projection on mypo.POItems;

    @requires: 'Administrator'
    entity Suppliers as projection on mypo.Suppliers;

    @restrict: [
        { grant: 'READ', to: ['Viewer', 'PurchaseManager', 'Administrator'] },
        { grant: '*',    to: 'Administrator' }
    ]
    entity Products as projection on mypo.Products;
}