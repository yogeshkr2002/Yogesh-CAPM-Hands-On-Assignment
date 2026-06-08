const cds = require('@sap/cds');

module.exports = function () {

  // ═══════════════════════════════════════════════
  //  SALES ORDERS — Validations
  // ═══════════════════════════════════════════════

  this.before('CREATE', 'SalesOrders', async (req) => {
    const { customer_ID, orderDate, items } = req.data;

    // 1. Customer is required
    if (!customer_ID) {
      req.error(400, 'Customer is required for orders', 'customer_ID');
    }

    // 2. Order date cannot be in the past
    if (orderDate) {
      const today = new Date().toISOString().split('T')[0];
      if (orderDate < today) {
        req.error(400, 'Order date cannot be in the past', 'orderDate');
      }
    }

    // 3. Must have at least one item
    if (!items || items.length === 0) {
      req.error(400, 'Order must have at least one item');
    }

    // 4. Validate each item
    if (items) {
      for (let i = 0; i < items.length; i++) {
        const item = items[i];

        if (!item.product_ID) {
          req.error(400, `Item ${i + 1}: Product is required`);
        }
        if (!item.quantity || item.quantity <= 0) {
          req.error(400, `Item ${i + 1}: Quantity must be greater than zero`);
        }
        if (!item.unitPrice || item.unitPrice <= 0) {
          req.error(400, `Item ${i + 1}: Unit price must be greater than zero`);
        }
      }
    }

    // 5. Verify customer exists
    if (customer_ID) {
      const customer = await SELECT.one.from('com.epm.Customers')
        .where({ ID: customer_ID });
      if (!customer) {
        req.error(404, 'Customer not found', 'customer_ID');
      }
    }
  });

  // Auto-calculate totals before saving
  this.before('CREATE', 'SalesOrders', (req) => {
    const { items } = req.data;

    if (items && items.length > 0) {
      let netAmount = 0;

      for (const item of items) {
        item.netAmount = +(item.quantity * item.unitPrice).toFixed(2);
        netAmount += item.netAmount;
      }

      req.data.netAmount = +netAmount.toFixed(2);
      req.data.taxAmount = +(netAmount * 0.18).toFixed(2);
      req.data.grossAmount = +(netAmount * 1.18).toFixed(2);
    }

    // Set default status
    if (!req.data.status) {
      req.data.status = 'New';
    }
  });

  // Status transition validation
  this.before('UPDATE', 'SalesOrders', async (req) => {
    if (req.data.status) {
      const orderId = req.params[0]?.ID || req.params[0];
      const order = await SELECT.one.from('com.epm.SalesOrders')
        .where({ ID: orderId });

      if (!order) {
        req.reject(404, 'Order not found');
      }

     const transitions = {
       'Created': ['Confirmed', 'Cancelled'],
       'Confirmed': ['Shipped', 'Cancelled'],
       'Shipped': ['Delivered'],
       'Delivered': [],
       'Cancelled': []
};

      const allowed = transitions[order.status] || [];
      if (!allowed.includes(req.data.status)) {
        req.reject(400,
          `Cannot change status from "${order.status}" to "${req.data.status}". ` +
          `Allowed: ${allowed.join(', ') || 'none (final state)'}`
        );
      }
    }
  });

  // Prevent deleting delivered orders
  this.before('DELETE', 'SalesOrders', async (req) => {
    const orderId = req.params[0]?.ID || req.params[0];
    const order = await SELECT.one.from('com.epm.SalesOrders')
      .where({ ID: orderId });

    if (order && order.status === 'Delivered') {
      req.reject(409, 'Cannot delete a delivered order. Archive it instead.');
    }
  });

  // ═══════════════════════════════════════════════
  //  AFTER READ: Enrich order data
  // ═══════════════════════════════════════════════

  this.after('READ', 'SalesOrders', (results) => {
    const orders = Array.isArray(results) ? results : [results];

    for (const order of orders) {
      if (order.status) {
        const statusInfo = {
          'New': { priority: 'Normal', color: 'blue' },
          'Confirmed': { priority: 'Normal', color: 'green' },
          'Shipped': { priority: 'High', color: 'orange' },
          'Delivered': { priority: 'Low', color: 'grey' },
          'Cancelled': { priority: 'None', color: 'red' }
        };
        const info = statusInfo[order.status];
        if (info) {
          order.statusPriority = info.priority;
          order.statusColor = info.color;
        }
      }
    }
  });

};