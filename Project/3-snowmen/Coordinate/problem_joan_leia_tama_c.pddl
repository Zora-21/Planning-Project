(define (problem joan_leia_tama_snow_adapted)

    (:domain two_snowman_coordinates)

    (:objects
        ;; Balls
        ball_0 ball_1 ball_2 ball_3 ball_4 ball_5 ball_6 ball_7 ball_8 - ball

        ;; Locations (31x3 grid)
        loc_1_1 loc_1_2 loc_1_3 
        loc_2_1 loc_2_2 loc_2_3 
        loc_3_1 loc_3_2 loc_3_3
        loc_4_1 loc_4_2 loc_4_3 
        loc_5_1 loc_5_2 loc_5_3 
        loc_6_1 loc_6_2 loc_6_3
        loc_7_1 loc_7_2 loc_7_3 
        loc_8_1 loc_8_2 loc_8_3 
        loc_9_1 loc_9_2 loc_9_3
        loc_10_1 loc_10_2 loc_10_3 
        loc_11_1 loc_11_2 loc_11_3 
        loc_12_1 loc_12_2 loc_12_3
        loc_13_1 loc_13_2 loc_13_3 
        loc_14_1 loc_14_2 loc_14_3 
        loc_15_1 loc_15_2 loc_15_3
        loc_16_1 loc_16_2 loc_16_3 
        loc_17_1 loc_17_2 loc_17_3 
        loc_18_1 loc_18_2 loc_18_3
        loc_19_1 loc_19_2 loc_19_3 
        loc_20_1 loc_20_2 loc_20_3 
        loc_21_1 loc_21_2 loc_21_3
        loc_22_1 loc_22_2 loc_22_3 
        loc_23_1 loc_23_2 loc_23_3 
        loc_24_1 loc_24_2 loc_24_3
        loc_25_1 loc_25_2 loc_25_3 
        loc_26_1 loc_26_2 loc_26_3 
        loc_27_1 loc_27_2 loc_27_3
        loc_28_1 loc_28_2 loc_28_3 
        loc_29_1 loc_29_2 loc_29_3 
        loc_30_1 loc_30_2 loc_30_3
        loc_31_1 loc_31_2 loc_31_3 - location
    )

    (:init
        ;; Initializing counters
        (= (total-cost) 0)
        (= (snowman_built) 0)

    
        ;; --- Coordinate assignments for each location ---
        (= (x-coord loc_1_1) 1) (= (y-coord loc_1_1) 1)
        (= (x-coord loc_1_2) 1) (= (y-coord loc_1_2) 2)
        (= (x-coord loc_1_3) 1) (= (y-coord loc_1_3) 3)
        (= (x-coord loc_2_1) 2) (= (y-coord loc_2_1) 1)
        (= (x-coord loc_2_2) 2) (= (y-coord loc_2_2) 2)
        (= (x-coord loc_2_3) 2) (= (y-coord loc_2_3) 3)
        (= (x-coord loc_3_1) 3) (= (y-coord loc_3_1) 1)
        (= (x-coord loc_3_2) 3) (= (y-coord loc_3_2) 2)
        (= (x-coord loc_3_3) 3) (= (y-coord loc_3_3) 3)
        (= (x-coord loc_4_1) 4) (= (y-coord loc_4_1) 1)
        (= (x-coord loc_4_2) 4) (= (y-coord loc_4_2) 2)
        (= (x-coord loc_4_3) 4) (= (y-coord loc_4_3) 3)
        (= (x-coord loc_5_1) 5) (= (y-coord loc_5_1) 1)
        (= (x-coord loc_5_2) 5) (= (y-coord loc_5_2) 2)
        (= (x-coord loc_5_3) 5) (= (y-coord loc_5_3) 3)
        (= (x-coord loc_6_1) 6) (= (y-coord loc_6_1) 1)
        (= (x-coord loc_6_2) 6) (= (y-coord loc_6_2) 2)
        (= (x-coord loc_6_3) 6) (= (y-coord loc_6_3) 3)
        (= (x-coord loc_7_1) 7) (= (y-coord loc_7_1) 1)
        (= (x-coord loc_7_2) 7) (= (y-coord loc_7_2) 2)
        (= (x-coord loc_7_3) 7) (= (y-coord loc_7_3) 3)
        (= (x-coord loc_8_1) 8) (= (y-coord loc_8_1) 1)
        (= (x-coord loc_8_2) 8) (= (y-coord loc_8_2) 2)
        (= (x-coord loc_8_3) 8) (= (y-coord loc_8_3) 3)
        (= (x-coord loc_9_1) 9) (= (y-coord loc_9_1) 1)
        (= (x-coord loc_9_2) 9) (= (y-coord loc_9_2) 2)
        (= (x-coord loc_9_3) 9) (= (y-coord loc_9_3) 3)
        (= (x-coord loc_10_1) 10) (= (y-coord loc_10_1) 1)
        (= (x-coord loc_10_2) 10) (= (y-coord loc_10_2) 2)
        (= (x-coord loc_10_3) 10) (= (y-coord loc_10_3) 3)
        (= (x-coord loc_11_1) 11) (= (y-coord loc_11_1) 1)
        (= (x-coord loc_11_2) 11) (= (y-coord loc_11_2) 2)
        (= (x-coord loc_11_3) 11) (= (y-coord loc_11_3) 3)
        (= (x-coord loc_12_1) 12) (= (y-coord loc_12_1) 1)
        (= (x-coord loc_12_2) 12) (= (y-coord loc_12_2) 2)
        (= (x-coord loc_12_3) 12) (= (y-coord loc_12_3) 3)
        (= (x-coord loc_13_1) 13) (= (y-coord loc_13_1) 1)
        (= (x-coord loc_13_2) 13) (= (y-coord loc_13_2) 2)
        (= (x-coord loc_13_3) 13) (= (y-coord loc_13_3) 3)
        (= (x-coord loc_14_1) 14) (= (y-coord loc_14_1) 1)
        (= (x-coord loc_14_2) 14) (= (y-coord loc_14_2) 2)
        (= (x-coord loc_14_3) 14) (= (y-coord loc_14_3) 3)
        (= (x-coord loc_15_1) 15) (= (y-coord loc_15_1) 1)
        (= (x-coord loc_15_2) 15) (= (y-coord loc_15_2) 2)
        (= (x-coord loc_15_3) 15) (= (y-coord loc_15_3) 3)
        (= (x-coord loc_16_1) 16) (= (y-coord loc_16_1) 1)
        (= (x-coord loc_16_2) 16) (= (y-coord loc_16_2) 2)
        (= (x-coord loc_16_3) 16) (= (y-coord loc_16_3) 3)
        (= (x-coord loc_17_1) 17) (= (y-coord loc_17_1) 1)
        (= (x-coord loc_17_2) 17) (= (y-coord loc_17_2) 2)
        (= (x-coord loc_17_3) 17) (= (y-coord loc_17_3) 3)
        (= (x-coord loc_18_1) 18) (= (y-coord loc_18_1) 1)
        (= (x-coord loc_18_2) 18) (= (y-coord loc_18_2) 2)
        (= (x-coord loc_18_3) 18) (= (y-coord loc_18_3) 3)
        (= (x-coord loc_19_1) 19) (= (y-coord loc_19_1) 1)
        (= (x-coord loc_19_2) 19) (= (y-coord loc_19_2) 2)
        (= (x-coord loc_19_3) 19) (= (y-coord loc_19_3) 3)
        (= (x-coord loc_20_1) 20) (= (y-coord loc_20_1) 1)
        (= (x-coord loc_20_2) 20) (= (y-coord loc_20_2) 2)
        (= (x-coord loc_20_3) 20) (= (y-coord loc_20_3) 3)
        (= (x-coord loc_21_1) 21) (= (y-coord loc_21_1) 1)
        (= (x-coord loc_21_2) 21) (= (y-coord loc_21_2) 2)
        (= (x-coord loc_21_3) 21) (= (y-coord loc_21_3) 3)
        (= (x-coord loc_22_1) 22) (= (y-coord loc_22_1) 1)
        (= (x-coord loc_22_2) 22) (= (y-coord loc_22_2) 2)
        (= (x-coord loc_22_3) 22) (= (y-coord loc_22_3) 3)
        (= (x-coord loc_23_1) 23) (= (y-coord loc_23_1) 1)
        (= (x-coord loc_23_2) 23) (= (y-coord loc_23_2) 2)
        (= (x-coord loc_23_3) 23) (= (y-coord loc_23_3) 3)
        (= (x-coord loc_24_1) 24) (= (y-coord loc_24_1) 1)
        (= (x-coord loc_24_2) 24) (= (y-coord loc_24_2) 2)
        (= (x-coord loc_24_3) 24) (= (y-coord loc_24_3) 3)
        (= (x-coord loc_25_1) 25) (= (y-coord loc_25_1) 1)
        (= (x-coord loc_25_2) 25) (= (y-coord loc_25_2) 2)
        (= (x-coord loc_25_3) 25) (= (y-coord loc_25_3) 3)
        (= (x-coord loc_26_1) 26) (= (y-coord loc_26_1) 1)
        (= (x-coord loc_26_2) 26) (= (y-coord loc_26_2) 2)
        (= (x-coord loc_26_3) 26) (= (y-coord loc_26_3) 3)
        (= (x-coord loc_27_1) 27) (= (y-coord loc_27_1) 1)
        (= (x-coord loc_27_2) 27) (= (y-coord loc_27_2) 2)
        (= (x-coord loc_27_3) 27) (= (y-coord loc_27_3) 3)
        (= (x-coord loc_28_1) 28) (= (y-coord loc_28_1) 1)
        (= (x-coord loc_28_2) 28) (= (y-coord loc_28_2) 2)
        (= (x-coord loc_28_3) 28) (= (y-coord loc_28_3) 3)
        (= (x-coord loc_29_1) 29) (= (y-coord loc_29_1) 1)
        (= (x-coord loc_29_2) 29) (= (y-coord loc_29_2) 2)
        (= (x-coord loc_29_3) 29) (= (y-coord loc_29_3) 3)
        (= (x-coord loc_30_1) 30) (= (y-coord loc_30_1) 1)
        (= (x-coord loc_30_2) 30) (= (y-coord loc_30_2) 2)
        (= (x-coord loc_30_3) 30) (= (y-coord loc_30_3) 3)
        (= (x-coord loc_31_1) 31) (= (y-coord loc_31_1) 1)
        (= (x-coord loc_31_2) 31) (= (y-coord loc_31_2) 2)
        (= (x-coord loc_31_3) 31) (= (y-coord loc_31_3) 3)

        ;; Character and ball positions
        (character_at loc_15_2)

        (ball_at ball_0 loc_2_2) (= (ball_size ball_0) 1) 
        (ball_at ball_1 loc_5_2) (= (ball_size ball_1) 1) 
        (ball_at ball_2 loc_8_2) (= (ball_size ball_2) 1) 
        (ball_at ball_3 loc_11_2) (= (ball_size ball_3) 1)
        (ball_at ball_4 loc_16_2) (= (ball_size ball_4) 1)
        (ball_at ball_5 loc_21_2) (= (ball_size ball_5) 1)
        (ball_at ball_6 loc_24_2) (= (ball_size ball_6) 1)
        (ball_at ball_7 loc_27_2) (= (ball_size ball_7) 1)
        (ball_at ball_8 loc_30_2) (= (ball_size ball_8) 1)
        
        ;; Snow locations
        (snow loc_1_1) (snow loc_1_2) (snow loc_1_3) (snow loc_2_1) (snow loc_2_3)
        (snow loc_3_1) (snow loc_3_2) (snow loc_3_3) (snow loc_4_1) (snow loc_4_2)
        (snow loc_4_3) (snow loc_5_1) (snow loc_5_3) (snow loc_6_1) (snow loc_6_2)
        (snow loc_6_3) (snow loc_7_1) (snow loc_7_2) (snow loc_7_3) (snow loc_8_1)
        (snow loc_8_3) (snow loc_9_1) (snow loc_9_2) (snow loc_9_3) (snow loc_10_1)
        (snow loc_10_2) (snow loc_10_3) (snow loc_11_1) (snow loc_11_3) (snow loc_12_1)
        (snow loc_12_2) (snow loc_12_3) (snow loc_13_1) (snow loc_13_2) (snow loc_13_3)
        (snow loc_14_1) (snow loc_14_2) (snow loc_14_3) (snow loc_15_1) (snow loc_15_3)
        (snow loc_16_1) (snow loc_16_3) (snow loc_17_1) (snow loc_17_2) (snow loc_17_3)
        (snow loc_18_1) (snow loc_18_2) (snow loc_18_3) (snow loc_19_1) (snow loc_19_2)
        (snow loc_19_3) (snow loc_20_1) (snow loc_20_2) (snow loc_20_3) (snow loc_21_1)
        (snow loc_21_3) (snow loc_22_1) (snow loc_22_2) (snow loc_22_3) (snow loc_23_1)
        (snow loc_23_2) (snow loc_23_3) (snow loc_24_1) (snow loc_24_3) (snow loc_25_1)
        (snow loc_25_2) (snow loc_25_3) (snow loc_26_1) (snow loc_26_2) (snow loc_26_3)
        (snow loc_27_1) (snow loc_27_3) (snow loc_28_1) (snow loc_28_2) (snow loc_28_3)
        (snow loc_29_1) (snow loc_29_2) (snow loc_29_3) (snow loc_30_1) (snow loc_30_3)
        (snow loc_31_1) (snow loc_31_2) (snow loc_31_3)
    )

    (:goal
        (and
            (= (snowman_built) 3)
        )
    )

    (:metric minimize (total-cost))
)