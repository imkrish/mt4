#property copyright "www.imkrish.com"
#property link      "www.imkrish.com"
#property version   "1.00"
#property strict

#define CLOSE_ALL "CLOSE_ALL"
#define CLOSE_50 "CLOSE_50"
#define CLOSE_10 "CLOSE_10"

#define TO_WIN "TO_WIN"
#define TO_WIN_PERCENT "TO_WIN_PERCENT"
#define TO_LOSE "TO_LOSE"
#define TO_LOSE_PERCENT "TO_LOSE_PERCEMT"

int OnInit() {
   //--- CLOSE_ALL
   createCloseButton(CLOSE_ALL, "CLOSE ALL", clrTomato, 300);
   
   //--- CLOSE_50
   createCloseButton(CLOSE_50, "CLOSE 50%", clrOrange, 360);
   
   //--- CLOSE_10
   createCloseButton(CLOSE_10, "CLOSE 10%", clrYellow, 420);
     
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
   ObjectDelete(0, CLOSE_ALL);
   ObjectDelete(0, CLOSE_50);
   ObjectDelete(0, CLOSE_10);
   ObjectDelete(0, TO_WIN);
   ObjectDelete(0, TO_WIN_PERCENT);
   ObjectDelete(0, TO_LOSE);
   ObjectDelete(0, TO_LOSE_PERCENT);
}

void OnTick() {
   double statistics[4];
   getRiskingWinningPercentages(statistics);
   
   string toLose = "Risk       ($)     " + NormalizeDouble(statistics[0], 2);
   string toLosePercent = "Risk       (%)    " + NormalizeDouble(statistics[1], 2);
  
   string toWin = "Reward ($)     " + NormalizeDouble(statistics[2], 2);
   string toWinPercent = "Reward (%)    " + NormalizeDouble(statistics[3], 2);
   
   ObjectCreate(TO_LOSE, OBJ_LABEL, 0, 0, 0);
   ObjectSetText(TO_LOSE, toLose, 12, "Verdana", clrPink);
   ObjectSet(TO_LOSE, OBJPROP_CORNER, 0);
   ObjectSet(TO_LOSE, OBJPROP_XDISTANCE, ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0) - 180);
   ObjectSet(TO_LOSE, OBJPROP_YDISTANCE, 125);
   
   ObjectCreate(TO_LOSE_PERCENT, OBJ_LABEL, 0, 0, 0);
   ObjectSetText(TO_LOSE_PERCENT, toLosePercent, 12, "Verdana", clrPink);
   ObjectSet(TO_LOSE_PERCENT, OBJPROP_CORNER, 0);
   ObjectSet(TO_LOSE_PERCENT, OBJPROP_XDISTANCE, ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0) - 180);
   ObjectSet(TO_LOSE_PERCENT, OBJPROP_YDISTANCE, 150);
   
   ObjectCreate(TO_WIN, OBJ_LABEL, 0, 0, 0);
   ObjectSetText(TO_WIN, toWin, 12, "Verdana", C'200,247,197');
   ObjectSet(TO_WIN, OBJPROP_CORNER, 0);
   ObjectSet(TO_WIN, OBJPROP_XDISTANCE, ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0) - 180);
   ObjectSet(TO_WIN, OBJPROP_YDISTANCE, 200);
   
   ObjectCreate(TO_WIN_PERCENT, OBJ_LABEL, 0, 0, 0);
   ObjectSetText(TO_WIN_PERCENT, toWinPercent, 12, "Verdana", C'200,247,197');
   ObjectSet(TO_WIN_PERCENT, OBJPROP_CORNER, 0);
   ObjectSet(TO_WIN_PERCENT, OBJPROP_XDISTANCE, ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0) - 180);
   ObjectSet(TO_WIN_PERCENT, OBJPROP_YDISTANCE, 225);
}

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam) {
   Print(sparam);
   
   //--- CLOSE_ALL
   if (sparam == CLOSE_ALL) {      
      closeOrder(1);
      ObjectSetInteger(0, CLOSE_ALL, OBJPROP_STATE, 0);
   }
   
   //--- CLOSE_50
   if (sparam == CLOSE_50) {      
      closeOrder(2);
      ObjectSetInteger(0, CLOSE_50, OBJPROP_STATE, 0);
   }
   
   //--- CLOSE_10
   if (sparam == CLOSE_10) {      
      closeOrder(10);
      ObjectSetInteger(0, CLOSE_10, OBJPROP_STATE, 0);
   }   
}

void createCloseButton(string name, string text, int bgColor, int yDistance) {
   ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, 100);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, 30);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0) - 160);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, yDistance);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrBlack);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
}

void closeOrder(int dividedBy) {
   for (int i = (OrdersTotal() - 1); i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS) && OrderSymbol() == _Symbol) {
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) {
            int slippage = 0;
            double bidPrice = MarketInfo(OrderSymbol(), MODE_BID);
            double askPrice = MarketInfo(OrderSymbol(), MODE_ASK);
            
            double lotsToClose = OrderLots() / dividedBy;
            if (lotsToClose < 0.01) {
               lotsToClose = 0.01;
            }
            
            if (OrderType() == OP_BUY && OrderClose(OrderTicket(), lotsToClose, bidPrice, slippage)) {
               Print(__FUNCTION__, " > Order #", OrderTicket(), " was partially closed ", lotsToClose);
            }
            if (OrderType() == OP_SELL && OrderClose(OrderTicket(), lotsToClose, askPrice, slippage)) {
               Print(__FUNCTION__, " > Order #", OrderTicket(), " was partially closed ", lotsToClose);
            }
         }
      }
   }
}

void getRiskingWinningPercentages(double &statistics[]) {
   double accountBalance = AccountBalance();
   double possibleLoss = 0;
   double possibleWin = 0;
   
   for (int i = (OrdersTotal() - 1); i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS) && OrderSymbol() == _Symbol) {
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) {
            double openPrice = OrderOpenPrice();
            double stopLossPrice = OrderStopLoss();
            double takeProfitPrice = OrderTakeProfit();
            double commission = OrderCommission() * -1;
            
            if (OrderType() == OP_BUY) {
               possibleLoss = possibleLoss + commission + (openPrice - stopLossPrice) * OrderLots() * 1000;
               possibleWin = possibleWin + (takeProfitPrice - openPrice) * OrderLots() * 1000;
            }
            if (OrderType() == OP_SELL) {
               possibleLoss = possibleLoss + commission + (stopLossPrice - openPrice) * OrderLots() * 1000;
               possibleWin = possibleWin + (openPrice - takeProfitPrice) * OrderLots() * 1000;
            }
         }
      }
   }
   
   statistics[0] = possibleLoss;
   statistics[1] = possibleLoss / accountBalance * 100;
   statistics[2] = possibleWin;
   statistics[3] = possibleWin / accountBalance * 100;
}
