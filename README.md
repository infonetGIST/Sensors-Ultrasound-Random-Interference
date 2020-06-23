# High-Resolution Ultrasound using Wave Interference
Matlab codes for TUFFC-IEEE paper "High-Resolution Ultrasound using Wave Interference" by Pavel Ni, Heung-No Lee

Abstract
Traditionally, ultrasound interference was considered an undesired effect that degrades the quality of ultrasound images. We have recently shown that an unfocused ultrasound wavefront of random interference can successfully reconstruct high-resolution ultrasound images. Here, we propose to further improve the resolution of interference-based ultrasound imaging by applying a joint image reconstruction scheme. The proposed joint image reconstruction scheme utilizes RF-signals from all array elements to directly reconstruct a final super-resolution image. The simulation study shows two times more accurate contrast resolution and three times better spatial resolution compared to a previously suggested reconstruction scheme. Furthermore, we share our simulation codes as an open-source repository in support of reproducible research.


Simulation Results
![Simulation results](/Fig_3.png)

 Table 1. MSE, PSNR, and SNR values of conventional and proposed image reconstruction methods
 
|   | Method | MSE | PSNR | SNR |
|---|-------------|-------------|-------------|-------------|
| 1 | Conventional Focused B-mdoe | 0.351 |   |   |
| 2 | Interference-based compound method | 0.122 | 19.20 | 6.800 |
| 3 | Interference-based join rec. method | 0.062 | 22.00 | 8.100 |
