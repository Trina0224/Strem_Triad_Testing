#!/bin/bash

#Trina Shih

# Define the array
CCDs=( 0 1 2 3 4 5 6 7
72 73 74 75 76 77 78 79
24 25 26 27 28 29 30 31
48 49 50 51 52 53 54 55
8 9 10 11 12 13 14 15
80 81 82 83 84 85 86 87
32 33 34 35 36 37 38 39
56 57 58 59 60 61 62 63
16 17 18 19 20 21 22 23
88 89 90 91 92 93 94 95
40 41 42 43 44 45 46 47
64 65 66 67 68 69 70 71
0 1 2 3 4 5 6 7)
#The last line 0~7 is for easier loop when firstCCD==11

echo 'Running STREAM...'
export OMP_STACKSIZE=192M
export GOMP_CPU_AFFINITY="0-191:4"
export OMP_NUM_THREADS=8
export LD_LIBRARY_PATH="/home/amd/stream":$LD_LIBRARY_PATH

for ((firstCCD=0; firstCCD<=11; firstCCD++))
do

    # Loop over CCD1 through CCD11
    for ((ccd=0; ccd<=11; ccd++))
    do
            if [ $firstCCD -eq $ccd ]
        then
            ((ccd=$ccd+1))
        fi
        echo "Picked 6 cores from CCD: $firstCCD and Picked 2 cores from CCD: $ccd"
            
            picked_cores=(${CCDs[firstCCD*8]} ${CCDs[firstCCD*8+1]} ${CCDs[firstCCD*8+2]} ${CCDs[firstCCD*8+3]} ${CCDs[firstCCD*8+4]} ${CCDs[firstCCD*8+5]} ${CCDs[ccd*8]} ${CCDs[ccd*8+1]})

            # Generate the string for numactl
            cores_string=$(IFS=, ; echo "${picked_cores[*]}")
            echo "cores_string=$cores_string"
            # Use the generated string in the numactl command
            numactl --physcpubind=$cores_string ./stream_dynamic -nt 10 | grep -i "Triad"
    done



done
