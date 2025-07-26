(define (problem hard_harder_hardest_adapted)

    (:domain three_snowman_coordinates)

    (:objects
        ;; Balls
        ball_0 ball_1 ball_2 ball_3 ball_4 ball_5 ball_6 ball_7 ball_8 - ball

        ;; Locations
        loc_1_2 loc_1_3 loc_1_4
        loc_2_2 loc_2_3 loc_2_4
        loc_3_2 loc_3_4
        loc_4_1 loc_4_2 loc_4_3 loc_4_4 loc_4_5
        loc_5_1 loc_5_2 loc_5_3 loc_5_4 loc_5_5
        loc_6_1 loc_6_2 loc_6_3 loc_6_4 loc_6_5
        loc_7_1 loc_7_2 loc_7_3 loc_7_4 loc_7_5
        loc_8_1 loc_8_2 loc_8_3 loc_8_4 loc_8_5 - location
    )

    (:init
        ;; Initializing counters
        (= (total-cost) 0)
        (= (snowman_built) 0)

        ;; --- Coordinate assignments for each location ---
        (= (x-coord loc_1_2) 1) (= (y-coord loc_1_2) 2)
        (= (x-coord loc_1_3) 1) (= (y-coord loc_1_3) 3)
        (= (x-coord loc_1_4) 1) (= (y-coord loc_1_4) 4)
        (= (x-coord loc_2_2) 2) (= (y-coord loc_2_2) 2)
        (= (x-coord loc_2_3) 2) (= (y-coord loc_2_3) 3)
        (= (x-coord loc_2_4) 2) (= (y-coord loc_2_4) 4)
        (= (x-coord loc_3_2) 3) (= (y-coord loc_3_2) 2)
        (= (x-coord loc_3_4) 3) (= (y-coord loc_3_4) 4)
        (= (x-coord loc_4_1) 4) (= (y-coord loc_4_1) 1)
        (= (x-coord loc_4_2) 4) (= (y-coord loc_4_2) 2)
        (= (x-coord loc_4_3) 4) (= (y-coord loc_4_3) 3)
        (= (x-coord loc_4_4) 4) (= (y-coord loc_4_4) 4)
        (= (x-coord loc_4_5) 4) (= (y-coord loc_4_5) 5)
        (= (x-coord loc_5_1) 5) (= (y-coord loc_5_1) 1)
        (= (x-coord loc_5_2) 5) (= (y-coord loc_5_2) 2)
        (= (x-coord loc_5_3) 5) (= (y-coord loc_5_3) 3)
        (= (x-coord loc_5_4) 5) (= (y-coord loc_5_4) 4)
        (= (x-coord loc_5_5) 5) (= (y-coord loc_5_5) 5)
        (= (x-coord loc_6_1) 6) (= (y-coord loc_6_1) 1)
        (= (x-coord loc_6_2) 6) (= (y-coord loc_6_2) 2)
        (= (x-coord loc_6_3) 6) (= (y-coord loc_6_3) 3)
        (= (x-coord loc_6_4) 6) (= (y-coord loc_6_4) 4)
        (= (x-coord loc_6_5) 6) (= (y-coord loc_6_5) 5)
        (= (x-coord loc_7_1) 7) (= (y-coord loc_7_1) 1)
        (= (x-coord loc_7_2) 7) (= (y-coord loc_7_2) 2)
        (= (x-coord loc_7_3) 7) (= (y-coord loc_7_3) 3)
        (= (x-coord loc_7_4) 7) (= (y-coord loc_7_4) 4)
        (= (x-coord loc_7_5) 7) (= (y-coord loc_7_5) 5)
        (= (x-coord loc_8_1) 8) (= (y-coord loc_8_1) 1)
        (= (x-coord loc_8_2) 8) (= (y-coord loc_8_2) 2)
        (= (x-coord loc_8_3) 8) (= (y-coord loc_8_3) 3)
        (= (x-coord loc_8_4) 8) (= (y-coord loc_8_4) 4)
        (= (x-coord loc_8_5) 8) (= (y-coord loc_8_5) 5)

        ;; Character and ball positions
        (character_at loc_7_3)
        
        (ball_at ball_0 loc_2_3) (= (ball_size ball_0) 1)
        (ball_at ball_1 loc_4_2) (= (ball_size ball_1) 2)
        (ball_at ball_2 loc_4_3) (= (ball_size ball_2) 2)
        (ball_at ball_3 loc_4_4) (= (ball_size ball_3) 2)
        (ball_at ball_4 loc_5_3) (= (ball_size ball_4) 1)
        (ball_at ball_5 loc_6_1) (= (ball_size ball_5) 1)
        (ball_at ball_6 loc_6_5) (= (ball_size ball_6) 1)
        (ball_at ball_7 loc_7_2) (= (ball_size ball_7) 1)
        (ball_at ball_8 loc_7_4) (= (ball_size ball_8) 1)

        ;; Snow locations
        (snow loc_1_2) (snow loc_1_3) (snow loc_1_4)
        (snow loc_2_2) (snow loc_2_4)
        (snow loc_3_2) (snow loc_3_4)
        (snow loc_4_1) (snow loc_4_5)
        (snow loc_5_1) (snow loc_5_2) (snow loc_5_4) (snow loc_5_5)
        (snow loc_6_2) (snow loc_6_3) (snow loc_6_4)
        (snow loc_7_1) (snow loc_7_3) (snow loc_7_5)
        (snow loc_8_1) (snow loc_8_2) (snow loc_8_3) (snow loc_8_4) (snow loc_8_5)
    )

    (:goal
        (and
            (= (snowman_built) 3)
        )
    )

    (:metric minimize (total-cost))
)