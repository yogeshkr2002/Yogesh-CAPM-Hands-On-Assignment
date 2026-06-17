sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"project1/test/integration/pages/PurchaseOrdersList",
	"project1/test/integration/pages/PurchaseOrdersObjectPage"
], function (JourneyRunner, PurchaseOrdersList, PurchaseOrdersObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('project1') + '/test/flp.html#app-preview',
        pages: {
			onThePurchaseOrdersList: PurchaseOrdersList,
			onThePurchaseOrdersObjectPage: PurchaseOrdersObjectPage
        },
        async: true
    });

    return runner;
});

