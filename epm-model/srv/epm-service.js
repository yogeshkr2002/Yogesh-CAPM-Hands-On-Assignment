const cds = require('@sap/cds');

// ─── SALES SERVICE HANDLERS ──────────────────────────────────
class SalesServiceHandler extends cds.ApplicationService {

  async init() {

    const { SalesOrders, SalesOrderItems, Customers, Products } = this.entities;

    // ── 1. Auto-generate Order Number before creating Sales Order ──
    this.before('CREATE', SalesOrders, async (req) => {
      const year = new Date().getFullYear();
      const count = await SELECT.one`count(*) as total`.from(SalesOrders);
      const next  = String((count?.total ?? 0) + 1).padStart(3, '0');
      req.data.orderNumber = `SO-${year}-${next}`;
    });

    // ── 2. Validate Sales Order before creating ──
    this.before('CREATE', SalesOrders, async (req) => {
      const { customer_ID } = req.data;

      // Check customer exists
      if (!customer_ID) {
        return req.error(400, 'Customer is required to create a Sales Order.');
      }

      const customer = await SELECT.one.from(Customers).where({ ID: customer_ID });
      if (!customer) {
        return req.error(404, `Customer with ID "${customer_ID}" not found.`);
      }
    });

    // ── 3. Auto-calculate amounts on Sales Order Item ──
    this.before('CREATE', SalesOrderItems, async (req) => {
      const { product_ID, quantity } = req.data;

      if (!product_ID || !quantity) {
        return req.error(400, 'Product and quantity are required for order items.');
      }

      const product = await SELECT.one.from(Products).where({ ID: product_ID });
      if (!product) {
        return req.error(404, `Product with ID "${product_ID}" not found.`);
      }

      // Check stock availability
      if (product.stock < quantity) {
        return req.error(409,
          `Insufficient stock for "${product.productName}". Available: ${product.stock}, Requested: ${quantity}.`
        );
      }

      // Auto-calculate amounts (18% GST)
      const unitPrice   = product.price;
      const netAmount   = unitPrice * quantity;
      const taxAmount   = parseFloat((netAmount * 0.18).toFixed(2));
      const grossAmount = parseFloat((netAmount + taxAmount).toFixed(2));

      req.data.unitPrice   = unitPrice;
      req.data.currency_code = product.currency_code;
      req.data.netAmount   = netAmount;
      req.data.taxAmount   = taxAmount;
      req.data.grossAmount = grossAmount;
    });

    // ── 4. Deduct stock after Sales Order Item is created ──
    this.after('CREATE', SalesOrderItems, async (data) => {
      const { product_ID, quantity } = data;
      await UPDATE(Products)
        .set  ({ stock: { '-=': quantity } })
        .where ({ ID: product_ID });
    });

    await super.init();
  }
}

// ─── PROCUREMENT SERVICE HANDLERS ───────────────────────────
class ProcurementServiceHandler extends cds.ApplicationService {

  async init() {

    const { PurchaseOrders, Suppliers } = this.entities;

    // ── 1. Auto-generate PO Number before creating Purchase Order ──
    this.before('CREATE', PurchaseOrders, async (req) => {
      const year  = new Date().getFullYear();
      const count = await SELECT.one`count(*) as total`.from(PurchaseOrders);
      const next  = String((count?.total ?? 0) + 1).padStart(3, '0');
      req.data.poNumber = `PO-${year}-${next}`;
    });

    // ── 2. Validate Purchase Order before creating ──
    this.before('CREATE', PurchaseOrders, async (req) => {
      const { supplier_ID } = req.data;

      if (!supplier_ID) {
        return req.error(400, 'Supplier is required to create a Purchase Order.');
      }

      const supplier = await SELECT.one.from(Suppliers).where({ ID: supplier_ID });
      if (!supplier) {
        return req.error(404, `Supplier with ID "${supplier_ID}" not found.`);
      }

      // Check supplier is active
      if (!supplier.isActive) {
        return req.error(409,
          `Supplier "${supplier.supplierName}" is inactive and cannot receive new Purchase Orders.`
        );
      }
    });

    await super.init();
  }
}

// ─── EXPORT — map handlers to services ──────────────────────
module.exports = {
  SalesService       : SalesServiceHandler,
  ProcurementService : ProcurementServiceHandler
};