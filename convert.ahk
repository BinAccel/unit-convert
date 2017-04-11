;; by fuzz54 http://www.autohotkey.com/forum/viewtopic.php?t=42809


xe := 2.718281828459045, xpi := 3.141592653589793


;Number formatting, decimals, and groupbox dividers
Gui, Margin, -2, -2
Gui, Add, GroupBox, x-5 y-8 w298 h93 cblack,
Gui, Add, GroupBox, x-5 y-7 w298 h93 cblack,
Gui, Add, GroupBox, x-5 y78 w167 h53 cblack,
Gui, Add, GroupBox, x161 y78 w132 h53 cblack,
Gui, Add, Radio, x10 y87 h20 checked greg, Regular
Gui, Add, Radio, x10 y105 h20 gsci, Scientific
Gui, Add, Edit, x95 y102 w40 h20 gRpre vRP,
Gui, Add, UpDown, Range0-18 0x80, 2
Gui, Add, Text, x95 y87 Hide, decimals

;Memory variable controls
Gui, Add, Text, x180 y87 vgobyebye, save result to:
Gui, Add, Text, x180 y87 vgone, paste memory:
Gui, Add, DropDownList, x180 y102 w75 h17 r5 gmem vmem, Memory1|Memory2|Memory3|Memory4|Memory5
Gui, Add, DropDownList, x180 y102 w75 h17 r5 gmemrec vmemrec, Memory1|Memory2|Memory3|Memory4|Memory5

;Top GUI control - quanitity dropdown list
Gui, Add, DropDownList, x75 y4 w145 h20 r26 gunits vunits, Mass||Area|Distance|Speed|Temperature|Time|Volume| |--------------------------------------------------|Physical Constants|CALCULATOR

;Middle GUI controls, from and to units
Gui, Add, DropDownList, x6 y28 w125 h20 r30 vfrom gcalc,
Gui, Add, Text, x138 y28 w17 h20 gswap vswap +Center, To:
Gui, Add, DropDownList, x161 y28 w125 h20 r30 vto gcalc,

;Bottom GUI controls, input and result
Gui, Add, Edit, x6 y48 w125 h20 gcalc vtot,
Gui, add, updown,range1-1000 +wrap 0x80 vgoaway,1
Gui, Add, Text, x131 y48 w30 h20 +Center vequal, =
Gui, Add, Edit, x161 y48 w125 h20 vrez +readonly,

;Calculator
Gui Add, Edit, x4 y32 w165 h20 vcode Hidden,
Gui Add, Edit, x187 y32 w100 h20 vres Hidden Readonly ; no scroll bar for results
Gui Add, Button, x47 y58 w55 h20 Default Hidden vevaluate, &Evaluate
Gui Add, Button, x4 y58 w40 h20 Hidden vclear, &Clear
Gui Add, Button, x105 y58 w30 h20 Hidden vhelp, &Help
Gui, Add, Text, x175 y35 w5 h20 +Center vequals, =
Gui Add, Button, x160 y58 w16 h20 Hidden vlparen, (
Gui Add, Button, x177 y58 w16 h20 Hidden vrparen, )
Gui Add, Button, x194 y58 w16 h20 Hidden vmultiply, x
Gui Add, Button, x211 y58 w16 h20 Hidden vdivide, /
Gui Add, Button, x228 y58 w16 h20 Hidden vadd, +
Gui Add, Button, x245 y58 w16 h20 Hidden vsubtract, -
Gui Add, Button, x262 y58 w24 h20 Hidden vexponent,exp


gosub, units
gosub reg
Gui, Show, AutoSize, Unit Converter v2.0
Return

GuiClose:
ExitApp

swap:
If units=Physical Constants
   return
If units=Mathematical Constants
   return
