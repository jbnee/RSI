; docformat = 'rst'
;+
; This is an example program to demonstrate how to create a basic line plot
; with IDL function graphics routines.
;
; :Categories:
;    Graphics
;
; :Examples:
;    Save the program as "basic_line_plot_fg.pro" and run it like this::
;       IDL> basic_line_plot_fg
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
;        Written, 27 February 2014 by Matthew Argall and David W. Fanning.
;
; :Copyright:
;     Copyright (c) 2014, Fanning Software Consulting, Inc.
;-
PRO Basic_Line_Plot_FG

   ; Don't forget compile options in IDL 8 programs or there can be problems
   Compile_Opt idl2

    ; Example data.
    data = cgDemoData(1)
    time = cgScaleVector(Findgen(N_Elements(data)), 0, 6)
    
    ; Set up variables for the plot. Normally, these values would be
    ; passed into the program as positional and keyword parameters.
    xtitle = 'Time'
    ytitle = 'Signal Strength'
    title = 'Basic Line Plot'
    position = [0.125, 0.125, 0.9, 0.925]
    
    ; Create the plot
    fgPlot = Plot(time, data, Color='red', Symbol="Circle", Sym_Color='Olive_Drab', $
        /Sym_Filled, Sym_Size=1.0, Title=title, XTitle=xtitle, YTitle=ytitle, $
        Position=position)
      
    ; Save the plot as a PostScript file.
    fgPlot.save, 'basic_line_plot_fg.eps'
    
    ; ; Create a PNG file with a width of 600 pixels. Resolution of this
    ; PNG file is not very good.
    ;fgPlot.save, 'basic_line_plot_fg.png', Width=600

    ; For better resolution PNG files, make the PNG full-size, then resize it
    ; with ImageMagick. Requires ImageMagick to be installed.
    fgPlot.save, 'basic_line_plot_fg_fullsize.png'
    Spawn, 'convert basic_line_plot_fg_fullsize.png -resize 600 basic_line_plot_fg.png'
    
END