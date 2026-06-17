// const cds = require('@sap/cds')

// module.exports = cds.service.impl(async function () {

//     const { PurchaseOrders, POItems, Products } = this.entities

//     // -----------------------------
//     // Validation Before Save
//     // -----------------------------
//     this.before(['CREATE', 'UPDATE'], PurchaseOrders, async (req) => {

//         const data = req.data

//         if (!data.supplier_ID) {
//             req.error('Supplier is mandatory')
//         }

//         if (!data.orderDate) {
//             req.error('Order Date is mandatory')
//         }
//     })

//     // -----------------------------
//     // Calculate Item Amount
//     // -----------------------------
//     this.before(['CREATE', 'UPDATE'], POItems, async (req) => {

//         const item = req.data

//         if (item.quantity <= 0) {
//             req.error('Quantity must be greater than zero')
//         }

//         if (item.product_ID) {

//             const product = await SELECT.one
//                 .from(Products)
//                 .where({ ID: item.product_ID })

//             item.unitPrice = product.price
//             item.amount = item.quantity * product.price
//         }
//     })

//     // -----------------------------
//     // Side Effect Total Calculation
//     // -----------------------------
//     async function calculateTotal(poId) {

//         const items = await SELECT.from(POItems)
//             .where({ parent_ID: poId })

//         let total = 0

//         items.forEach(item => {
//             total += item.amount
//         })

//         await UPDATE(PurchaseOrders)
//             .set({ totalAmount: total })
//             .where({ ID: poId })
//     }

//     this.after(['CREATE', 'UPDATE'], POItems, async (data) => {

//         await calculateTotal(data.parent_ID)
//     })

//     // -----------------------------
//     // Criticality Calculation
//     // -----------------------------
//     this.after('READ', PurchaseOrders, (orders) => {

//         const setCriticality = (o) => {

//             if (o.status === 'Draft') {
//                 o.criticality = 2
//             }
//             else if (o.status === 'Pending') {
//                 o.criticality = 3
//             }
//             else if (o.status === 'Approved') {
//                 o.criticality = 1
//             }
//             else {
//                 o.criticality = 0
//             }
//         }

//         if (Array.isArray(orders)) {
//             orders.forEach(setCriticality)
//         } else {
//             setCriticality(orders)
//         }
//     })

//     // -----------------------------
//     // Submit Action
//     // -----------------------------
//     this.on('submitOrder', PurchaseOrders, async (req) => {

//         const id = req.params[0].ID

//         const po = await SELECT.one
//             .from(PurchaseOrders)
//             .where({ ID: id })

//         if (po.status === 'Approved') {
//             req.error('Already approved')
//         }

//         await UPDATE(PurchaseOrders)
//             .set({ status: 'Pending' })
//             .where({ ID: id })

//         return 'Submitted Successfully'
//     })

//     // -----------------------------
//     // Approve Action
//     // -----------------------------
//     this.on('approveOrder', PurchaseOrders, async (req) => {

//         const id = req.params[0].ID

//         const po = await SELECT.one
//             .from(PurchaseOrders)
//             .where({ ID: id })

//         if (po.status !== 'Pending') {
//             req.error('Only pending orders can be approved')
//         }

//         await UPDATE(PurchaseOrders)
//             .set({ status: 'Approved' })
//             .where({ ID: id })

//         return 'Approved Successfully'
//     })

//     // -----------------------------
//     // Reject Action
//     // -----------------------------
//     this.on('rejectOrder', PurchaseOrders, async (req) => {

//         const id = req.params[0].ID
//         const reason = req.data.reason

//         if (!reason) {
//             req.error('Reason is mandatory')
//         }

//         await UPDATE(PurchaseOrders)
//             .set({ status: 'Rejected' })
//             .where({ ID: id })

//         return `Rejected: ${reason}`
//     })
// })


const cds = require('@sap/cds')

