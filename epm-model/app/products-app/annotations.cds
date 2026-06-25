using MasterDataService as service from '../../srv/epm-service';

// ─── LIST REPORT ─────────────────────────────────────────────
annotate service.Products with @(

  UI.LineItem: [
    { $Type: 'UI.DataField', Value: productName,           Label: 'Product Name' },
    { $Type: 'UI.DataField', Value: description,           Label: 'Description'  },
    { $Type: 'UI.DataField', Value: price,                 Label: 'Price'        },
    { $Type: 'UI.DataField', Value: currency_code,         Label: 'Currency'     },
    { $Type: 'UI.DataField', Value: stock,                 Label: 'Stock'        },
    { $Type: 'UI.DataField', Value: supplier.supplierName, Label: 'Supplier'     },
    { $Type: 'UI.DataField', Value: category.categoryName, Label: 'Category'     },
    { $Type: 'UI.DataField', Value: isAvailable,           Label: 'Available'    }
  ],

  UI.SelectionFields: [
    supplier_ID,
    category_ID,
    isAvailable
  ]
);

// ─── OBJECT PAGE ─────────────────────────────────────────────
annotate service.Products with @(

  UI.HeaderInfo: {
    TypeName      : 'Product',
    TypeNamePlural: 'Products',
    Title         : { $Type: 'UI.DataField', Value: productName },
    Description   : { $Type: 'UI.DataField', Value: description }
  },

  UI.Facets: [
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'GeneralInfo',
      Label : 'General Information',
      Target: '@UI.FieldGroup#GeneralInfo'
    },
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'PricingInfo',
      Label : 'Pricing & Stock',
      Target: '@UI.FieldGroup#PricingInfo'
    },
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'SupplierInfo',
      Label : 'Supplier & Category',
      Target: '@UI.FieldGroup#SupplierInfo'
    }
  ],

  UI.FieldGroup #GeneralInfo: {
    $Type: 'UI.FieldGroupType',
    Label: 'General Information',
    Data : [
      { $Type: 'UI.DataField', Value: productName, Label: 'Product Name' },
      { $Type: 'UI.DataField', Value: description, Label: 'Description'  },
      { $Type: 'UI.DataField', Value: isAvailable, Label: 'Available'    },
      { $Type: 'UI.DataField', Value: weight,      Label: 'Weight'       },
      { $Type: 'UI.DataField', Value: weightUnit,  Label: 'Weight Unit'  }
    ]
  },

  UI.FieldGroup #PricingInfo: {
    $Type: 'UI.FieldGroupType',
    Label: 'Pricing & Stock',
    Data : [
      { $Type: 'UI.DataField', Value: price,        Label: 'Price'         },
      { $Type: 'UI.DataField', Value: currency_code, Label: 'Currency'     },
      { $Type: 'UI.DataField', Value: stock,        Label: 'Current Stock' },
      { $Type: 'UI.DataField', Value: minStock,     Label: 'Min Stock'     }
    ]
  },

  UI.FieldGroup #SupplierInfo: {
    $Type: 'UI.FieldGroupType',
    Label: 'Supplier & Category',
    Data : [
      { $Type: 'UI.DataField', Value: supplier.supplierName, Label: 'Supplier'              },
      { $Type: 'UI.DataField', Value: supplier.email,        Label: 'Supplier Email'        },
      { $Type: 'UI.DataField', Value: supplier.city,         Label: 'Supplier City'         },
      { $Type: 'UI.DataField', Value: category.categoryName, Label: 'Category'              },
      { $Type: 'UI.DataField', Value: category.description,  Label: 'Category Description'  }
    ]
  }
);

// ─── FIELD LABELS ─────────────────────────────────────────────
annotate service.Products with {
  productName  @title: 'Product Name';
  description  @title: 'Description';
  price        @title: 'Price';
  stock        @title: 'Stock';
  minStock     @title: 'Min Stock';
  weight       @title: 'Weight';
  weightUnit   @title: 'Weight Unit';
  isAvailable  @title: 'Available';
  supplier     @title: 'Supplier';
  category     @title: 'Category';
}