(define (problem julian-adapted-for-coordinates)
    (:domain one_snowman_coordinates)

    (:objects
        ;; Problem objects: 3 balls and 44 locations
        ball_0 ball_1 ball_2 - ball
        
        loc_1_1 loc_1_2 loc_1_3
        loc_2_1 loc_2_2 loc_2_3
        loc_3_1 loc_3_2 loc_3_3 loc_3_4
        loc_4_2 loc_4_4
        loc_5_1 loc_5_2 loc_5_3 loc_5_4
        loc_6_1 loc_6_2 loc_6_3 loc_6_4
        loc_7_1 loc_7_2 loc_7_3 loc_7_4
        loc_8_2 loc_8_4
        loc_9_1 loc_9_2 loc_9_3 loc_9_4
        loc_10_1 loc_10_2 loc_10_3
        loc_11_1 loc_11_2 loc_11_3 - location
    )

    (:init
        ;; Initialize numeric fluents
        (= (total-cost) 0)
        (= (goal) 0)

        ;; Define coordinates for each location
        (= (x-coord loc_1_1) 1) (= (y-coord loc_1_1) 1)
        (= (x-coord loc_1_2) 1) (= (y-coord loc_1_2) 2)
        (= (x-coord loc_1_3) 1) (= (y-coord loc_1_3) 3)
        (= (x-coord loc_2_1) 2) (= (y-coord loc_2_1) 1)
        (= (x-coord loc_2_2) 2) (= (y-coord loc_2_2) 2)
        (= (x-coord loc_2_3) 2) (= (y-coord loc_2_3) 3)
        (= (x-coord loc_3_1) 3) (= (y-coord loc_3_1) 1)
        (= (x-coord loc_3_2) 3) (= (y-coord loc_3_2) 2)
        (= (x-coord loc_3_3) 3) (= (y-coord loc_3_3) 3)
        (= (x-coord loc_3_4) 3) (= (y-coord loc_3_4) 4)
        (= (x-coord loc_4_2) 4) (= (y-coord loc_4_2) 2)
        (= (x-coord loc_4_4) 4) (= (y-coord loc_4_4) 4)
        (= (x-coord loc_5_1) 5) (= (y-coord loc_5_1) 1)
        (= (x-coord loc_5_2) 5) (= (y-coord loc_5_2) 2)
        (= (x-coord loc_5_3) 5) (= (y-coord loc_5_3) 3)
        (= (x-coord loc_5_4) 5) (= (y-coord loc_5_4) 4)
        (= (x-coord loc_6_1) 6) (= (y-coord loc_6_1) 1)
        (= (x-coord loc_6_2) 6) (= (y-coord loc_6_2) 2)
        (= (x-coord loc_6_3) 6) (= (y-coord loc_6_3) 3)
        (= (x-coord loc_6_4) 6) (= (y-coord loc_6_4) 4)
        (= (x-coord loc_7_1) 7) (= (y-coord loc_7_1) 1)
        (= (x-coord loc_7_2) 7) (= (y-coord loc_7_2) 2)
        (= (x-coord loc_7_3) 7) (= (y-coord loc_7_3) 3)
        (= (x-coord loc_7_4) 7) (= (y-coord loc_7_4) 4)
        (= (x-coord loc_8_2) 8) (= (y-coord loc_8_2) 2)
        (= (x-coord loc_8_4) 8) (= (y-coord loc_8_4) 4)
        (= (x-coord loc_9_1) 9) (= (y-coord loc_9_1) 1)
        (= (x-coord loc_9_2) 9) (= (y-coord loc_9_2) 2)
        (= (x-coord loc_9_3) 9) (= (y-coord loc_9_3) 3)
        (= (x-coord loc_9_4) 9) (= (y-coord loc_9_4) 4)
        (= (x-coord loc_10_1) 10) (= (y-coord loc_10_1) 1)
        (= (x-coord loc_10_2) 10) (= (y-coord loc_10_2) 2)
        (= (x-coord loc_10_3) 10) (= (y-coord loc_10_3) 3)
        (= (x-coord loc_11_1) 11) (= (y-coord loc_11_1) 1)
        (= (x-coord loc_11_2) 11) (= (y-coord loc_11_2) 2)
        (= (x-coord loc_11_3) 11) (= (y-coord loc_11_3) 3)

        ;; Initial state of the world
        (character_at loc_6_2)
        
        (ball_at ball_0 loc_3_2)
        (= (ball_size ball_0) 1)
        (ball_at ball_1 loc_6_4)
        (= (ball_size ball_1) 1)
        (ball_at ball_2 loc_9_2)
        (= (ball_size ball_2) 1)

        (occupancy loc_3_2)
        (occupancy loc_6_4)
        (occupancy loc_9_2)

        (snow loc_1_1) (snow loc_1_2) (snow loc_1_3)
        (snow loc_2_1) (snow loc_2_2) (snow loc_2_3)
        (snow loc_3_1) (snow loc_3_3) (snow loc_3_4)
        (snow loc_4_2) (snow loc_4_4)
        (snow loc_5_1) (snow loc_5_2) (snow loc_5_3) (snow loc_5_4)
        (snow loc_6_1) (snow loc_6_2) (snow loc_6_3)
        (snow loc_7_1) (snow loc_7_2) (snow loc_7_3) (snow loc_7_4)
        (snow loc_8_2) (snow loc_8_4)
        (snow loc_9_1) (snow loc_9_3) (snow loc_9_4)
        (snow loc_10_1) (snow loc_10_2) (snow loc_10_3)
        (snow loc_11_1) (snow loc_11_2) (snow loc_11_3)
    )

    (:goal
        (and
            (= (goal) 1)
        )
    )

    (:metric minimize (total-cost))
)