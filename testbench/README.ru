
<<<<<<< HEAD:testbench/READMEru
п▓ п╢п╟п╫п╫п╬п╧ п©п╟п©п╨п╣ п©я─п╣п╢я│я┌п╟п╡п╩п╣п╫п╫п╬ п╡я│п╣ п╫п╣п╬п╠я┘п╬п╢п╦п╪п╬п╣ п╢п╩я▐ я│п╦п╪п╪я┐п╩я▐я├п╦п╦ п╪п╬п╢я┐п╩я▐ п╡
п©я─п╬пЁя─п╟п╪п╪п╣ ModelSim.
=======
В данной папке представленно все необходимое для симуляции модуля 
в программе ModelSim.
>>>>>>> 80790920256cb865d85de54076833bc418ed182f:testbench/README.ru

п■п╩я▐ п╦п╥п╪п╣п╫п╣п╫п╦я▐ п©п╟я─п╟п╪п╣я┌я─п╬п╡ я│п╦п╪п╪я┐п╩п╦я─я┐п╣п╪п╬пЁп╬ п╪п╬п╢я┐п╩я▐, п╪п╬п╤п╫п╬ п╦п╥п╪п╣п╫п╦я┌я▄
п╥п╫п╟я┤п╣п╫п╦п╣ п╫я┐п╤п╫п╬пЁп╬ п©п╟я─п╟п╪п╣я┌я─п╟ п╡ я└п╟п╧п╩п╣ defines.vh. п╒п╟п╨п╤п╣ п╡ я█я┌п╬п╪ я└п╟п╧п╩п╣
п╪п╬п╤п╫п╬ п╦п╥п╪п╣п╫п╦я┌я▄ п╦п╪п╣п╫п╟ я└п╟п╧п╩п╬п╡, п╨п╬я┌п╬я─я▀п╣ п╠я┐п╢я┐я┌ п╦я│п©п╬п╩я▄п╥п╬п╡п╟п╫п╫я▀ п╡ п©я─п╬я├п╣я│я│п╣
я│п╦п╪я┐п╩я▐я├п╦п╦.

