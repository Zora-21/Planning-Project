(define (problem mary-adapted-for-coordinates)
    (:domain one_snowman_coordinates)

    (:objects
        ;; Problem objects: 3 balls and 22 locations
        ball_0 ball_1 ball_2 - ball
        
        loc_1_1 loc_1_2 loc_1_3
        loc_2_1 loc_2_2 loc_2_3
        loc_3_1 loc_3_3
        loc_4_1 loc_4_2 loc_4_3
        loc_5_1 loc_5_2 loc_5_3 - location
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
        (= (x-coord loc_3_3) 3) (= (y-coord loc_3_3) 3)
        (= (x-coord loc_4_1) 4) (= (y-coord loc_4_1) 1)
        (= (x-coord loc_4_2) 4) (= (y-coord loc_4_2) 2)
        (= (x-coord loc_4_3) 4) (= (y-coord loc_4_3) 3)
        (= (x-coord loc_5_1) 5) (= (y-coord loc_5_1) 1)
        (= (x-coord loc_5_2) 5) (= (y-coord loc_5_2) 2)
        (= (x-coord loc_5_3) 5) (= (y-coord loc_5_3) 3)

        ;; Initial state of the world
        (character_at loc_3_1)

        (ball_at ball_0 loc_2_2)
        (= (ball_size ball_0) 3)
        (ball_at ball_1 loc_4_2)
        (= (ball_size ball_1) 2)
        (ball_at ball_2 loc_4_2)
        (= (ball_size ball_2) 1)
        
        (occupancy loc_2_2)
        (occupancy loc_4_2)

        (snow loc_1_1)
        (snow loc_1_2)
        (snow loc_1_3)
        (snow loc_2_1)
        (snow loc_2_3)
        (snow loc_3_1)
        (snow loc_3_3)
        (snow loc_4_1)
        (snow loc_4_3)
        (snow loc_5_1)
        (snow loc_5_2)
        (snow loc_5_3)
    )

    (:goal
        (and
            ;; The goal is met when the 'goal' action's conditions are satisfied
            (= (goal) 1)
        )
    )

    (:metric minimize (total-cost))
)