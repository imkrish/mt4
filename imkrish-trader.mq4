#property copyright "www.imkrish.com"
#property link      "www.imkrish.com"
#property version   "1.00"
#property strict

#define CLOSE_ALL "CLOSE_ALL"
#define CLOSE_50 "CLOSE_50"
#define CLOSE_10 "CLOSE_10"

int OnInit() {
   //--- CLOSE_ALL
   ObjectCreate(0, CLOSE_ALL, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, CLOSE_ALL, OBJPROP_XSIZE, 100);
   ObjectSetInteger(0, CLOSE_ALL, OBJPROP_YSIZE, 30);
   ObjectSetInteger(0, CLOSE_ALL, OBJPROP_XDISTANCE, ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0) - 150);
   ObjectSetInteger(0, CLOSE_ALL, OBJPROP_YDISTANCE, 300);
   ObjectSetInteger(0, CLOSE_ALL, OBJPROP_BGCOLOR, clrTomato);
   ObjectSetInteger(0, CLOSE_ALL, OBJPROP_COLOR, clrBlack);
   ObjectSetString(0, CLOSE_ALL, OBJPROP_TEXT, "CLOSE ALL");
   
   //--- CLOSE_50
   ObjectCreate(0, CLOSE_50, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, CLOSE_50, OBJPROP_XSIZE, 100);
   ObjectSetInteger(0, CLOSE_50, OBJPROP_YSIZE, 30);
   ObjectSetInteger(0, CLOSE_50, OBJPROP_XDISTANCE, ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0) - 150);
   ObjectSetInteger(0, CLOSE_50, OBJPROP_YDISTANCE, 360);
   ObjectSetInteger(0, CLOSE_50, OBJPROP_BGCOLOR, clrOrange);
   ObjectSetInteger(0, CLOSE_50, OBJPROP_COLOR, clrBlack);
   ObjectSetString(0, CLOSE_50, OBJPROP_TEXT, "CLOSE 50%");
   
   //--- CLOSE_10
   ObjectCreate(0, CLOSE_10, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, CLOSE_10, OBJPROP_XSIZE, 100);
   ObjectSetInteger(0, CLOSE_10, OBJPROP_YSIZE, 30);
   ObjectSetInteger(0, CLOSE_10, OBJPROP_XDISTANCE, ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0) - 150);
   ObjectSetInteger(0, CLOSE_10, OBJPROP_YDISTANCE, 420);
   ObjectSetInteger(0, CLOSE_10, OBJPROP_BGCOLOR, clrYellow);
   ObjectSetInteger(0, CLOSE_10, OBJPROP_COLOR, clrBlack);
   ObjectSetString(0, CLOSE_10, OBJPROP_TEXT, "CLOSE 10%");
     
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
   ObjectDelete(0, CLOSE_ALL);
   ObjectDelete(0, CLOSE_50);
   ObjectDelete(0, CLOSE_10);
}

void OnTick() {
}

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam) {
   Print(sparam);
   
   //--- CLOSE_ALL
   if (sparam == CLOSE_ALL) {      
      for (int i = (OrdersTotal() - 1); i >= 0; i--) {
         if (OrderSelect(i, SELECT_BY_POS) && OrderSymbol() == _Symbol) {
            if (OrderType() == OP_BUY || OrderType() == OP_SELL) {
               int slippage = 0;
               double bidPrice = MarketInfo(OrderSymbol(), MODE_BID);
               double askPrice = MarketInfo(OrderSymbol(), MODE_ASK);
               if (OrderType() == OP_BUY && OrderClose(OrderTicket(), OrderLots(), bidPrice, slippage)) {
                  Print(__FUNCTION__, " > Order #", OrderTicket(), " was closed");
               }
               if (OrderType() == OP_SELL && OrderClose(OrderTicket(), OrderLots(), askPrice, slippage)) {
                  Print(__FUNCTION__, " > Order #", OrderTicket(), " was closed");
               }
            }
         }
      }
      ObjectSetInteger(0, CLOSE_ALL, OBJPROP_STATE, 0);
   }
   
   //--- CLOSE_50
   if (sparam == CLOSE_50) {      
      for (int i = (OrdersTotal() - 1); i >= 0; i--) {
         if (OrderSelect(i, SELECT_BY_POS) && OrderSymbol() == _Symbol) {
            if (OrderType() == OP_BUY || OrderType() == OP_SELL) {
               int slippage = 0;
               double bidPrice = MarketInfo(OrderSymbol(), MODE_BID);
               double askPrice = MarketInfo(OrderSymbol(), MODE_ASK);
               if (OrderType() == OP_BUY && OrderClose(OrderTicket(), OrderLots() / 2, bidPrice, slippage)) {
                  Print(__FUNCTION__, " > Order #", OrderTicket(), " was partially closed");
               }
               if (OrderType() == OP_SELL && OrderClose(OrderTicket(), OrderLots() / 2, askPrice, slippage)) {
                  Print(__FUNCTION__, " > Order #", OrderTicket(), " was partially closed");
               }
            }
         }
      }
      ObjectSetInteger(0, CLOSE_50, OBJPROP_STATE, 0);
   }
   
   //--- CLOSE_10
   if (sparam == CLOSE_10) {      
      for (int i = (OrdersTotal() - 1); i >= 0; i--) {
         if (OrderSelect(i, SELECT_BY_POS) && OrderSymbol() == _Symbol) {
            if (OrderType() == OP_BUY || OrderType() == OP_SELL) {
               int slippage = 0;
               double bidPrice = MarketInfo(OrderSymbol(), MODE_BID);
               double askPrice = MarketInfo(OrderSymbol(), MODE_ASK);
               if (OrderType() == OP_BUY && OrderClose(OrderTicket(), OrderLots() / 10, bidPrice, slippage)) {
                  Print(__FUNCTION__, " > Order #", OrderTicket(), " was partially closed");
               }
               if (OrderType() == OP_SELL && OrderClose(OrderTicket(), OrderLots() / 10, askPrice, slippage)) {
                  Print(__FUNCTION__, " > Order #", OrderTicket(), " was partially closed");
               }
            }
         }
      }
      ObjectSetInteger(0, CLOSE_10, OBJPROP_STATE, 0);
   }
   
   
}
