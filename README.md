# Code for photosynthesis model in Johnson and Berry (2021) Photosynthesis Research

Author: Jen Johnson (jjohnson@carnegiescience.edu)    
Last revised: 2021-05-17    
[![DOI](https://zenodo.org/badge/367200385.svg)](https://zenodo.org/badge/latestdoi/367200385)

### Citation:

Johnson, J. E. and J. A. Berry. 2021. The role of Cytochrome b<sub>6</sub>f in the 
control of steady-state photosynthesis: a conceptual and quantitative model.
 *Photosynthesis Research*, DOI: [10.1007/s11120-021-00840-4](https://doi.org/10.1007/s11120-021-00840-4)

### Notes:

1. All of these scripts are compatible with MATLAB 2020b as well as GNU Octave 6.2.0. 

2. This directory includes two example simulations which are described below. These call 
functions in the subdirectory `scripts`, and write output to the subdirectory `outputs`.

3. The file `run_forward_example1.m` will simulate the light-response of photosynthesis,
assuming that the absorption cross-sections of PS I and PS II are static. 

4. The file `run_forward_example2.m` will simulate the light-response of photosynthesis,
assuming that (a) under limiting light intensities, state transitions optimize the 
absorption cross-sections of PS I and PS II, and that (b) under saturating light 
intensities, the absorption cross-sections of PS I and PS II are fixed in the position
reached by the light saturation point.

 ### Directory structure:
``` 
├── LICENSE
├── README.md
├── outputs
│   ├── Example-1-static
│   │   ├── Example-1-static-figure1.png
│   │   ├── Example-1-static-modelinputs.mat
│   │   └── Example-1-static-modeloutputs.mat
│   └── Example-2-dynamic
│       ├── Example-2-dynamic-figure1.png
│       ├── Example-2-dynamic-modelinputs.mat
│       └── Example-2-dynamic-modeloutputs.mat
├── run_forward_example1.m
├── run_forward_example2.m
└── scripts
    ├── configure_fun.m
    ├── loadvars_fun.m
    ├── model_fun.m
    ├── plotter_forward_fun.m
    ├── symsolver_fun.m
    └── workspace2struct_fun.m

5 directories, 16 files
```