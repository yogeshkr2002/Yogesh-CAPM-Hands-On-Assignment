using SalesService as service from '../../srv/sales-service';
annotate service.Products with @(
    UI.HeaderInfo : {
        TypeName : 'Product',
        TypeNamePlural : 'Products',
        Title : {
        Value : name
        },
        Description : {
            Value : description
        }
},
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'name',
                Value : name,
            },
            {
                $Type : 'UI.DataField',
                Label : 'description',
                Value : description,
            },
            {
                $Type : 'UI.DataField',
                Label : 'price',
                Value : price,
            },
            {
                $Type : 'UI.DataField',
                Label : 'currency_code',
                Value : currency_code,
            },
            {
                $Type : 'UI.DataField',
                Label : 'stock',
                Value : stock,
            },
            {
                $Type : 'UI.DataField',
                Label : 'minStock',
                Value : minStock,
            },
            {
                $Type : 'UI.DataField',
                Label : 'rating',
                Value : rating,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'RatingFacet',
            Label : 'Product Rating',
            Target : '@UI.DataPoint#ProductRating',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    UI.SelectionFields : [
        name,
        stock,
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'name',
            Value : name,
        },
        {
            $Type : 'UI.DataField',
            Label : 'description',
            Value : description,
        },
        {
            $Type : 'UI.DataField',
            Label : 'price',
            Value : price,
        },
        {
            $Type : 'UI.DataField',
            Label : 'stock',
            Value : stock,
        },
        {
            $Type : 'UI.DataField',
            Label : 'rating',
            Value : rating,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Supplier',
            Value : supplier.name,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Category',
            Value : category.name,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Created By',
            Value : createdBy,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Modified By',
            Value : modifiedBy,
        },
    ],
    UI.DataPoint #ProductRating : {
        Title : 'Product Rating',
        Value : rating
    },
    UI.DataPoint #StockLevel : {
        Title : 'Stock Level',
        Value : stock,
        Criticality : #Positive
    },
    
);

