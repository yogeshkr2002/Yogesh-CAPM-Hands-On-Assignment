sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"salesordersapp/test/integration/pages/SalesOrdersList",
	"salesordersapp/test/integration/pages/SalesOrdersObjectPage",
	"salesordersapp/test/integration/pages/SalesOrderItemsObjectPage"
], function (JourneyRunner, SalesOrdersList, SalesOrdersObjectPage, SalesOrderItemsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('salesordersapp') + '/test/flp.html#app-preview',
        pages: {
			onTheSalesOrdersList: SalesOrdersList,
			onTheSalesOrdersObjectPage: SalesOrdersObjectPage,
			onTheSalesOrderItemsObjectPage: SalesOrderItemsObjectPage
        },
        async: true
    });

    return runner;
});