Gui, submit, nohide
GuiControlGet, From, , Combobox4
GuiControlGet, To, , Combobox5
ControlGet, List ,List, List, Combobox4
StringReplace, List, List, `n, |, all
List .= "|"
StringReplace, FromList, List, %From%|, %From%||
StringReplace, ToList, List, %To%|, %To%||
GuiControl, , Combobox4, |
GuiControl, , Combobox4, %ToList%
GuiControl, , Combobox5, |
GuiControl, , Combobox5, %FromList%
gosub calc
Return


mem:
Gui, submit, nohide
If mem = Memory1
     Mem1=%rez%
If mem = Memory2
     Mem2=%rez%
If mem = Memory3
     Mem3=%rez%
If mem = Memory4
     Mem4=%rez%
If mem = Memory5
     Mem5=%rez%
return

memrec:
Gui, submit, nohide
If memrec = Memory1
     Pastemem=%Mem1%
If memrec = Memory2
     Pastemem=%Mem2%
If memrec = Memory3
     Pastemem=%Mem3%
If memrec = Memory4
     Pastemem=%Mem4%
If memrec = Memory5
     Pastemem=%Mem5%
coded=%code%%Pastemem%
Guicontrol,, code, %coded%
Guicontrol,focus,code
Send, {END}
gosub buttonevaluate
Return

reg:
pre = 0
If units=CALCULATOR
     gosub buttonevaluate
Else
     gosub calc
return

sci:
pre = 1
If units=CALCULATOR
     gosub buttonevaluate
Else
     gosub calc
return

Rpre:
Gui, submit, nohide
RegP = 0.%RP%
SetFormat, Float, %RegP%
If Units=CALCULATOR
     gosub buttonevaluate
Else
     gosub calc
return


ButtonClear:
   Gui Submit, Nohide
   Guicontrol,, code,
   Guicontrol,, res,
   Guicontrol,focus,code
Return

ButtonEvaluate:                                ; Alt-V or Enter: evaluate expression
   Gui Submit, NoHide
   if pre
      SetFormat, float, %RegP%E
   else
      SetFormat, float, %RegP%
   coded:=code
   GuiControl,,Res,% Eval(coded)
   Guicontrol,focus,code
   Send, {END}
return

Button(:
   Gui Submit, Nohide
   codeadd=%code%(
   Guicontrol,, code, %codeadd%
   Guicontrol,focus,code
   Send, {END}   
Return   

Button):
   Gui Submit, Nohide
   codeadd=%code%)
   Guicontrol,, code, %codeadd%
   Guicontrol,focus,code
   Send, {END}   
Return

Buttonx:
   Gui Submit, Nohide
   codeadd=%code%*
   Guicontrol,, code, %codeadd%
   Guicontrol,focus,code
   Send, {END}   
Return   

Button/:
   Gui Submit, Nohide
   codeadd=%code%/
   Guicontrol,, code, %codeadd%
   Guicontrol,focus,code
   Send, {END}   
Return

Button+:
   Gui Submit, Nohide
   codeadd=%code%+
   Guicontrol,, code, %codeadd%
   Guicontrol,focus,code
   Send, {END}   
Return

Button-:
   Gui Submit, Nohide
   codeadd=%code%-
   Guicontrol,, code, %codeadd%
   Guicontrol,focus,code
   Send, {END}
Return

ButtonExp:
   Gui Submit, Nohide
   codeadd=%code%**
   Guicontrol,, code, %codeadd%
   Guicontrol,focus,code
   Send, {END}
Return


units:
Gui, submit, nohide

if units=CALCULATOR
{
Guicontrol,focus,code
Guicontrol,Show,Code
Guicontrol,Show,Res
Guicontrol,Show,gone
Guicontrol,Show,memrec
Guicontrol,Show,Help
Guicontrol,Show,Evaluate
Guicontrol,Show,Clear
Guicontrol,Show,multiply
Guicontrol,Show,divide
Guicontrol,Show,add
Guicontrol,Show,subtract
Guicontrol,Show,exponent
Guicontrol,Show,equals
Guicontrol,Show,lparen
Guicontrol,Show,rparen
Guicontrol,Show,RP
Guicontrol,Hide,tot
Guicontrol,Hide,rez
Guicontrol,Hide,from
Guicontrol,Hide,to
Guicontrol,Hide,To:
Guicontrol,Hide,goaway
Guicontrol,Hide,gobyebye
Guicontrol,Hide,mem
Guicontrol,Hide,equal
}
else
{
Guicontrol,hide,Code
Guicontrol,hide,Res
Guicontrol,hide,gone
Guicontrol,hide,memrec
Guicontrol,hide,Help
Guicontrol,hide,Evaluate
Guicontrol,hide,Clear
Guicontrol,hide,multiply
Guicontrol,hide,divide
Guicontrol,hide,add
Guicontrol,hide,subtract
Guicontrol,hide,exponent
Guicontrol,hide,equals
Guicontrol,hide,lparen
Guicontrol,hide,rparen
Guicontrol,show,tot
Guicontrol,show,rez
Guicontrol,show,from
Guicontrol,show,to
Guicontrol,show,To:
Guicontrol,show,goaway
Guicontrol,show,gobyebye
Guicontrol,show,mem
Guicontrol,show,equal
Guicontrol,show,RP
}


if units=Mass
{
Guicontrol,, from, |
Guicontrol,, from, kilograms|grams|ounces||pounds|stone|ton|ton(uk)|slugs
Guicontrol,, to, |
Guicontrol,, to, kilograms|grams|ounces||pounds|stone|ton|ton(uk)|slugs
}

if units=Distance
{
Guicontrol,, from, |
Guicontrol,, from, feet|inches||mil|meters|centimeter|kilometer|millimeter|micron|mile|furlong|yard|Angstrom|light year|parsec|AU
Guicontrol,, to, |
Guicontrol,, to, feet|inches||mil|meters|centimeter|kilometer|millimeter|micron|mile|furlong|yard|Angstrom|light year|parsec|AU
}



if units=Acceleration
{
Guicontrol,, from, |
Guicontrol,, from, m/s²||in/s²|ft/s²|g's
Guicontrol,, to, |
Guicontrol,, to, m/s²||in/s²|ft/s²|g's
}








if units=Time
{
Guicontrol,, from, |
Guicontrol,, from, seconds||minutes|hours|days|weeks|months(30d)|years
Guicontrol,, to, |
Guicontrol,, to, seconds||minutes|hours|days|weeks|months(30d)|years
}


if units=Area
{
Guicontrol,, from, |
Guicontrol,, from, m²||cm²|mm²|micron²|in²|ft²|yd²|mil²|acre
Guicontrol,, to, |
Guicontrol,, to, m²||cm²|mm²|micron²|in²|ft²|yd²|mil²|acre
}

if units=Volume
{
Guicontrol,, from, |
Guicontrol,, from, m³||cm³|mm³|in³|ft³|yd³|ounce|pint|quart|tsp|tbsp|liter
Guicontrol,, to, |
Guicontrol,, to, m³||cm³|mm³|in³|ft³|yd³|ounce|pint|quart|tsp|tbsp|liter
}



if units=Temperature
{
Guicontrol,, from, |
Guicontrol,, from, Kelvin||Celsius|Fahrenheit|Rankine|Reaumur
Guicontrol,, to, |
Guicontrol,, to, Kelvin||Celsius|Fahrenheit|Rankine|Reaumur
}

if units=Speed
{
Guicontrol,, from, |
Guicontrol,, from, m/s||km/h|in/s|ft/s|yard/s|mph|Mach Number|speed of light
Guicontrol,, to, |
Guicontrol,, to, m/s||km/h|in/s|ft/s|yard/s|mph|Mach Number|speed of light
}





gosub, calc
return

calc:
gui, submit, nohide
SetFormat, Float, 0.2

;distance from
if from=feet
from=1.0
if from=inches
from:=.0833333
if from=mil
from:=.0000833333
if from=microns
from:=3.2808E-6
if from=meters
from=3.2808
if from=kilometer
from=3280.8399
if from=centimeter
from=0.032808399
if from=millimeter
from=0.0032808399
if from=mile
from=5280
if from=furlong
from=660
if from=yard
from=3
if from=Angstrom
from=3.280839895E-10
if from=light year
from=31017896836000000
if from=parsec
from=101236138050000000
if from=AU
from=490806662370
;distance to
if to=feet
to=1.0
if to=inches
to:=.0833333
if to=mil
to:=.0000833333
if to=micron
to:=3.2808E-6
if to=meters
to=3.2808
if to=kilometer
to=3280.8399
if to=centimeter
to=0.032808399
if to=millimeter
to=0.0032808399
if to=mile
to=5280
if to=furlong
to=660
if to=yard
to=3
if to=Angstrom
to=3.280839895E-10
if to=light year
to=31017896836000000
if to=parsec
to=101236138050000000
if to=AU
to=490806662370


;Area from
If From=m²
From=1.0
If From=cm²
From=.0001
If From=mm²
From=0.000001
If From=micron²
From=1.0E-12
If From=in²
From=0.00064516
If From=ft²
From=0.09290304
If From=yd²
From=0.83612736
If From=mil²
From=6.4516E-10
If From=acre
From=4046.8564224
;Area to
If To=m²
To=1.0
If To=cm²
To=.0001
If To=mm²
To=0.000001
If To=micron²
To=1.0E-12
If To=in²
To=0.00064516
If To=ft²
To=0.09290304
If To=yd²
To=0.83612736
If To=mil²
To=6.4516E-10
If To=acre
To=4046.8564224

;Volume from
If From=m³
From=1.0
If From=cm³
From=0.000001
If From=mm³
From=1.0E-9
If From=in³
From=0.000016387064
If From=ft³
From=0.028316846592
If From=yd³
From=0.76455485798
If From=cup
From=0.0002365882365
If From=ounce
From=0.000029573529563
If From=pint
From=0.000473176473
If From=quart
From=0.000946352946
If From=tsp
From=0.0000049289215938
If From=tbsp
From=0.000014786764781
If From=liter
From=0.001
;Volume to
If To=m³
To=1.0
If To=cm³
To=0.000001
If To=mm³
To=1.0E-9
If To=in³
To=0.000016387064
If To=ft³
To=0.028316846592
If To=yd³
To=0.76455485798
If To=cup
To=0.0002365882365
If To=ounce
To=0.000029573529563
If To=pint
To=0.000473176473
If To=quart
To=0.000946352946
If To=tsp
To=0.0000049289215938
If To=tbsp
To=0.000014786764781
If To=liter
To=0.001

;Angle from
If From=radians
From=1.0
If From=degrees
From=0.01745329252
If From=minute
From=0.00029088820867
If From=second
From=0.0000048481368111
If From=mils
From=0.00098174770425
If From=grad
From=0.015707963268
If From=cycle
From=6.2831853072
If From=circle
From=6.2831853072
;Angle to
If To=radians
To=1.0
If To=degrees
To=0.01745329252
If To=minute
To=0.00029088820867
If To=second
To=0.0000048481368111
If To=mils
To=0.00098174770425
If To=grad
To=0.015707963268
If To=cycle
To=6.2831853072
If To=circle
To=6.2831853072

;weight from
If From=Kilograms
From=2.2046226218
If From=Grams
From=0.0022046226218
If From=Ounces
From=0.0625
If From=Pounds
From=1
If From=Stone
From=14
If From=Ton
From=2000
If From=Ton(Uk)
From=2240
If From=slugs
From=32.174048695
;weight to
If To=Kilograms
To=2.2046
If To=Grams
To=0.0022046226218
If To=Ounces
To=0.0625
If To=Pounds
To=1
If To=Stone
To=14
If To=Ton
To=2000
If To=Ton(Uk)
To=2240
If To=slugs
To=32.174048695

;density from
If From=lb/in³
From=1
If From=lb/ft³
From=0.000578703
If From=Kg/m³
From=3.6127E-5
If From=slugs/ft³
From=515.31788206
If From=g/cm³
From=0.036127292927
;density to
If To=lb/in³
To=1
If To=lb/ft³
To=0.000578703
If To=Kg/m³
To=3.6127E-5
If To=slugs/ft³
To=515.31788206
If To=g/cm³
To=0.036127292927

;acceleration from
If From=m/s²
From=1
If From=in/s²
From=0.0254
If From=ft/s²
From=0.3048
If From=g's
From=9.80665
;acceleration to
If To=m/s²
To=1
If To=in/s²
To=0.0254
If To=ft/s²
To=0.3048
If To=g's
To=9.80665






;Time from
If From=seconds
From=1
If From=minutes
From=60
If From=hours
From=3600
If From=days
From=86400
If From=weeks
From=604800
If From=months(30d)
From=2592000
If From=years
From=31536000
;Time to
If To=seconds
To=1
If To=minutes
To=60
If To=hours
To=3600
If To=days
To=86400
If To=weeks
To=604800
If To=months(30d)
To=2592000
If To=years
To=31536000


;Speed from
If From=m/s
From=1
If From=km/h
From=0.277777777778
If From=in/s
From=0.0254
If From=ft/s
From=0.3048
If From=yard/s
From=0.9144
If From=mph
From=0.44704
If From=Mach Number
From=340.2933
If From=speed of light
From=299790000
;Speed to
If To=m/s
To=1
If To=km/h
To=0.277777777778
If To=in/s
To=0.0254
If To=ft/s
To=0.3048
If To=yard/s
To=0.9144
If To=mph
To=0.44704
If To=Mach Number
To=340.2933
If To=speed of light
To=299790000



val:=(from/to)*tot


;Temperature Equation - SPECIAL CASE
If units=Temperature
   {
   If From=Kelvin
     {
     If To=Kelvin
        val:=tot
     If To=Fahrenheit
        val:=tot*9/5-459.67
     If To=Celsius
        val:=tot-273.15
     If To=Rankine
        val:=tot*9/5
     If To=Reaumur
        val:=(tot-273.15)*4/5
     }
   Else If From=Fahrenheit
     {
     If To=Kelvin
        val:=(tot+459.67)*5/9
     If To=Fahrenheit
        val:=tot
     If To=Celsius
        val:=(tot-32)*5/9
     If To=Rankine
        val:=tot+459.67
     If To=Reaumur
        val:=(tot-32)*4/9
     }
   Else If From=Celsius
     {
     If To=Kelvin
        val:=tot+273.15
     If To=Fahrenheit
        val:=tot*9/5+32
     If To=Celsius
        val:=tot
     If To=Rankine
        val:=(tot+273.15)*9/5
     If To=Reaumur
        val:=tot*4/5
     }
   Else If From=Rankine
     {
     If To=Kelvin
        val:=tot*5/9
     If To=Fahrenheit
        val:=tot-459.67
     If To=Celsius
        val:=(tot-491.67)*5/9
     If To=Rankine
        val:=tot
     If To=Reaumur
        val:=(tot-491.67)*4/9
     }
   Else If From=Reaumur
     {
     If To=Kelvin
        val:=tot*5/4+273.15
     If To=Fahrenheit
        val:=tot*9/4+32
     If To=Celsius
        val:=tot*5/4
     If To=Rankine
        val:=tot*9/4+491.67
     If To=Reaumur
        val:=tot
     }
   }



if pre
   SetFormat, float, %RegP%E
else
   SetFormat, float, %RegP%
val := val + 0
guicontrol,, rez, %val%
return










;=============================================================================================================
;=============================================================================================================
;=============================================================================================================
; Expression Evaluation code by Laszlo at http://www.autohotkey.com/forum/viewtopic.php?t=17058
;
; ALL THE CODE FROM HERE AND BELOW IS ONLY FOR CALCULATOR / EXPRESSION EVALUATOR!!
;
;=============================================================================================================


SetFormat Float, 0.16e                         ; max precise AHK internal format

ButtonHelp:                                    ; Alt-H

If units=CALCULATOR
{
   MsgBox,                                     ; list of shortcuts, functions
(
Shortcut commands:
   Alt-V, Enter: evaluate expression
   Alt-c, Clear: clear calculator

Functions (AHK's and the following):

   MONSTER Version 1.1 (needs AHK 1.0.46.12+)
   EVALUATE ARITHMETIC EXPRESSIONS containing HEX, Binary ('1001), scientific numbers (1.2e+5)
   (..); variables, constants: e, pi;
   (? :); logicals ||; &&; relationals =,<>; <,>,<=,>=; user operators GCD,MIN,MAX,Choose;
   |; ^; &; <<, >>; +, -; *, /, \ (or  = mod); ** (or @ = power); !,~;
   
   Functions AHK's and Abs|Ceil|Exp|Floor|Log|Ln|Round|Sqrt|Sin|Cos|Tan|ASin|ACos|ATan|SGN|Fib|fac;
   User defined functions: f(x) := expr;

Math Constants:
   pi  = pi       e   = e

)
}
Return

Eval(x) {                              ; non-recursive PRE/POST PROCESSING: I/O forms, numbers, ops, ";"
   Local FORM, FormF, FormI, i, W, y, y1, y2, y3, y4
   FormI := A_FormatInteger, FormF := A_FormatFloat

   SetFormat Integer, D                ; decimal intermediate results!
   RegExMatch(x, "\$(b|h|x|)(\d*[eEgG]?)", y)
   FORM := y1, W := y2                 ; HeX, Bin, .{digits} output format
   SetFormat FLOAT, 0.16e              ; Full intermediate float precision
   StringReplace x, x, %y%             ; remove $..
   Loop
      If RegExMatch(x, "i)(.*)(0x[a-f\d]*)(.*)", y)
         x := y1 . y2+0 . y3           ; convert hex numbers to decimal
      Else Break
   Loop
      If RegExMatch(x, "(.*)'([01]*)(.*)", y)
         x := y1 . FromBin(y2) . y3    ; convert binary numbers to decimal: sign = first bit
      Else Break
   x := RegExReplace(x,"(^|[^.\d])(\d+)(e|E)","$1$2.$3") ; add missing '.' before E (1e3 -> 1.e3)
                                       ; literal scientific numbers between ‘ and ’ chars
   x := RegExReplace(x,"(\d*\.\d*|\d)([eE][+-]?\d+)","‘$1$2’")

   StringReplace x, x,`%, \, All       ; %  -> \ (= MOD)
   StringReplace x, x, **,@, All       ; ** -> @ for easier process
   StringReplace x, x, +, ±, All       ; ± is addition
   x := RegExReplace(x,"(‘[^’]*)±","$1+") ; ...not inside literal numbers
   StringReplace x, x, -, ¬, All       ; ¬ is subtraction
   x := RegExReplace(x,"(‘[^’]*)¬","$1-") ; ...not inside literal numbers

   Loop Parse, x, `;
      y := Eval1(A_LoopField)          ; work on pre-processed sub expressions
                                       ; return result of last sub-expression (numeric)
   If FORM = b                         ; convert output to binary
      y := W ? ToBinW(Round(y),W) : ToBin(Round(y))
   Else If (FORM="h" or FORM="x") {
      if pre
         SetFormat, float, %RegP%E
      else
         SetFormat, float, %RegP%
;      SetFormat Integer, Hex           ; convert output to hex
      y := Round(y) + 0
   }
   Else {
      W := W="" ? "0.6g" : "0." . W    ; Set output form, Default = 6 decimal places
      if pre
         SetFormat, float, %RegP%E
      else
         SetFormat, float, %RegP%
;      SetFormat FLOAT, %W%
      y += 0.0
   }
   if pre
      SetFormat, float, %RegP%E
   else
      SetFormat, float, %RegP%
;   SetFormat Integer, %FormI%          ; restore original formats
;   SetFormat FLOAT,   %FormF%
   Return y
}

Eval1(x) {                             ; recursive PREPROCESSING of :=, vars, (..) [decimal, no ";"]
   Local i, y, y1, y2, y3
                                       ; save function definition: f(x) := expr
   If RegExMatch(x, "(\S*?)\((.*?)\)\s*:=\s*(.*)", y) {
      f%y1%__X := y2, f%y1%__F := y3
      Return
   }
                                       ; execute leftmost ":=" operator of a := b := ...
   If RegExMatch(x, "(\S*?)\s*:=\s*(.*)", y) {
      y := "x" . y1                    ; user vars internally start with x to avoid name conflicts
      Return %y% := Eval1(y2)
   }
                                       ; here: no variable to the left of last ":="
   x := RegExReplace(x,"([\)’.\w]\s+|[\)’])([a-z_A-Z]+)","$1«$2»")  ; op -> «op»

   x := RegExReplace(x,"\s+")          ; remove spaces, tabs, newlines

   x := RegExReplace(x,"([a-z_A-Z]\w*)\(","'$1'(") ; func( -> 'func'( to avoid atan|tan conflicts

   x := RegExReplace(x,"([a-z_A-Z]\w*)([^\w'»’]|$)","%x$1%$2") ; VAR -> %xVAR%
   x := RegExReplace(x,"(‘[^’]*)%x[eE]%","$1e") ; in numbers %xe% -> e
   x := RegExReplace(x,"‘|’")          ; no more need for number markers
   Transform x, Deref, %x%             ; dereference all right-hand-side %var%-s

   Loop {                              ; find last innermost (..)
      If RegExMatch(x, "(.*)\(([^\(\)]*)\)(.*)", y)
         x := y1 . Eval@(y2) . y3      ; replace (x) with value of x
      Else Break
   }

   Return Eval@(x)
}

Eval@(x) {                             ; EVALUATE PRE-PROCESSED EXPRESSIONS [decimal, NO space, vars, (..), ";", ":="]
   Local i, y, y1, y2, y3, y4

   If x is number                      ; no more operators left
      Return x
                                       ; execute rightmost ?,: operator
   RegExMatch(x, "(.*)(\?|:)(.*)", y)
   IfEqual y2,?,  Return Eval@(y1) ? Eval@(y3) : ""
   IfEqual y2,:,  Return ((y := Eval@(y1)) = "" ? Eval@(y3) : y)

   StringGetPos i, x, ||, R            ; execute rightmost || operator
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) || Eval@(SubStr(x,3+i))
   StringGetPos i, x, &&, R            ; execute rightmost && operator
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) && Eval@(SubStr(x,3+i))
                                       ; execute rightmost =, <> operator
   RegExMatch(x, "(.*)(?<![\<\>])(\<\>|=)(.*)", y)
   IfEqual y2,=,  Return Eval@(y1) =  Eval@(y3)
   IfEqual y2,<>, Return Eval@(y1) <> Eval@(y3)
                                       ; execute rightmost <,>,<=,>= operator
   RegExMatch(x, "(.*)(?<![\<\>])(\<=?|\>=?)(?![\<\>])(.*)", y)
   IfEqual y2,<,  Return Eval@(y1) <  Eval@(y3)
   IfEqual y2,>,  Return Eval@(y1) >  Eval@(y3)
   IfEqual y2,<=, Return Eval@(y1) <= Eval@(y3)
   IfEqual y2,>=, Return Eval@(y1) >= Eval@(y3)
                                       ; execute rightmost user operator (low precedence)
   RegExMatch(x, "i)(.*)«(.*?)»(.*)", y)
   IfEqual y2,choose,Return Choose(Eval@(y1),Eval@(y3))
   IfEqual y2,Gcd,   Return GCD(   Eval@(y1),Eval@(y3))
   IfEqual y2,Min,   Return (y1:=Eval@(y1)) < (y3:=Eval@(y3)) ? y1 : y3
   IfEqual y2,Max,   Return (y1:=Eval@(y1)) > (y3:=Eval@(y3)) ? y1 : y3

   StringGetPos i, x, |, R             ; execute rightmost | operator
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) | Eval@(SubStr(x,2+i))
   StringGetPos i, x, ^, R             ; execute rightmost ^ operator
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) ^ Eval@(SubStr(x,2+i))
   StringGetPos i, x, &, R             ; execute rightmost & operator
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) & Eval@(SubStr(x,2+i))
                                       ; execute rightmost <<, >> operator
   RegExMatch(x, "(.*)(\<\<|\>\>)(.*)", y)
   IfEqual y2,<<, Return Eval@(y1) << Eval@(y3)
   IfEqual y2,>>, Return Eval@(y1) >> Eval@(y3)
                                       ; execute rightmost +- (not unary) operator
   RegExMatch(x, "(.*[^!\~±¬\@\*/\\])(±|¬)(.*)", y) ; lower precedence ops already handled
   IfEqual y2,±,  Return Eval@(y1) + Eval@(y3)
   IfEqual y2,¬,  Return Eval@(y1) - Eval@(y3)
                                       ; execute rightmost */% operator
   RegExMatch(x, "(.*)(\*|/|\\)(.*)", y)
   IfEqual y2,*,  Return Eval@(y1) * Eval@(y3)
   IfEqual y2,/,  Return Eval@(y1) / Eval@(y3)
   IfEqual y2,\,  Return Mod(Eval@(y1),Eval@(y3))
                                       ; execute rightmost power
   StringGetPos i, x, @, R
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) ** Eval@(SubStr(x,2+i))
                                       ; execute rightmost function, unary operator
   If !RegExMatch(x,"(.*)(!|±|¬|~|'(.*)')(.*)", y)
      Return x                         ; no more function (y1 <> "" only at multiple unaries: --+-)
   IfEqual y2,!,Return Eval@(y1 . !y4) ; unary !
   IfEqual y2,±,Return Eval@(y1 .  y4) ; unary +
   IfEqual y2,¬,Return Eval@(y1 . -y4) ; unary - (they behave like functions)
   IfEqual y2,~,Return Eval@(y1 . ~y4) ; unary ~
   If IsLabel(y3)
      GoTo %y3%                        ; built-in functions are executed last: y4 is number
   Return Eval@(y1 . Eval1(RegExReplace(f%y3%__F, f%y3%__X, y4))) ; user defined function
Abs:
   Return Eval@(y1 . Abs(y4))
Ceil:
   Return Eval@(y1 . Ceil(y4))
Exp:
   Return Eval@(y1 . Exp(y4))
Floor:
   Return Eval@(y1 . Floor(y4))
Log:
   Return Eval@(y1 . Log(y4))
Ln:
   Return Eval@(y1 . Ln(y4))
Round:
   Return Eval@(y1 . Round(y4))
Sqrt:
   Return Eval@(y1 . Sqrt(y4))
Sin:
   Return Eval@(y1 . Sin(y4))
Cos:
   Return Eval@(y1 . Cos(y4))
Tan:
   Return Eval@(y1 . Tan(y4))
ASin:
   Return Eval@(y1 . ASin(y4))
ACos:
   Return Eval@(y1 . ACos(y4))
ATan:
   Return Eval@(y1 . ATan(y4))
Sgn:
   Return Eval@(y1 . (y4>0)) ; Sign of x = (x>0)-(x<0)
Fib:
   Return Eval@(y1 . Fib(y4))
Fac:
   Return Eval@(y1 . Fac(y4))
}

ToBin(n) {      ; Binary representation of n. 1st bit is SIGN: -8 -> 1000, -1 -> 1, 0 -> 0, 8 -> 01000
   Return n=0||n=-1 ? -n : ToBin(n>>1) . n&1
}
ToBinW(n,W=8) { ; LS W-bits of Binary representation of n
   Loop %W%     ; Recursive (slower): Return W=1 ? n&1 : ToBinW(n>>1,W-1) . n&1
      b := n&1 . b, n >>= 1
   Return b
}
FromBin(bits) { ; Number converted from the binary "bits" string, 1st bit is SIGN
   n = 0
   Loop Parse, bits
      n += n + A_LoopField
   Return n - (SubStr(bits,1,1)<<StrLen(bits))
}

GCD(a,b) {      ; Euclidean GCD
   Return b=0 ? Abs(a) : GCD(b, mod(a,b))
}
Choose(n,k) {   ; Binomial coefficient
   p := 1, i := 0, k := k < n-k ? k : n-k
   Loop %k%                   ; Recursive (slower): Return k = 0 ? 1 : Choose(n-1,k-1)*n//k
      p *= (n-i)/(k-i), i+=1  ; FOR INTEGERS: p *= n-i, p //= ++i
   Return Round(p)
}

Fib(n) {        ; n-th Fibonacci number (n < 0 OK, iterative to avoid globals)
   a := 0, b := 1
   Loop % abs(n)-1
      c := b, b += a, a := c
   Return n=0 ? 0 : n>0 || n&1 ? b : -b
}
fac(n) {        ; n!
   Return n<2 ? 1 : n*fac(n-1)
}
