(define (problem kevin-adapted-for-coordinates)
    (:domain one_snowman_coordinates)

    (:objects
        ball_0 ball_1 ball_2 - ball
        
        loc_1_1 loc_1_2
        loc_2_1 loc_2_2 loc_2_3 loc_2_4
        loc_3_1 loc_3_2 loc_3_3 loc_3_4
        loc_4_1 loc_4_2 loc_4_3 loc_4_4
        loc_5_1 loc_5_2 loc_5_3 loc_5_4
        loc_6_1 loc_6_2 loc_6_3 loc_6_4
        loc_7_1 loc_7_2 - location
    )

    (:init
        (= (total-cost) 0)
        (= (is_goal_achieved) 0)

        (= (x-coord loc_1_1) 1) (= (y-coord loc_1_1) 1)
        (= (x-coord loc_1_2) 1) (= (y-coord loc_1_2) 2)
        (= (x-coord loc_2_1) 2) (= (y-coord loc_2_1) 1)
        (= (x-coord loc_2_2) 2) (= (y-coord loc_2_2) 2)
        (= (x-coord loc_2_3) 2) (= (y-coord loc_2_3) 3)
        (= (x-coord loc_2_4) 2) (= (y-coord loc_2_4) 4)
        (= (x-coord loc_3_1) 3) (= (y-coord loc_3_1) 1)
        (= (x-coord loc_3_2) 3) (= (y-coord loc_3_2) 2)
        (= (x-coord loc_3_3) 3) (= (y-coord loc_3_3) 3)
        (= (x-coord loc_3_4) 3) (= (y-coord loc_3_4) 4)
        (= (x-coord loc_4_1) 4) (= (y-coord loc_4_1) 1)
        (= (x-coord loc_4_2) 4) (= (y-coord loc_4_2) 2)
        (= (x-coord loc_4_3) 4) (= (y-coord loc_4_3) 3)
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

        (character_at loc_4_2)

        (ball_at ball_0 loc_2_3)
        (= (ball_size ball_0) 1)
        (ball_at ball_1 loc_4_4)
        (= (ball_size ball_1) 1)
        (ball_at ball_2 loc_6_3)
        (= (ball_size ball_2) 1)
        
        
        (occupancy loc_2_3)
        (occupancy loc_4_4)
        (occupancy loc_6_3)
        
        (snow loc_1_1) (snow loc_1_2)
        (snow loc_2_1) (snow loc_2_2) (snow loc_2_4)
        (snow loc_3_1) (snow loc_3_2) (snow loc_3_3) (snow loc_3_4)
        (snow loc_4_1) (snow loc_4_2) (snow loc_4_3)
        (snow loc_5_1) (snow loc_5_2) (snow loc_5_3) (snow loc_5_4)
        (snow loc_6_1) (snow loc_6_2) (snow loc_6_4)
        (snow loc_7_1) (snow loc_7_2)
    )

    (:goal
        (and
            (= (is_goal_achieved) 1)
        )
    )

    (:metric minimize (total-cost))
)