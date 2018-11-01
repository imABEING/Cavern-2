<Cabbage>

form caption("Cavern"), size(600, 500), pluginid("Cavern"), colour("0, 0, 0")
image file("bluePlate.jpg"), bounds(0, 0, 600, 500), outlinecolour(0, 0, 0, 255), 


;{
;checkbox bounds(206, 288, 20, 20), channel("led1"), text(""), shape("circle") colour:1(0, 45, 0, 255)
;checkbox bounds(191, 246, 20, 20), channel("led2"), text(""), shape("round")  colour(0, 60, 0) 
;checkbox bounds(188, 206, 20, 20), channel("led3"), text(""), shape("circle") colour:1(0, 75, 0, 255)
;checkbox bounds(212, 170, 20, 20), channel("led4"), text(""), shape("circle") colour:1(0, 100, 0, 255)
;checkbox bounds(259, 140, 20, 20), channel("led5"), text(""), shape("round")  colour(0, 125, 0) 
;checkbox bounds(317, 140, 20, 20), channel("led6"), text(""), shape("circle") colour:1(0, 150, 0, 255)
;checkbox bounds(358, 170, 20, 20), channel("led7"), text(""), shape("round")  colour(0, 175, 0) 
;checkbox bounds(386, 206, 20, 20), channel("led8"), text(""), shape("round")  colour(0, 200, 0) 
;checkbox bounds(386, 246, 20, 20), channel("led9"), text(""), shape("circle") colour:1(0, 225, 0, 255)
;checkbox bounds(374, 288, 20, 20), channel("led10"), text(""), shape("round") colour(0, 255, 0) 
;}


image file("Cavern.png"), bounds(90, 12, 420, 116), , outlinecolour(0, 0, 0, 255)

;Feedback
image file("knob_10_shadow_001.png"), bounds(200, 160, 200, 200), tofront(), outlinecolour("0, 0, 0")
image bounds(200, 160, 200, 200), file("knob_05_001.png") 
image bounds(200, 160, 200, 200), file("knob_05_001.png"), identchannel("sliderFeed")
rslider bounds(200, 160, 200, 200), channel("reverb"), range(0, 1, 0, 1, .01), trackercolour("0, 210, 0, 0"), imgfile("slider", "metalKnob2.png"), imgfile("background", "tp.png"), alpha(0)

;Vol
image file("knob_10_shadow_001.png"), bounds(40, 300, 140, 140), tofront(), outlinecolour("0, 0, 0")
image bounds(40, 280, 140, 140), file("knob_05_001.png") 
image bounds(40, 280, 140, 140), file("knob_05_001.png"), identchannel("sliderVol")
rslider bounds(40, 280, 140, 140), channel("dry"), range(0.03, 1, 0, 1, .01), trackercolour("0, 210, 0, 0"), imgfile("slider", "metalKnob2.png"), imgfile("background", "tp.png"), alpha(0)

;Pitch Mod
image file("knob_10_shadow_001.png"), bounds(230, 360, 140, 140), tofront(), outlinecolour("0, 0, 0")
image bounds(230, 360, 140, 140), file("knob_05_001.png") 
image bounds(230, 360, 140, 140), file("knob_05_001.png"), identchannel("sliderMod")
rslider bounds(230, 360, 140, 140), channel("color"), range(0.03, 1, 0, 1, .01), trackercolour("0, 210, 0, 0"), imgfile("slider", "metalKnob2.png"), imgfile("background", "tp.png"), alpha(0)

;Cutoff
image file("knob_10_shadow_001.png"), bounds(420, 300, 140, 140), tofront(), outlinecolour("0, 0, 0")
image bounds(420, 280, 140, 140), file("knob_05_001.png") 
image bounds(420, 280, 140, 140), file("knob_05_001.png"), identchannel("sliderCutoff")
rslider bounds(420, 280, 140, 140), channel("cutoff"), range(20, 20000, 16000, 1, .1), trackercolour("0, 210, 0, 0"), imgfile("slider", "metalKnob2.png"), imgfile("background", "tp.png"), alpha(0)
;label align("centre"),  alpha(.35), bounds(350, 370, 150, 20), channel("chan"), colour("0,0,0,0"), fontcolour("0,192,192"), text("@rolexalexx")


</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-o dac
-d
-i adc
</CsOptions>
<CsInstruments>
sr        = 44100
ksmps     = 64
nchnls    = 2
0dbfs	  = 1

instr 1
gkfeed init 0.05
gkvol init 0.1
gkfco init 16000
gkpm = 20
;0 - 20


gkfeed = chnget:k("reverb")
gkvol = chnget:k("dry")
gkpm = chnget:k("color")
gkfco = chnget:k("cutoff")

if metro(25) == 1 then
        if changed(gkfeed) == 1 then
            SMessage sprintfk "rotate(%f, 100, 80, 80)", (gkfeed*3.14159265359)*1.5
            chnset SMessage, "sliderFeed"
        endif
    endif

if metro(25) == 1 then
        if changed(gkvol) == 1 then
            SMessage sprintfk "rotate(%f, 70, 55)", (gkvol*3.14159265359)*1.5
            chnset SMessage, "sliderVol"
        endif
    endif
    
if metro(25) == 1 then
        if changed(gkpm) == 1 then
            SMessage sprintfk "rotate(%f, 70, 55)", (gkpm*3.14159265359)*1.5
            chnset SMessage, "sliderMod"
        endif
    endif
    
if metro(30) == 1 then
        if changed(gkfco) == 1 then
            SMessage sprintfk "rotate(%f, 70, 55)", (gkfco*3.14159265359)*1.5
            chnset SMessage, "sliderCutoff"
        endif
    endif

asig1 init 0
asig2 init 0
;aenv adsr .1, .2, .2, .2
asig1,asig2 ins

;hpf
;


arev, arev2 reverbsc asig1, asig2, gkfeed, gkfco, sr, i(gkpm), 1
printk2 gkpm
printk2 gkfco

;ares balance asig, acomp [, ihp] [, iskip] 

ktrig	changed	gkfeed, gkpm, gkvol, gkfco
 if ktrig==1 then
  reinit	UpdateValues
 endif
 UpdateValues:
 gkfeed		=	    gkfeed
 gkpm		=	    i(gkpm)
 gkvol		=	    gkvol
 gkfco	    =	    gkfco
 rireturn

outs asig1*gkvol, asig2*gkvol
outs arev, arev2


garvb  = 0	;clear
endin
</CsInstruments>
<CsScore>
f 1 0 16384 9 1
i 1 0 z
</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