module.exports = cds.service.impl(async function () {

    const { PurchaseOrders, POItems, Products } = this.entities

    // -----------------------------------
    // Validation Before Save
    // -----------------------------------
    this.before(['CREATE', 'UPDATE'], PurchaseOrders, async (req) => {

        const data = req.data

        if (!data.supplier_ID) {
            req.error('Supplier is mandatory')
        }

        if (!data.orderDate) {
            req.error('Order Date is mandatory')
        }
    })

    // -----------------------------------
    // Calculate Item Amount
    // -----------------------------------
    this.before(['CREATE', 'UPDATE'], POItems, async (req) => {

        const item = req.data

        if (item.quantity <= 0) {
            req.error('Quantity must be greater than zero')
        }

        if (item.product_ID) {

            const product = await SELECT.one
                .from(Products)
                .where({ ID: item.product_ID })

            if (product) {
                item.unitPrice = product.price
                item.amount = item.quantity * product.price
            }
        }
    })

    // -----------------------------------
    // Calculate Total Amount
    // -----------------------------------
    async function calculateTotal(poId) {

        const items = await SELECT.from(POItems)
            .where({ parent_ID: poId })

        let total = 0

        items.forEach(item => {
            total += item.amount || 0
        })

        await UPDATE(PurchaseOrders)
            .set({
                totalAmount: total
            })
            .where({
                ID: poId
            })
    }

    this.after(['CREATE', 'UPDATE'], POItems, async (data) => {

        if (data.parent_ID) {
            await calculateTotal(data.parent_ID)
        }
    })

    // -----------------------------------
    // Criticality + Editability
    // -----------------------------------
    this.after('READ', PurchaseOrders, (data) => {

        const setControl = (o) => {

            // -------------------------
            // Criticality Calculation
            // -------------------------
            if (o.status === 'Draft') {
                o.criticality = 2
            }
            else if (o.status === 'Pending') {
                o.criticality = 3
            }
            else if (o.status === 'Approved') {
                o.criticality = 1
            }
            else {
                o.criticality = 0
            }

            // -------------------------
            // Editable Control
            // -------------------------
            if (
                o.status === 'Pending' ||
                o.status === 'Approved'
            ) {
                o.UIEditable = false
            }
            else {
                o.UIEditable = true
            }
        }

        if (Array.isArray(data)) {
            data.forEach(setControl)
        }
        else if (data) {
            setControl(data)
        }
    })

    // -----------------------------------
    // Submit Action
    // -----------------------------------
    this.on('submitOrder', PurchaseOrders, async (req) => {

        const id = req.params[0].ID

        const po = await SELECT.one
            .from(PurchaseOrders)
            .where({ ID: id })

        if (!po) {
            req.error('Purchase Order not found')
        }

        if (po.status === 'Approved') {
            req.error('Already approved')
        }

        await UPDATE(PurchaseOrders)
            .set({
                status: 'Pending'
            })
            .where({
                ID: id
            })

        return 'Submitted Successfully'
    })

    // -----------------------------------
    // Approve Action
    // -----------------------------------
    this.on('approveOrder', PurchaseOrders, async (req) => {

        const id = req.params[0].ID

        const po = await SELECT.one
            .from(PurchaseOrders)
            .where({ ID: id })

        if (!po) {
            req.error('Purchase Order not found')
        }

        if (po.status !== 'Pending') {
            req.error('Only pending orders can be approved')
        }

        await UPDATE(PurchaseOrders)
            .set({
                status: 'Approved'
            })
            .where({
                ID: id
            })

        return 'Approved Successfully'
    })

    // -----------------------------------
    // Reject Action
    // -----------------------------------
    this.on('rejectOrder', PurchaseOrders, async (req) => {

        const id = req.params[0].ID
        const reason = req.data.reason

        if (!reason) {
            req.error('Reason is mandatory')
        }

        await UPDATE(PurchaseOrders)
            .set({
                status: 'Rejected'
            })
            .where({
                ID: id
            })

        return `Rejected: ${reason}`
    })

})


