(define (problem cynthia_michael_adapted)

    (:domain two_snowman_coordinates)

    (:objects
        ;; Balls
        ball_0 ball_1 ball_2 ball_3 ball_4 ball_5 - ball

        ;; Locations
        loc_1_2 loc_1_3 loc_1_4 loc_1_5
        loc_2_2 loc_2_3 loc_2_4 loc_2_5
        loc_3_2 loc_3_3 loc_3_4
        loc_4_1 loc_4_2 loc_4_4 loc_4_5
        loc_5_1 loc_5_2 loc_5_4 loc_5_5
        loc_6_1 loc_6_2 loc_6_4 loc_6_5
        loc_7_2 loc_7_3 loc_7_4
        loc_8_2 loc_8_3 loc_8_4 loc_8_5
        loc_9_2 loc_9_3 loc_9_4 loc_9_5 - location
    )

    (:init
        ;; Initializing counters
        (= (total-cost) 0)
        (= (snowman_built) 0)

        ;; --- Coordinate assignments for each location ---
        (= (x-coord loc_1_2) 1) (= (y-coord loc_1_2) 2)
        (= (x-coord loc_1_3) 1) (= (y-coord loc_1_3) 3)
        (= (x-coord loc_1_4) 1) (= (y-coord loc_1_4) 4)
        (= (x-coord loc_1_5) 1) (= (y-coord loc_1_5) 5)
        (= (x-coord loc_2_2) 2) (= (y-coord loc_2_2) 2)
        (= (x-coord loc_2_3) 2) (= (y-coord loc_2_3) 3)
        (= (x-coord loc_2_4) 2) (= (y-coord loc_2_4) 4)
        (= (x-coord loc_2_5) 2) (= (y-coord loc_2_5) 5)
        (= (x-coord loc_3_2) 3) (= (y-coord loc_3_2) 2)
        (= (x-coord loc_3_3) 3) (= (y-coord loc_3_3) 3)
        (= (x-coord loc_3_4) 3) (= (y-coord loc_3_4) 4)
        (= (x-coord loc_4_1) 4) (= (y-coord loc_4_1) 1)
        (= (x-coord loc_4_2) 4) (= (y-coord loc_4_2) 2)
        (= (x-coord loc_4_4) 4) (= (y-coord loc_4_4) 4)
        (= (x-coord loc_4_5) 4) (= (y-coord loc_4_5) 5)
        (= (x-coord loc_5_1) 5) (= (y-coord loc_5_1) 1)
        (= (x-coord loc_5_2) 5) (= (y-coord loc_5_2) 2)
        (= (x-coord loc_5_4) 5) (= (y-coord loc_5_4) 4)
        (= (x-coord loc_5_5) 5) (= (y-coord loc_5_5) 5)
        (= (x-coord loc_6_1) 6) (= (y-coord loc_6_1) 1)
        (= (x-coord loc_6_2) 6) (= (y-coord loc_6_2) 2)
        (= (x-coord loc_6_4) 6) (= (y-coord loc_6_4) 4)
        (= (x-coord loc_6_5) 6) (= (y-coord loc_6_5) 5)
        (= (x-coord loc_7_2) 7) (= (y-coord loc_7_2) 2)
        (= (x-coord loc_7_3) 7) (= (y-coord loc_7_3) 3)
        (= (x-coord loc_7_4) 7) (= (y-coord loc_7_4) 4)
        (= (x-coord loc_8_2) 8) (= (y-coord loc_8_2) 2)
        (= (x-coord loc_8_3) 8) (= (y-coord loc_8_3) 3)
        (= (x-coord loc_8_4) 8) (= (y-coord loc_8_4) 4)
        (= (x-coord loc_8_5) 8) (= (y-coord loc_8_5) 5)
        (= (x-coord loc_9_2) 9) (= (y-coord loc_9_2) 2)
        (= (x-coord loc_9_3) 9) (= (y-coord loc_9_3) 3)
        (= (x-coord loc_9_4) 9) (= (y-coord loc_9_4) 4)
        (= (x-coord loc_9_5) 9) (= (y-coord loc_9_5) 5)

        ;; Character and ball positions
        (character_at loc_5_5)

        (ball_at ball_0 loc_3_2) (= (ball_size ball_0) 1) 
        (ball_at ball_1 loc_3_3) (= (ball_size ball_1) 1) 
        (ball_at ball_2 loc_3_4) (= (ball_size ball_2) 1) 
        (ball_at ball_3 loc_7_2) (= (ball_size ball_3) 1) 
        (ball_at ball_4 loc_7_3) (= (ball_size ball_4) 1) 
        (ball_at ball_5 loc_7_4) (= (ball_size ball_5) 1) 
        
        ;; Snow locations
        (snow loc_4_1) (snow loc_4_2) (snow loc_4_4) (snow loc_4_5)
        (snow loc_5_1) (snow loc_5_2) (snow loc_5_4) (snow loc_5_5)
        (snow loc_6_1) (snow loc_6_2) (snow loc_6_4) (snow loc_6_5)
    )

    (:goal
        (and
            (= (snowman_built) 2)
        )
    )

    (:metric minimize (total-cost))
)