PRO plot_sales

   myDates = TIMEGEN(12, UNITS='Months', START=JULDAY(1,1,2000))
   sales = [180,190,230,200,220,220,190,100,200,210,220,140]
   PLOT, myDates, sales, XTICKUNITS=['Months', 'Years'], $
       XTITLE = 'Date (* = Leap Year)', $
      YTITLE='Sales (units)', POSITION = [0.2, 0.5, 0.9, 0.9]
   ;plots,   mydates,sales-100,color=3,XTICKUNITS=['Months', 'Years'], $
      ;XTITLE = 'Date (* = Leap Year)', $
      ;YTITLE='Sales (units)', position=[0.2,0.1,0.4,0.4]
  stop
  end