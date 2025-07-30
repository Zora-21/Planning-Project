(define (problem willow-adapted-for-coordinates)
    (:domain one_snowman_coordinates)

    (:objects
        ;; Problem objects: 3 balls and 50 locations
        ball_0 ball_1 ball_2 - ball
        
        loc_1_2 loc_1_3 loc_1_4 loc_1_5 loc_1_6
        loc_2_1 loc_2_2 loc_2_3 loc_2_4 loc_2_6
        loc_3_1 loc_3_2 loc_3_4 loc_3_6
        loc_4_1 loc_4_2 loc_4_3 loc_4_4 loc_4_5 loc_4_6
        loc_5_1 loc_5_2 loc_5_4 loc_5_6
        loc_6_1 loc_6_2 loc_6_3 loc_6_4 loc_6_6
        loc_7_2 loc_7_3 loc_7_4 loc_7_5 loc_7_6 - location
    )

    (:init
        ;; Initialize numeric fluents
        (= (total-cost) 0)
        (= (goal) 0)

        ;; Define coordinates for each location
        (= (x-coord loc_1_2) 1) (= (y-coord loc_1_2) 2)
        (= (x-coord loc_1_3) 1) (= (y-coord loc_1_3) 3)
        (= (x-coord loc_1_4) 1) (= (y-coord loc_1_4) 4)
        (= (x-coord loc_1_5) 1) (= (y-coord loc_1_5) 5)
        (= (x-coord loc_1_6) 1) (= (y-coord loc_1_6) 6)
        (= (x-coord loc_2_1) 2) (= (y-coord loc_2_1) 1)
        (= (x-coord loc_2_2) 2) (= (y-coord loc_2_2) 2)
        (= (x-coord loc_2_3) 2) (= (y-coord loc_2_3) 3)
        (= (x-coord loc_2_4) 2) (= (y-coord loc_2_4) 4)
        (= (x-coord loc_2_6) 2) (= (y-coord loc_2_6) 6)
        (= (x-coord loc_3_1) 3) (= (y-coord loc_3_1) 1)
        (= (x-coord loc_3_2) 3) (= (y-coord loc_3_2) 2)
        (= (x-coord loc_3_4) 3) (= (y-coord loc_3_4) 4)
        (= (x-coord loc_3_6) 3) (= (y-coord loc_3_6) 6)
        (= (x-coord loc_4_1) 4) (= (y-coord loc_4_1) 1)
        (= (x-coord loc_4_2) 4) (= (y-coord loc_4_2) 2)
        (= (x-coord loc_4_3) 4) (= (y-coord loc_4_3) 3)
        (= (x-coord loc_4_4) 4) (= (y-coord loc_4_4) 4)
        (= (x-coord loc_4_5) 4) (= (y-coord loc_4_5) 5)
        (= (x-coord loc_4_6) 4) (= (y-coord loc_4_6) 6)
        (= (x-coord loc_5_1) 5) (= (y-coord loc_5_1) 1)
        (= (x-coord loc_5_2) 5) (= (y-coord loc_5_2) 2)
        (= (x-coord loc_5_4) 5) (= (y-coord loc_5_4) 4)
        (= (x-coord loc_5_6) 5) (= (y-coord loc_5_6) 6)
        (= (x-coord loc_6_1) 6) (= (y-coord loc_6_1) 1)
        (= (x-coord loc_6_2) 6) (= (y-coord loc_6_2) 2)
        (= (x-coord loc_6_3) 6) (= (y-coord loc_6_3) 3)
        (= (x-coord loc_6_4) 6) (= (y-coord loc_6_4) 4)
        (= (x-coord loc_6_6) 6) (= (y-coord loc_6_6) 6)
        (= (x-coord loc_7_2) 7) (= (y-coord loc_7_2) 2)
        (= (x-coord loc_7_3) 7) (= (y-coord loc_7_3) 3)
        (= (x-coord loc_7_4) 7) (= (y-coord loc_7_4) 4)
        (= (x-coord loc_7_5) 7) (= (y-coord loc_7_5) 5)
        (= (x-coord loc_7_6) 7) (= (y-coord loc_7_6) 6)

        ;; Initial state of the world
        (character_at loc_4_1)
        
        (ball_at ball_0 loc_4_2)
        (= (ball_size ball_0) 1)
        (ball_at ball_1 loc_4_4)
        (= (ball_size ball_1) 1)
        (ball_at ball_2 loc_4_6)
        (= (ball_size ball_2) 1)

        (occupancy loc_4_2)
        (occupancy loc_4_4)
        (occupancy loc_4_6)

        (snow loc_1_2) (snow loc_1_3) (snow loc_1_4) (snow loc_1_5) (snow loc_1_6)
        (snow loc_2_1) (snow loc_2_2) (snow loc_2_3) (snow loc_2_4) (snow loc_2_6)
        (snow loc_3_1) (snow loc_3_2) (snow loc_3_4) (snow loc_3_6)
        (snow loc_4_1) (snow loc_4_3) (snow loc_4_5)
        (snow loc_5_1) (snow loc_5_2) (snow loc_5_4) (snow loc_5_6)
        (snow loc_6_1) (snow loc_6_2) (snow loc_6_3) (snow loc_6_4) (snow loc_6_6)
        (snow loc_7_2) (snow loc_7_3) (snow loc_7_4) (snow loc_7_5) (snow loc_7_6)
    )

    (:goal
        (and
            ;; The goal is met when the 'goal' action's conditions are satisfied
            (= (goal) 1)
        )
    )

    (:metric minimize (total-cost))
)