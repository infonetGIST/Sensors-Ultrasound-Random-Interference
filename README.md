# Super-Resolution Ultrasound Imaging utilizing Random Interference and Joint Image Reconstruction

- Simulation codes for MDPI Sensors paper "High-Resolution Ultrasound Imaging Enabled by Random Interference and Joint Image Reconstruction"
authors: Pavel Ni, Heung-No Lee


 Abstract: In ultrasound, wave interference is an undesirable effect that degrades the resolution of the images. We have recently shown that a wavefront of random interference can be used to reconstruct high-resolution ultrasound images. In this study, we further improve the resolution of interference-based ultrasound imaging by proposing a joint image reconstruction scheme. The proposed reconstruction scheme utilizes RF signals from all elements of the sensor array in a joint optimization problem to directly reconstruct final high-resolution images. By jointly processing array signals, we made significant improvements in the ultrasound resolution. The results of the simulation and experimental studies show that the proposed method achieves a superior contrast and image resolution. Furthermore, we share our simulation codes as an open-source repository in support of reproducible research.


Simulation Results
![Simulation results](/readme/Fig_3.png)

 Table 1. MSE, PSNR, and SNR values of conventional and proposed image reconstruction methods
 
|   | Method | MSE | PSNR | SNR |
|---|-------------|-------------|-------------|-------------|
| 1 | Conventional Focused B-mdoe | 144.1 | 5.45 | -4.66 |
| 2 | Interference-based compound method | 0.122 | 19.20 | 6.80 |
| 3 | Interference-based join rec. method | 0.001 | 28.04 | 15.65 |




- Simulation dependencies

1. Filed II ultrasound simulation software (https://field-ii.dk/)
2. Yall 1 algorithm (http://yall1.blogs.rice.edu/)
