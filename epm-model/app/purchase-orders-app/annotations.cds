using ProcurementService as service from '../../srv/epm-service';

// ─── LIST REPORT ─────────────────────────────────────────────
annotate service.PurchaseOrders with @(

  UI.LineItem: [
    { $Type: 'UI.DataField', Value: poNumber,             Label: 'PO Number'     },
    { $Type: 'UI.DataField', Value: supplier.supplierName, Label: 'Supplier'     },
    { $Type: 'UI.DataField', Value: orderDate,            Label: 'Order Date'    },
    { $Type: 'UI.DataField', Value: grossAmount,          Label: 'Gross Amount'  },
    { $Type: 'UI.DataField', Value: netAmount,            Label: 'Net Amount'    },
    { $Type: 'UI.DataField', Value: currency_code,        Label: 'Currency'      },
    { $Type: 'UI.DataField', Value: status,               Label: 'Status'        }
  ],

  UI.SelectionFields: [
    supplier_ID,
    status,
    orderDate
  ]
);

// ─── OBJECT PAGE ─────────────────────────────────────────────
annotate service.PurchaseOrders with @(

  UI.HeaderInfo: {
    TypeName      : 'Purchase Order',
    TypeNamePlural: 'Purchase Orders',
    Title         : { $Type: 'UI.DataField', Value: poNumber },
    Description   : { $Type: 'UI.DataField', Value: supplier.supplierName }
  },

  UI.Facets: [
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'POInfo',
      Label : 'Order Information',
      Target: '@UI.FieldGroup#POInfo'
    },
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'AmountInfo',
      Label : 'Amount Details',
      Target: '@UI.FieldGroup#AmountInfo'
    },
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'POItems',
      Label : 'Order Items',
      Target: 'items/@UI.LineItem'
    }
  ],

  UI.FieldGroup #POInfo: {
    $Type: 'UI.FieldGroupType',
    Label: 'Order Information',
    Data : [
      { $Type: 'UI.DataField', Value: poNumber,              Label: 'PO Number'      },
      { $Type: 'UI.DataField', Value: supplier.supplierName, Label: 'Supplier'       },
      { $Type: 'UI.DataField', Value: supplier.email,        Label: 'Supplier Email' },
      { $Type: 'UI.DataField', Value: supplier.city,         Label: 'Supplier City'  },
      { $Type: 'UI.DataField', Value: orderDate,             Label: 'Order Date'     },
      { $Type: 'UI.DataField', Value: status,                Label: 'Status'         }
    ]
  },

  UI.FieldGroup #AmountInfo: {
    $Type: 'UI.FieldGroupType',
    Label: 'Amount Details',
    Data : [
      { $Type: 'UI.DataField', Value: netAmount,    Label: 'Net Amount'   },
      { $Type: 'UI.DataField', Value: grossAmount,  Label: 'Gross Amount' },
      { $Type: 'UI.DataField', Value: currency_code, Label: 'Currency'    }
    ]
  }
);

// ─── PO ITEMS TABLE (inside Object Page) ─────────────────────
annotate service.PurchaseOrderItems with @(

  UI.LineItem: [
    { $Type: 'UI.DataField', Value: product.productName, Label: 'Product'       },
    { $Type: 'UI.DataField', Value: quantity,            Label: 'Quantity'      },
    { $Type: 'UI.DataField', Value: unitPrice,           Label: 'Unit Price'    },
    { $Type: 'UI.DataField', Value: grossAmount,         Label: 'Gross Amount'  },
    { $Type: 'UI.DataField', Value: currency_code,       Label: 'Currency'      },
    { $Type: 'UI.DataField', Value: deliveryDate,        Label: 'Delivery Date' }
  ],

  UI.HeaderInfo: {
    TypeName      : 'PO Item',
    TypeNamePlural: 'PO Items',
    Title         : { $Type: 'UI.DataField', Value: product.productName },
    Description   : { $Type: 'UI.DataField', Value: order.poNumber }
  },

  UI.Facets: [
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'POItemDetails',
      Label : 'Item Details',
      Target: '@UI.FieldGroup#POItemDetails'
    }
  ],

  UI.FieldGroup #POItemDetails: {
    $Type: 'UI.FieldGroupType',
    Label: 'Item Details',
    Data : [
      { $Type: 'UI.DataField', Value: product.productName, Label: 'Product'       },
      { $Type: 'UI.DataField', Value: quantity,            Label: 'Quantity'      },
      { $Type: 'UI.DataField', Value: unitPrice,           Label: 'Unit Price'    },
      { $Type: 'UI.DataField', Value: grossAmount,         Label: 'Gross Amount'  },
      { $Type: 'UI.DataField', Value: currency_code,       Label: 'Currency'      },
      { $Type: 'UI.DataField', Value: deliveryDate,        Label: 'Delivery Date' }
    ]
  }
);

// ─── FIELD LABELS ─────────────────────────────────────────────
annotate service.PurchaseOrders with {
  poNumber    @title: 'PO Number';
  orderDate   @title: 'Order Date';
  grossAmount @title: 'Gross Amount';
  netAmount   @title: 'Net Amount';
  status      @title: 'Status';
  supplier    @title: 'Supplier';
}

annotate service.PurchaseOrderItems with {
  quantity    @title: 'Quantity';
  unitPrice   @title: 'Unit Price';
  grossAmount @title: 'Gross Amount';
  deliveryDate @title: 'Delivery Date';
  product     @title: 'Product';
}