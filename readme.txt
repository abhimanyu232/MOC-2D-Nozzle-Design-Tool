Nozzle_Design_Tool V1.0 21-05-2016
===================================
This tool was developed as a part of B.Tech Major Project at Amity University, NOIDA.
Programmers: Shivang Tyagi, Abhimanyu Bhadauria
Project Guide: Prof. AK Verma
===================================

This tool can be utilised to design a supersonic Contour nozzle via an interactive User Interface.
Follow these steps in order to use the tool,
1. Enter Supersonic Mach No. (M=1.2 to 5). Method of characteristics is valid only for supersonic case.
2. Enter Ratio of Specific Heats (Gamma).
3. Enter Number of finite waves to be used for calculation. 
   (use numbers between 15-40, where 15 gives fastest results and 40 will give the most accurate)
4. Enter radius of curvature of the expansion section. 
   (radius to be entered as a multiplier of unit throat radius, i.e if the curvatre radius is 3 times the throat radius, then enter 3)
5. Plot minimum length nozzle. this nozzle will not have an expansion section.
6. Plot Ideal nozzle. This nozzle will have an expansion section with radius of curvature specified by the user.
7. User can obtain formatted Wall Point data to exort the coordinates in any software for further processing. (Catia, Ansys etc).
8. The plot figures and formatted point data are temporary files. the user will have to save both of the files before exiting.

===================================

For further assistance user may reach.
Shivang Tyagi : tyagishivang@gmail.com
Abhimanyu Bhadauria: abhimanyu232@gmail.com

User can view code validation reports by visiting the hyperlink provided on the gui.
the application was validated at Mach 2 using CFD analysis on Ansys Package.
