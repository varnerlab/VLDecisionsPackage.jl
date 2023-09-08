# load the package -
using VLDecisionsPackage

# setup my problem object -
configuration_array = [

    # CPU options
    0.2 2640.0 ; # 1 CPU 1
    0.8 3649.0 ; # 2 CPU 2

    # Memory options
    0.1 3840.0 ; # 3 Memory 1
    0.2 4640.0 ; # 4 Memory 2
    0.3 3600.0 ; # 5 Memory 3

    # Storage options -
    0.1 1440.0   ; # 6 Storage 1
    0.2 1840.0   ; # 7 Storage 2
    0.3 2440.0   ; # 8 Storage 3
    0.4 3640.0   ; # 9 Storage 4

    # Accessory options
    0.2 79.0    ; # 10 Accessory 1
    0.4 129.0   ; # 11 Accessory 2
    0.4 149.0   ; # 12 Accessory 3
];

# setup the call -
α = configuration_array[:,1];
c = configuration_array[:,2];

# Choice constraint matrix -
C = zeros(4,12);
C[1,1:2] .= 1;
C[2,3:5] .= 1;
C[3,6:9] .= 1;
C[4,10:12] .= 1;

problem = build(MySimpleBinaryVariableLinearChoiceProblem, (
    
    α = α,
    c = c,
    I = 10000.0,

    initial = zeros(12),

    # we choose a feature or we dont -
    bounds = [
        0  1 ; # 1 CPU 1
        0  1 ; # 2 CPU 2
        
        0  1 ; # 3 Memory 1
        0  1 ; # 4 Memory 2
        0  1 ; # 5 Memory 3

        0  1 ; # 6 Storage 1
        0  1 ; # 7 Storage 2
        0  1 ; # 8 Storage 3
        0  1 ; # 9 Storage 4

        0  1 ; # 10 Accessory 1
        0  1 ; # 11 Accessory 2
        0  1 ; # 12 Accessory 3
    ],

    # extra constraints -
    C = C
));

solution = solve(problem);
