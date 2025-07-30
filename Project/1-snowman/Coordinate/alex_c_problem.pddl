(define (problem alex-coordinate)
    (:domain one_snowman_coordinates)

    (:objects
        ball_0 - ball
        ball_1 - ball
        ball_2 - ball
        loc_1_1 - location
        loc_1_2 - location
        loc_1_3 - location
        loc_1_4 - location
        loc_1_5 - location
        loc_2_1 - location
        loc_2_3 - location
        loc_2_4 - location
        loc_2_5 - location
        loc_3_1 - location
        loc_3_2 - location
        loc_3_3 - location
        loc_3_4 - location
        loc_3_5 - location
        loc_4_1 - location
        loc_4_3 - location
        loc_4_4 - location
        loc_4_5 - location
        loc_5_1 - location
        loc_5_2 - location
        loc_5_3 - location
        loc_5_4 - location
        loc_5_5 - location
    )

    (:init
        (= (total-cost) 0)
        (= (goal) 0)

        (= (x-coord loc_1_1) 1) (= (y-coord loc_1_1) 1) (= (x-coord loc_1_2) 1) (= (y-coord loc_1_2) 2) (= (x-coord loc_1_3) 1) (= (y-coord loc_1_3) 3) (= (x-coord loc_1_4) 1) (= (y-coord loc_1_4) 4) (= (x-coord loc_1_5) 1) (= (y-coord loc_1_5) 5)
        (= (x-coord loc_2_1) 2) (= (y-coord loc_2_1) 1) (= (x-coord loc_2_3) 2) (= (y-coord loc_2_3) 3) (= (x-coord loc_2_4) 2) (= (y-coord loc_2_4) 4) (= (x-coord loc_2_5) 2) (= (y-coord loc_2_5) 5)
        (= (x-coord loc_3_1) 3) (= (y-coord loc_3_1) 1) (= (x-coord loc_3_2) 3) (= (y-coord loc_3_2) 2) (= (x-coord loc_3_3) 3) (= (y-coord loc_3_3) 3) (= (x-coord loc_3_4) 3) (= (y-coord loc_3_4) 4) (= (x-coord loc_3_5) 3) (= (y-coord loc_3_5) 5)
        (= (x-coord loc_4_1) 4) (= (y-coord loc_4_1) 1) (= (x-coord loc_4_3) 4) (= (y-coord loc_4_3) 3) (= (x-coord loc_4_4) 4) (= (y-coord loc_4_4) 4) (= (x-coord loc_4_5) 4) (= (y-coord loc_4_5) 5)
        (= (x-coord loc_5_1) 5) (= (y-coord loc_5_1) 1) (= (x-coord loc_5_2) 5) (= (y-coord loc_5_2) 2) (= (x-coord loc_5_3) 5) (= (y-coord loc_5_3) 3) (= (x-coord loc_5_4) 5) (= (y-coord loc_5_4) 4) (= (x-coord loc_5_5) 5) (= (y-coord loc_5_5) 5)


        (character_at loc_2_5)

        (ball_at ball_0 loc_2_4)
        (=(ball_size ball_0) 1)

        (ball_at ball_1 loc_3_5)
        (=(ball_size ball_1) 1)

        (ball_at ball_2 loc_4_4)
        (=(ball_size ball_2) 2)

        (snow loc_1_1) (snow loc_1_2) (snow loc_1_3) (snow loc_1_4) (snow loc_1_5)
        (snow loc_2_1) (snow loc_2_3) (snow loc_2_5)
        (snow loc_3_1) (snow loc_3_2) (snow loc_3_3) (snow loc_3_4)
        (snow loc_4_1) (snow loc_4_3) (snow loc_4_5)
        (snow loc_5_1) (snow loc_5_2) (snow loc_5_3) (snow loc_5_4) (snow loc_5_5)

        (occupancy loc_2_4)
        (occupancy loc_3_5)
        (occupancy loc_4_4)
    )

    (:goal
        (= (goal) 1)
    )

    (:metric minimize (total-cost))
)
