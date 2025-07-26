(define (problem chris_karen_snow_adapted)

    (:domain two_snowman_coordinates)

    (:objects
        ;; Balls
        ball_0 ball_1 ball_2 ball_3 ball_4 ball_5 - ball

        ;; Locations (6x6 grid)
        loc_1_1 loc_1_2 loc_1_3 loc_1_4 loc_1_5 loc_1_6
        loc_2_1 loc_2_2 loc_2_3 loc_2_4 loc_2_5 loc_2_6
        loc_3_1 loc_3_2 loc_3_3 loc_3_4 loc_3_5 loc_3_6
        loc_4_1 loc_4_2 loc_4_3 loc_4_4 loc_4_5 loc_4_6
        loc_5_1 loc_5_2 loc_5_3 loc_5_4 loc_5_5 loc_5_6
        loc_6_1 loc_6_2 loc_6_3 loc_6_4 loc_6_5 loc_6_6 - location
    )

    (:init
        ;; Initializing counters
        (= (total-cost) 0)
        (= (snowman_built) 0)

        ;; --- Coordinate assignments for each location ---
        (= (x-coord loc_1_1) 1) (= (y-coord loc_1_1) 1)
        (= (x-coord loc_1_2) 1) (= (y-coord loc_1_2) 2)
        (= (x-coord loc_1_3) 1) (= (y-coord loc_1_3) 3)
        (= (x-coord loc_1_4) 1) (= (y-coord loc_1_4) 4)
        (= (x-coord loc_1_5) 1) (= (y-coord loc_1_5) 5)
        (= (x-coord loc_1_6) 1) (= (y-coord loc_1_6) 6)
        (= (x-coord loc_2_1) 2) (= (y-coord loc_2_1) 1)
        (= (x-coord loc_2_2) 2) (= (y-coord loc_2_2) 2)
        (= (x-coord loc_2_3) 2) (= (y-coord loc_2_3) 3)
        (= (x-coord loc_2_4) 2) (= (y-coord loc_2_4) 4)
        (= (x-coord loc_2_5) 2) (= (y-coord loc_2_5) 5)
        (= (x-coord loc_2_6) 2) (= (y-coord loc_2_6) 6)
        (= (x-coord loc_3_1) 3) (= (y-coord loc_3_1) 1)
        (= (x-coord loc_3_2) 3) (= (y-coord loc_3_2) 2)
        (= (x-coord loc_3_3) 3) (= (y-coord loc_3_3) 3)
        (= (x-coord loc_3_4) 3) (= (y-coord loc_3_4) 4)
        (= (x-coord loc_3_5) 3) (= (y-coord loc_3_5) 5)
        (= (x-coord loc_3_6) 3) (= (y-coord loc_3_6) 6)
        (= (x-coord loc_4_1) 4) (= (y-coord loc_4_1) 1)
        (= (x-coord loc_4_2) 4) (= (y-coord loc_4_2) 2)
        (= (x-coord loc_4_3) 4) (= (y-coord loc_4_3) 3)
        (= (x-coord loc_4_4) 4) (= (y-coord loc_4_4) 4)
        (= (x-coord loc_4_5) 4) (= (y-coord loc_4_5) 5)
        (= (x-coord loc_4_6) 4) (= (y-coord loc_4_6) 6)
        (= (x-coord loc_5_1) 5) (= (y-coord loc_5_1) 1)
        (= (x-coord loc_5_2) 5) (= (y-coord loc_5_2) 2)
        (= (x-coord loc_5_3) 5) (= (y-coord loc_5_3) 3)
        (= (x-coord loc_5_4) 5) (= (y-coord loc_5_4) 4)
        (= (x-coord loc_5_5) 5) (= (y-coord loc_5_5) 5)
        (= (x-coord loc_5_6) 5) (= (y-coord loc_5_6) 6)
        (= (x-coord loc_6_1) 6) (= (y-coord loc_6_1) 1)
        (= (x-coord loc_6_2) 6) (= (y-coord loc_6_2) 2)
        (= (x-coord loc_6_3) 6) (= (y-coord loc_6_3) 3)
        (= (x-coord loc_6_4) 6) (= (y-coord loc_6_4) 4)
        (= (x-coord loc_6_5) 6) (= (y-coord loc_6_5) 5)
        (= (x-coord loc_6_6) 6) (= (y-coord loc_6_6) 6)

        ;; Character and ball positions
        (character_at loc_3_3)

        (ball_at ball_0 loc_2_1) (= (ball_size ball_0) 1) (is_movable ball_0)
        (ball_at ball_1 loc_2_6) (= (ball_size ball_1) 1) (is_movable ball_1)
        (ball_at ball_2 loc_3_4) (= (ball_size ball_2) 1) (is_movable ball_2)
        (ball_at ball_3 loc_4_3) (= (ball_size ball_3) 1) (is_movable ball_3)
        (ball_at ball_4 loc_5_1) (= (ball_size ball_4) 1) (is_movable ball_4)
        (ball_at ball_5 loc_5_6) (= (ball_size ball_5) 1) (is_movable ball_5)
        
        ;; Snow locations
        (snow loc_1_1) (snow loc_1_2) (snow loc_1_3) (snow loc_1_4) (snow loc_1_5) (snow loc_1_6)
        (snow loc_2_2) (snow loc_2_3) (snow loc_2_4) (snow loc_2_5)
        (snow loc_3_1) (snow loc_3_2) (snow loc_3_5) (snow loc_3_6)
        (snow loc_4_1) (snow loc_4_2) (snow loc_4_4) (snow loc_4_5) (snow loc_4_6)
        (snow loc_5_2) (snow loc_5_3) (snow loc_5_4) (snow loc_5_5)
        (snow loc_6_1) (snow loc_6_2) (snow loc_6_3) (snow loc_6_4) (snow loc_6_5) (snow loc_6_6)
    )

    (:goal
        (and
            (= (snowman_built) 2)
        )
    )

    (:metric minimize (total-cost))
)