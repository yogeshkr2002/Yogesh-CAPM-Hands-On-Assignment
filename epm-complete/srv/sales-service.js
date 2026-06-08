const cds = require('@sap/cds');

module.exports = function () {

  // ═══════════════════════════════════════════════
  // SALES ORDERS — Validations
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
      const customer = await SELECT.one
        .from('com.epm.Customers')
        .where({ ID: customer_ID });

      if (!customer) {
        req.error(404, 'Customer not found', 'customer_ID');
      }
    }
  });

  // Auto-calculate item net amounts
  this.before('CREATE', 'SalesOrders', (req) => {
    const { items } = req.data;

    if (items && items.length > 0) {
      let totalAmount = 0;

      for (const item of items) {
        item.netAmount = +(item.quantity * item.unitPrice).toFixed(2);
        totalAmount += item.netAmount;
      }

      req.data.totalAmount = +totalAmount.toFixed(2);
    }

    // Default status
    if (!req.data.status) {
      req.data.status = 'New';
    }
  });

  // ═══════════════════════════════════════════════
  // Status Transition Validation
  // ═══════════════════════════════════════════════

  this.before('UPDATE', 'SalesOrders', async (req) => {

    if (req.data.status) {

      const orderId = req.params[0]?.ID || req.params[0];

      const order = await SELECT.one
        .from('com.epm.SalesOrders')
        .where({ ID: orderId });

      if (!order) {
        req.reject(404, 'Order not found');
      }

      const transitions = {
        'New': ['Confirmed', 'Cancelled'],
        'Confirmed': ['Shipped', 'Cancelled'],
        'Shipped': ['Delivered'],
        'Delivered': [],
        'Cancelled': []
      };

      const allowed = transitions[order.status] || [];

      if (!allowed.includes(req.data.status)) {
        req.reject(
          400,
          `Cannot change status from "${order.status}" to "${req.data.status}". Allowed: ${allowed.join(', ') || 'none (final state)'}`
        );
      }
    }
  });

  // ═══════════════════════════════════════════════
  // Prevent deleting delivered orders
  // ═══════════════════════════════════════════════

  this.before('DELETE', 'SalesOrders', async (req) => {

    const orderId = req.params[0]?.ID || req.params[0];

    const order = await SELECT.one
      .from('com.epm.SalesOrders')
      .where({ ID: orderId });

    if (order && order.status === 'Delivered') {
      req.reject(
        409,
        'Cannot delete a delivered order. Archive it instead.'
      );
    }
  });

  // ═══════════════════════════════════════════════
  // AFTER READ
  // ═══════════════════════════════════════════════

  this.after('READ', 'SalesOrders', (results) => {

    const orders = Array.isArray(results)
      ? results
      : [results];

    for (const order of orders) {

      if (!order || !order.status) continue;

      const statusInfo = {
        'New': {
          priority: 'Normal',
          color: 'blue'
        },
        'Confirmed': {
          priority: 'Normal',
          color: 'green'
        },
        'Shipped': {
          priority: 'High',
          color: 'orange'
        },
        'Delivered': {
          priority: 'Low',
          color: 'grey'
        },
        'Cancelled': {
          priority: 'None',
          color: 'red'
        }
      };

      const info = statusInfo[order.status];

      if (info) {
        order.statusPriority = info.priority;
        order.statusColor = info.color;
      }
    }
  });

  // ═══════════════════════════════════════════════
  // BOUND ACTION : confirm
  // ═══════════════════════════════════════════════

  this.on('confirm', 'SalesOrders', async (req) => {

    const orderId = req.params[0]?.ID;

    const order = await SELECT.one
      .from('com.epm.SalesOrders')
      .where({ ID: orderId });

    if (!order) {
      req.reject(404, 'Order not found');
    }

    if (order.status !== 'New') {
      req.reject(
        400,
        `Only New orders can be confirmed. Current status: ${order.status}`
      );
    }

    await UPDATE('com.epm.SalesOrders')
      .set({
        status: 'Confirmed'
      })
      .where({ ID: orderId });

    return {
      status: 'Confirmed',
      message: `Order ${order.orderNumber} confirmed successfully`
    };
  });

  // ═══════════════════════════════════════════════
  // BOUND ACTION : cancel
  // ═══════════════════════════════════════════════

  this.on('cancel', 'SalesOrders', async (req) => {

    const orderId = req.params[0]?.ID;

    const { reason } = req.data;

    const order = await SELECT.one
      .from('com.epm.SalesOrders')
      .where({ ID: orderId });

    if (!order) {
      req.reject(404, 'Order not found');
    }

    if (!reason || !reason.trim()) {
      req.reject(400, 'Cancellation reason is required');
    }

    if (order.status === 'Delivered') {
      req.reject(
        400,
        'Delivered orders cannot be cancelled'
      );
    }

    if (order.status === 'Cancelled') {
      req.reject(
        400,
        'Order already cancelled'
      );
    }

    await UPDATE('com.epm.SalesOrders')
      .set({
        status: 'Cancelled'
      })
      .where({ ID: orderId });

    return {
      status: 'Cancelled',
      message: `Order cancelled. Reason: ${reason}`
    };
  });

  // ═══════════════════════════════════════════════
  // BOUND ACTION : ship
  // ═══════════════════════════════════════════════

  this.on('ship', 'SalesOrders', async (req) => {

    const orderId = req.params[0]?.ID;

    const {
      trackingNumber,
      carrier
    } = req.data;

    const order = await SELECT.one
      .from('com.epm.SalesOrders')
      .where({ ID: orderId });

    if (!order) {
      req.reject(404, 'Order not found');
    }

    if (order.status !== 'Confirmed') {
      req.reject(
        400,
        `Only Confirmed orders can be shipped. Current status: ${order.status}`
      );
    }

    if (!trackingNumber) {
      req.reject(400, 'Tracking number is required');
    }

    if (!carrier) {
      req.reject(400, 'Carrier is required');
    }

    await UPDATE('com.epm.SalesOrders')
      .set({
        status: 'Shipped'
      })
      .where({ ID: orderId });

    const deliveryDate = new Date();
    deliveryDate.setDate(deliveryDate.getDate() + 5);

    return {
      status: 'Shipped',
      message: `Order shipped via ${carrier}`,
      estimatedDelivery: deliveryDate.toISOString().split('T')[0]
    };
  });

};