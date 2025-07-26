(define (problem one_two_three_adapted)
    (:domain three_snowman_coordinates)

    (:objects
        ball_0 - ball
        ball_1 - ball
        ball_2 - ball
        ball_3 - ball
        ball_4 - ball
        ball_5 - ball
        ball_6 - ball
        ball_7 - ball
        ball_8 - ball
        loc_1_1 - location
        loc_1_2 - location
        loc_1_3 - location
        loc_1_4 - location
        loc_1_5 - location
        loc_1_6 - location
        loc_1_7 - location
        loc_2_1 - location
        loc_2_2 - location
        loc_2_3 - location
        loc_2_4 - location
        loc_2_5 - location
        loc_2_6 - location
        loc_2_7 - location
        loc_3_1 - location
        loc_3_2 - location
        loc_3_3 - location
        loc_3_4 - location
        loc_3_5 - location
        loc_3_6 - location
        loc_3_7 - location
        loc_4_1 - location
        loc_4_2 - location
        loc_4_3 - location
        loc_4_4 - location
        loc_4_5 - location
        loc_4_6 - location
        loc_4_7 - location
        loc_5_1 - location
        loc_5_2 - location
        loc_5_3 - location
        loc_5_4 - location
        loc_5_5 - location
        loc_5_6 - location
        loc_5_7 - location
    )

    (:init
        (= (total-cost) 0)
        (= (snowman_built) 0)

        ; Coordinate delle locazioni
        (= (x-coord loc_1_1) 1) (= (y-coord loc_1_1) 1)
        (= (x-coord loc_1_2) 1) (= (y-coord loc_1_2) 2)
        (= (x-coord loc_1_3) 1) (= (y-coord loc_1_3) 3)
        (= (x-coord loc_1_4) 1) (= (y-coord loc_1_4) 4)
        (= (x-coord loc_1_5) 1) (= (y-coord loc_1_5) 5)
        (= (x-coord loc_1_6) 1) (= (y-coord loc_1_6) 6)
        (= (x-coord loc_1_7) 1) (= (y-coord loc_1_7) 7)
        (= (x-coord loc_2_1) 2) (= (y-coord loc_2_1) 1)
        (= (x-coord loc_2_2) 2) (= (y-coord loc_2_2) 2)
        (= (x-coord loc_2_3) 2) (= (y-coord loc_2_3) 3)
        (= (x-coord loc_2_4) 2) (= (y-coord loc_2_4) 4)
        (= (x-coord loc_2_5) 2) (= (y-coord loc_2_5) 5)
        (= (x-coord loc_2_6) 2) (= (y-coord loc_2_6) 6)
        (= (x-coord loc_2_7) 2) (= (y-coord loc_2_7) 7)
        (= (x-coord loc_3_1) 3) (= (y-coord loc_3_1) 1)
        (= (x-coord loc_3_2) 3) (= (y-coord loc_3_2) 2)
        (= (x-coord loc_3_3) 3) (= (y-coord loc_3_3) 3)
        (= (x-coord loc_3_4) 3) (= (y-coord loc_3_4) 4)
        (= (x-coord loc_3_5) 3) (= (y-coord loc_3_5) 5)
        (= (x-coord loc_3_6) 3) (= (y-coord loc_3_6) 6)
        (= (x-coord loc_3_7) 3) (= (y-coord loc_3_7) 7)
        (= (x-coord loc_4_1) 4) (= (y-coord loc_4_1) 1)
        (= (x-coord loc_4_2) 4) (= (y-coord loc_4_2) 2)
        (= (x-coord loc_4_3) 4) (= (y-coord loc_4_3) 3)
        (= (x-coord loc_4_4) 4) (= (y-coord loc_4_4) 4)
        (= (x-coord loc_4_5) 4) (= (y-coord loc_4_5) 5)
        (= (x-coord loc_4_6) 4) (= (y-coord loc_4_6) 6)
        (= (x-coord loc_4_7) 4) (= (y-coord loc_4_7) 7)
        (= (x-coord loc_5_1) 5) (= (y-coord loc_5_1) 1)
        (= (x-coord loc_5_2) 5) (= (y-coord loc_5_2) 2)
        (= (x-coord loc_5_3) 5) (= (y-coord loc_5_3) 3)
        (= (x-coord loc_5_4) 5) (= (y-coord loc_5_4) 4)
        (= (x-coord loc_5_5) 5) (= (y-coord loc_5_5) 5)
        (= (x-coord loc_5_6) 5) (= (y-coord loc_5_6) 6)
        (= (x-coord loc_5_7) 5) (= (y-coord loc_5_7) 7)

        ; Posizione del personaggio
        (character_at loc_5_4)

        ; Posizione e dimensione delle palle
        (ball_at ball_0 loc_1_3)
        (= (ball_size ball_0) 1)
        (ball_at ball_1 loc_1_5)
        (= (ball_size ball_1) 1)
        (ball_at ball_2 loc_3_1)
        (= (ball_size ball_2) 1)
        (ball_at ball_3 loc_3_3)
        (= (ball_size ball_3) 1)
        (ball_at ball_4 loc_3_4)
        (= (ball_size ball_4) 1)
        (ball_at ball_5 loc_3_5)
        (= (ball_size ball_5) 1)
        (ball_at ball_6 loc_3_7)
        (= (ball_size ball_6) 1)
        (ball_at ball_7 loc_5_3)
        (= (ball_size ball_7) 1)
        (ball_at ball_8 loc_5_5)
        (= (ball_size ball_8) 1)

        ; Locazioni con neve
        (snow loc_1_1)
        (snow loc_1_2)
        (snow loc_1_4)
        (snow loc_1_6)
        (snow loc_1_7)
        (snow loc_2_1)
        (snow loc_2_2)
        (snow loc_2_3)
        (snow loc_2_4)
        (snow loc_2_5)
        (snow loc_2_6)
        (snow loc_2_7)
        (snow loc_3_2)
        (snow loc_3_6)
        (snow loc_4_1)
        (snow loc_4_2)
        (snow loc_4_3)
        (snow loc_4_4)
        (snow loc_4_5)
        (snow loc_4_6)
        (snow loc_4_7)
        (snow loc_5_1)
        (snow loc_5_2)
        (snow loc_5_4)
        (snow loc_5_6)
        (snow loc_5_7)
    )

    (:goal
        (>= (snowman_built) 3)
    )

    (:metric minimize (total-cost))
)