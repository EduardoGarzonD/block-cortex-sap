
view: sales_orders_sales_order_status {
  derived_table: {
    sql: SELECT
          /*if((IF(sales_orders.RejectionReason_ABGRU IS NOT NULL,'Canceled','NotCanceled'))="Canceled","Canceled",if((IF(deliveries.ActualQuantityDelivered_InSalesUnits_LFIMG = sales_orders.CumulativeOrderQuantity_KWMENG
          AND sales_orders.CumulativeOrderQuantity_KWMENG = billing.ActualBilledQuantity_FKIMG,'NotOpenOrder','OpenOrder'))="OpenOrder","Open","Closed"))*/ "Open"  AS sales_orders_sales_order_status
      FROM `alfamvpcortexproject.SAP_REPORTING.SalesOrders_V2`
           AS sales_orders
      LEFT JOIN `alfamvpcortexproject.SAP_REPORTING.Deliveries`
           AS deliveries ON sales_orders.SalesDocument_VBELN=deliveries.SalesOrderNumber_VGBEL
                and sales_orders.Item_POSNR=deliveries.SalesOrderItem_VGPOS
                and sales_orders.Client_MANDT=deliveries.Client_MANDT
      LEFT JOIN `alfamvpcortexproject.SAP_REPORTING.Billing`
           AS billing ON sales_orders.SalesDocument_VBELN=billing.SalesDocument_AUBEL
                and sales_orders.Item_POSNR=billing.SalesDocumentItem_AUPOS
                and sales_orders.Client_MANDT=billing.Client_MANDT
      WHERE (sales_orders.Client_MANDT='500' )
      GROUP BY
          1
      ORDER BY
          1
      LIMIT 500 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: sales_orders_sales_order_status {
    type: string
    sql: ${TABLE}.sales_orders_sales_order_status ;;
  }

  set: detail {
    fields: [
        sales_orders_sales_order_status
    ]
  }
}
