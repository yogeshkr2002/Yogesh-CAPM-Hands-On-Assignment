using SalesService as service from '../../srv/epm-service';

// ─── LIST REPORT ─────────────────────────────────────────────
annotate service.SalesOrders with @(

  UI.LineItem: [
    { $Type: 'UI.DataField', Value: orderNumber,          Label: 'Order No'      },
    { $Type: 'UI.DataField', Value: customer.customerName, Label: 'Customer'     },
    { $Type: 'UI.DataField', Value: orderDate,            Label: 'Order Date'    },
    { $Type: 'UI.DataField', Value: deliveryDate,         Label: 'Delivery Date' },
    { $Type: 'UI.DataField', Value: grossAmount,          Label: 'Gross Amount'  },
    { $Type: 'UI.DataField', Value: currency_code,        Label: 'Currency'      },
    { $Type: 'UI.DataField', Value: status,               Label: 'Status'        },
    { $Type: 'UI.DataField', Value: priority,             Label: 'Priority'      }
  ],

  UI.SelectionFields: [
    customer_ID,
    status,
    priority,
    orderDate
  ]
);

// ─── OBJECT PAGE ─────────────────────────────────────────────
annotate service.SalesOrders with @(

  UI.HeaderInfo: {
    TypeName      : 'Sales Order',
    TypeNamePlural: 'Sales Orders',
    Title         : { $Type: 'UI.DataField', Value: orderNumber },
    Description   : { $Type: 'UI.DataField', Value: customer.customerName }
  },

  UI.Facets: [
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'OrderInfo',
      Label : 'Order Information',
      Target: '@UI.FieldGroup#OrderInfo'
    },
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'AmountInfo',
      Label : 'Amount Details',
      Target: '@UI.FieldGroup#AmountInfo'
    },
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'OrderItems',
      Label : 'Order Items',
      Target: 'items/@UI.LineItem'
    }
  ],

  UI.FieldGroup #OrderInfo: {
    $Type: 'UI.FieldGroupType',
    Label: 'Order Information',
    Data : [
      { $Type: 'UI.DataField', Value: orderNumber,           Label: 'Order Number'  },
      { $Type: 'UI.DataField', Value: customer.customerName, Label: 'Customer'      },
      { $Type: 'UI.DataField', Value: customer.email,        Label: 'Customer Email'},
      { $Type: 'UI.DataField', Value: orderDate,             Label: 'Order Date'    },
      { $Type: 'UI.DataField', Value: deliveryDate,          Label: 'Delivery Date' },
      { $Type: 'UI.DataField', Value: status,                Label: 'Status'        },
      { $Type: 'UI.DataField', Value: priority,              Label: 'Priority'      }
    ]
  },

  UI.FieldGroup #AmountInfo: {
    $Type: 'UI.FieldGroupType',
    Label: 'Amount Details',
    Data : [
      { $Type: 'UI.DataField', Value: netAmount,   Label: 'Net Amount'   },
      { $Type: 'UI.DataField', Value: taxAmount,   Label: 'Tax Amount'   },
      { $Type: 'UI.DataField', Value: grossAmount, Label: 'Gross Amount' },
      { $Type: 'UI.DataField', Value: currency_code, Label: 'Currency'   }
    ]
  }
);

// ─── ORDER ITEMS TABLE (inside Object Page) ───────────────────
annotate service.SalesOrderItems with @(

  UI.LineItem: [
    { $Type: 'UI.DataField', Value: product.productName, Label: 'Product'      },
    { $Type: 'UI.DataField', Value: quantity,            Label: 'Quantity'     },
    { $Type: 'UI.DataField', Value: unitPrice,           Label: 'Unit Price'   },
    { $Type: 'UI.DataField', Value: netAmount,           Label: 'Net Amount'   },
    { $Type: 'UI.DataField', Value: taxAmount,           Label: 'Tax Amount'   },
    { $Type: 'UI.DataField', Value: grossAmount,         Label: 'Gross Amount' },
    { $Type: 'UI.DataField', Value: currency_code,       Label: 'Currency'     },
    { $Type: 'UI.DataField', Value: deliveryDate,        Label: 'Delivery Date'}
  ]
);

// ─── FIELD LABELS ─────────────────────────────────────────────
annotate service.SalesOrders with {
  orderNumber  @title: 'Order Number';
  orderDate    @title: 'Order Date';
  deliveryDate @title: 'Delivery Date';
  grossAmount  @title: 'Gross Amount';
  netAmount    @title: 'Net Amount';
  taxAmount    @title: 'Tax Amount';
  status       @title: 'Status';
  priority     @title: 'Priority';
  customer     @title: 'Customer';
}

annotate service.SalesOrderItems with {
  quantity     @title: 'Quantity';
  unitPrice    @title: 'Unit Price';
  grossAmount  @title: 'Gross Amount';
  netAmount    @title: 'Net Amount';
  taxAmount    @title: 'Tax Amount';
  deliveryDate @title: 'Delivery Date';
  product      @title: 'Product';
}

// ─── ORDER ITEM OBJECT PAGE ───────────────────────────────────
annotate service.SalesOrderItems with @(

  UI.HeaderInfo: {
    TypeName      : 'Order Item',
    TypeNamePlural: 'Order Items',
    Title         : { $Type: 'UI.DataField', Value: product.productName },
    Description   : { $Type: 'UI.DataField', Value: order.orderNumber }
  },

  UI.Facets: [
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'ItemDetails',
      Label : 'Item Details',
      Target: '@UI.FieldGroup#ItemDetails'
    }
  ],

  UI.FieldGroup #ItemDetails: {
    $Type: 'UI.FieldGroupType',
    Label: 'Item Details',
    Data : [
      { $Type: 'UI.DataField', Value: product.productName, Label: 'Product'       },
      { $Type: 'UI.DataField', Value: quantity,            Label: 'Quantity'      },
      { $Type: 'UI.DataField', Value: unitPrice,           Label: 'Unit Price'    },
      { $Type: 'UI.DataField', Value: netAmount,           Label: 'Net Amount'    },
      { $Type: 'UI.DataField', Value: taxAmount,           Label: 'Tax Amount'    },
      { $Type: 'UI.DataField', Value: grossAmount,         Label: 'Gross Amount'  },
      { $Type: 'UI.DataField', Value: currency_code,       Label: 'Currency'      },
      { $Type: 'UI.DataField', Value: deliveryDate,        Label: 'Delivery Date' }
    ]
  }
);