п■п╩я▐ п©я─п╬п╡п╣п╢п╣п╫п╦я▐ я│п╦п╪я┐п╩я▐я├п╦п╦ п╫п╣п╬п╠я┘п╬п╢п╦п╪п╬ п╡я▀п©п╬п╩п╫п╦я┌я▄ я│п╩п╣п╢я┐я▌я┴п╦п╣ п╢п╣п╧я│я┌п╡п╦я▐:

  1) п÷п╬п╢пЁп╬я┌п╬п╡п╦я┌я▄ я└п╟п╧п╩ я│ п╢п╟п╫п╫я▀п╪п╦, п╦ я└п╟п╧п╩ я│ п╫п╟я│я┌я─п╬п╧п╨п╟п╪п╦ (п╦я│п©п╬п╩я▄п╥я┐я▐
     /py_utils/util_for_sim.py) я│п╪. README п╡ п©п╟п©п╨п╣ py_utils.

  2) пёп╠п╣п╢п╦я┌я▄я│я▐, я┤я┌п╬ п╦п╪п╣п╫п╟ я└п╟п╧п╩п╬п╡ я│ п╢п╟п╫п╫я▀п╪п╦ п╦ п╫п╟я│я┌я─п╬п╧п╨п╟п╪п╦ я│п╬п╬я┌п╡п╣я┌я│я┌п╡я┐я▌я┌
     п╡я▀п╠я─п╟п╫п╫я▀п╪ п╡ я└п╟п╧п╩п╣ defines.vh. п╒п╟п╨п╤п╣ п╡я▀п╠я─п╟я┌я▄ п╤п╣п╩п╟п╣п╪п╬п╣ п╫п╟п╥п╡п╟п╫п╦п╣
     п╢п╩я▐ п╡я▀я┘п╬п╢п╫п╬пЁп╬ я└п╟п╧п╩п╟, п╦ п╫я┐п╤п╫я▀п╣ п╫п╟я│я┌я─п╬п╧п╨п╦ п╪п╬п╢я┐п╩я▐ 
     ( п²п╟п©п╬п╪п╦п╫п╟я▌:
        п÷п╟я─п╟п╪п╣я┌я─я▀ п╪п╬п╢я┐п╩я▐ (п╪п╟п╨я│п╦п╪п╟п╩я▄п╫п╟я▐, п╪п╦п╫п╦п╪п╟п╩я▄п╫п╟я▐ п╢п╩п╦п╫п╟ я│я┌я─п╬п╨п╦) п╪п╬п╤п╫п╬
        п╦п╥п╪п╣п╫п╦я┌я▄ п╡ я└п╟п╧п╩п╣ top_bloom.sv. п÷п╟я─п╟п╪п╣я┌я─я▀ HASH_CNT п╦ HASH_WIDTH
        п╡ п╢п╟п╫п╫п╬п╧ я─п╣п╟п╩п╦п╥п╟я├п╦п╦ п╫п╣ пЁп╬я┌п╬п╡я▀ п╨ п╦п╥п╪п╣п╫п╣п╫п╦я▌! )

  3) п≈п╟п©я┐я│я┌п╦я┌я▄ я│п╨я─п╦п©я┌ я│п╦п╪я┐п╩я▐я├п╦п╦ я│п╩п╣п╢я┐я▌я┴п╣п╧ п╨п╬п╪п╟п╫п╢п╬п╧:
       
       vsim -do make.do

  4) п▓ п╬п╨п╫п╣ wave п╪п╬п╤п╫п╬ п╫п╟п╠п╩я▌п╢п╟я┌я▄ п╡я│п╣ я│п╦пЁп╫п╟п╩я▀ п╡ п╪п╬п╢я┐п╩п╣, п©я─п╦ п╬п╠я─п╟п╠п╬я┌п╨п╣
     п╡п╟я┬п╣пЁп╬ я└п╟п╧п╩п╟ я│ п╢п╟п╫п╫я▀п╪п╦. п▓ п╬п╨п╫п╣ transcript п╬я┌п╬п╠я─п╟п╤п╟п╣я┌я│я▐ п╦п╫я└п╬я─п╪п╟я├п╦я▐
     п╬ я┌п╬п╪, я│п╨п╬п╩я▄п╨п╬ я│я┌я─п╬п╨ п╠я▀п╩п╬ п©я─п╦п╫я▐я┌п╬, п╦ я│п╨п╬п╩я▄п╨п╬ п╠я▀п╩п╬ п╫п╟п╧п╢п╣п╫п╬
     п©п╟я┌я┌п╣я─п╫п╬п╡.

  5) п÷п╬я│п╩п╣ я┌п╬пЁп╬, п╨п╟п╨ п╠я┐п╢я┐я┌ п╬п╠я─п╟п╠п╬я┌п╟п╫я▀ п╡я│п╣ п╢п╟п╫п╫я▀п╣, п²п∙п·п▒п╔п·п■п≤п°п· п÷п═п∙п═п▓п░п╒п╛
     п║п≤п°пёп⌡п╞п╕п≤п╝.

  6) п╒п╣п©п╣я─я▄ п╪п╬п╤п╫п╬ п╬я┌п╨я─я▀я┌я▄ п╡я▀я┘п╬п╢п╫п╬п╧ я└п╟п╧п╩, п╦ п©п╬я│п╪п╬я┌я─п╣я┌я▄, п╡ п╨п╟п╨п╦я┘ п╦п╪п╣п╫п╫п╬
     я│я┌я─п╬я┤п╨п╟я┘ п╠я▀п╩ п╫п╟п╧п╢п╣п╫ п©п╟я┌я┌п╣я─п╫.
