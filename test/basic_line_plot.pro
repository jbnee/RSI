; docformat = 'rst'
;+
; This is an example program to demontrate how to create a basic line plot
; with Coyote Graphics routines.
;
; :Categories:
;    Graphics
;    
; :Examples:
;    Save the program as "basic_line_plot.pro" and run it like this::
;       IDL> .RUN basic_line_plot
;       
; :Author:
;    FANNING SOFTWARE CONSULTING::
;       David W. Fanning 
;       1645 Sheely Drive
;       Fort Collins, CO 80526 USA
;       Phone: 970-221-0438
;       E-mail: david@idlcoyote.com
;       Coyote's Guide to IDL Programming: http://www.idlcoyote.com
;
; :History:
;     Change History::
;        Written, 23 January 2013 by David W. Fanning.
;
; :Copyright:
;     Copyright (c) 2013, Fanning Software Consulting, Inc.
;-
PRO Basic_Line_Plot

   ; Example data.
   data = cgDemoData(1)
   time = cgScaleVector(Findgen(N_Elements(data)), 0, 6)
   
   ; Set up variables for the plot. Normally, these values would be 
   ; passed into the program as positional and keyword parameters.
   xtitle = 'Time'
   ytitle = 'Signal Strength'
   title = 'Basic Line Plot'
   position = [0.125, 0.125, 0.9, 0.925]
   
   ; Set up a "window" for the plot. The PostScript output will have
   ; the same aspect ratio as the graphics window on the display.
   cgDisplay, 600, 500, Title='Basic Line Plot'
      
   ; Draw the line plot.
   cgPlot, time, data, Color='red', PSym=-16, SymColor='olive', $
      SymSize=1.5, Title=title, XTitle=xtitle, YTitle=ytitle, $
      Position=position

END ;*****************************************************************

; This main program shows how to call the program and produce
; various types of output.

  ; Example data.
  data = cgDemoData(1)
  time = cgScaleVector(Findgen(N_Elements(data)), 0, 6)

  ; Display the line plot in a graphics window.
  cgDisplay, 600, 500
  cgPlot, time, data, $
     Color='red', $
     PSym=-16, $
     SymColor='olive', $
     SymSize=1.5, $
     Title='Basic Line Plot', $
     XTitle='Time', $
     YTitle='Signal Strength', $
     Position=[0.125, 0.125, 0.9, 0.925]

  
  ; Display the line plot in a resizeable graphics window.
  cgPlot, time, data, $
     Color='red', $
     PSym=-16, $
     SymColor='olive', $
     SymSize=1.5, $
     Title='Basic Line Plot', $
     XTitle='Time', $
     YTitle='Signal Strength', $
     Position=[0.125, 0.125, 0.9, 0.925], $
     /Window, WXSize=600, WYSize=500
  
  ; Create a PostScript file.
  cgPlot, time, data, $
     Color='red', $
     PSym=-16, $
     SymColor='olive', $
     SymSize=1.5, $
     Title='Basic Line Plot', $
     XTitle='Time', $
     YTitle='Signal Strength', $
     Position=[0.125, 0.125, 0.9, 0.925], $
     Output='basic_line_plot.ps'
  
  ; Create a PNG file with a width of 600 pixels.
  cgWindow_SetDefs, IM_WIDTH=600
  cgPlot, time, data, $
     Color='red', $
     PSym=-16, $
     SymColor='olive', $
     SymSize=1.5, $
     Title='Basic Line Plot', $
     XTitle='Time', $
     YTitle='Signal Strength', $
     Position=[0.125, 0.125, 0.9, 0.925], $
     Output='basic_line_plot.png'

END