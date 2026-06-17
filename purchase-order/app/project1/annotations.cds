using PurchaseOrderService as service from '../../srv/service';

// ─────────────────────────────────────────────
// Exercise 2: Centralized field titles (@title)
// ─────────────────────────────────────────────
annotate service.PurchaseOrders with {
    poNumber    @title: 'PO Number';
    status      @title: 'Status';
    totalAmount @title: 'Total Amount';
    orderDate   @title: 'Order Date';
}

annotate service.POItems with {
    quantity  @title: 'Quantity';
    unitPrice @title: 'Unit Price';
    amount    @title: 'Amount';
}

annotate service.Products with {
    name  @title: 'Product Name';
    price @title: 'Price';
    stock @title: 'Stock';
}

annotate service.Suppliers with {
    name    @title: 'Supplier Name';
    city    @title: 'City';
    country @title: 'Country';
}

// ─────────────────────────────────────────────
// PurchaseOrders — main annotations
// ─────────────────────────────────────────────
annotate service.PurchaseOrders with @(

    UI.HeaderInfo : {
        TypeName       : 'Purchase Order',
        TypeNamePlural : 'Purchase Orders',
        Title          : { Value : poNumber },
        Description    : { Value : status }
    },

    UI.SelectionFields : [
        poNumber,
        supplier_ID,
        status
    ],

    UI.LineItem : [
        { Value : poNumber,      Label : 'PO Number'    },
        { Value : supplier.name, Label : 'Supplier'     },
        {
            Value       : status,
            Label       : 'Status',
            Criticality : criticality
        },
        { Value : totalAmount,   Label : 'Total Amount' }
    ],

    UI.Identification : [
        {
            $Type  : 'UI.DataFieldForAction',
            Action : 'PurchaseOrderService.submitOrder',
            Label  : 'Submit'
        },
        {
            $Type  : 'UI.DataFieldForAction',
            Action : 'PurchaseOrderService.approveOrder',
            Label  : 'Approve'
        },
        {
            $Type  : 'UI.DataFieldForAction',
            Action : 'PurchaseOrderService.rejectOrder',
            Label  : 'Reject'
        }
    ],

    UI.Facets : [
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'GeneralInfoSection',
            Label  : 'General Information',
            Target : '@UI.FieldGroup#General'
        },
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'ItemsSection',
            Label  : 'Items',
            Target : 'items/@UI.LineItem'
        }
    ],

    UI.FieldGroup #General : {
        Label : 'General Information',
        Data  : [
            { Value : poNumber    },
            { Value : orderDate   },
            { Value : status      },
            { Value : totalAmount }
        ]
    }

) {
    supplier @(
        Common.Text            : supplier.name,
        Common.TextArrangement : #TextOnly,
        Common.ValueList : {
            CollectionPath : 'Suppliers',
            Parameters : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : supplier_ID,
                    ValueListProperty : 'ID'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'name'
                }
            ]
        }
    );

    poNumber    @Common.FieldControl : UIEditable;
    totalAmount @UI.DataPoint        : { Title : 'Total Amount' };
    status      @UI.Criticality      : criticality;
};

// ─────────────────────────────────────────────
// POItems — main annotations
// ─────────────────────────────────────────────
annotate service.POItems with @(

    UI.LineItem : [
        { Value : product.name, Label : 'Product'    },
        { Value : quantity,     Label : 'Quantity'   },
        { Value : unitPrice,    Label : 'Unit Price' },
        { Value : amount,       Label : 'Amount'     }
    ],

    Common.SideEffects #Recalc : {
        SourceProperties : [ quantity ],
        TargetProperties : [ amount   ]
    },

    // ── Sub Object Page annotations ──────────
    UI.HeaderInfo : {
        TypeName       : 'Order Item',
        TypeNamePlural : 'Order Items',
        Title          : { Value : product.name },
        Description    : { Value : quantity }
    },

    UI.Facets : [
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'ItemDetailSection',
            Label  : 'Item Details',
            Target : '@UI.FieldGroup#ItemDetails'
        },
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'ProductInfoSection',
            Label  : 'Product Information',
            Target : '@UI.FieldGroup#ProductInfo'
        }
    ],

    UI.FieldGroup #ItemDetails : {
        Label : 'Item Details',
        Data  : [
            { Value : quantity,  Label : 'Quantity'   },
            { Value : unitPrice, Label : 'Unit Price' },
            { Value : amount,    Label : 'Total Amount' }
        ]
    },

    UI.FieldGroup #ProductInfo : {
        Label : 'Product Information',
        Data  : [
            { Value : product.name,  Label : 'Product Name' },
            { Value : product.price, Label : 'List Price'   },
            { Value : product.stock, Label : 'Stock Level'  }
        ]
    }

) {
    product @(
        Common.Text            : product.name,
        Common.TextArrangement : #TextOnly,
        Common.ValueList : {
            CollectionPath : 'Products',
            Parameters : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : product_ID,
                    ValueListProperty : 'ID'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'name'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'price'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'stock'
                }
            ]
        }
    );
};